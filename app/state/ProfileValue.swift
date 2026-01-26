
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit

@Observable final class ProfileValue: Equatable, Comparable {

    public let ID: ProfileID
    public var title: ProfileTitle           { didSet { if (oldValue != title)                 { _ = self.modelUpdate() } } }
    public var zoom: Decimal                 { didSet { if (oldValue != zoom)                  { _ = self.modelUpdate() } } }
    public var spacing: UInt                 { didSet { if (oldValue != spacing)               { _ = self.modelUpdate() } } }
    public var iconOnHoverZoom: Decimal      { didSet { if (oldValue != iconOnHoverZoom)       { _ = self.modelUpdate() } } }
    public var isShowIconTitle: Bool         { didSet { if (oldValue != isShowIconTitle)       { _ = self.modelUpdate() } } }
    public var isHideOnMisclick: Bool        { didSet { if (oldValue != isHideOnMisclick)      { _ = self.modelUpdate() } } }
    public var isStickyGrid: Bool            { didSet { if (oldValue != isStickyGrid)          { _ = self.modelUpdate() } } }
    public var isShowWinTitleButtons: Bool   { didSet { if (oldValue != isShowWinTitleButtons) { _ = self.modelUpdate() } } }
    public var background: ColorHSBValue     { didSet { if (oldValue != background)            { _ = self.modelUpdate() } } }
    public var backgroundDark: ColorHSBValue { didSet { if (oldValue != backgroundDark)        { _ = self.modelUpdate() } } }

    static var embeddedProfile: Self {
        Self(
            ID                   : ThisApp.EMBEDDED_PROFILE_ID,
            title                : NSLocalizedString(ThisApp.NEW_PROFILE_TITLE, comment: ""),
            zoom                 : ThisApp.NEW_PROFILE_ZOOM,
            spacing              : ThisApp.NEW_PROFILE_SPACING,
            iconOnHoverZoom      : ThisApp.NEW_PROFILE_ICON_ON_HOVER_ZOOM,
            isShowIconTitle      : ThisApp.NEW_PROFILE_IS_SHOW_ICON_TITLE,
            isHideOnMisclick     : ThisApp.NEW_PROFILE_IS_HIDE_ON_MISCLICK,
            isStickyGrid         : ThisApp.NEW_PROFILE_IS_STICKY_GRID,
            isShowWinTitleButtons: ThisApp.NEW_PROFILE_IS_SHOW_WINDOW_TITLE_BUTTONS,
            background           : ThisApp.NEW_PROFILE_BACKGROUND,
            backgroundDark       : ThisApp.NEW_PROFILE_BACKGROUND_DARK
        )
    }

    init(
        ID: ProfileID,
        title: ProfileTitle,
        zoom: Decimal,
        spacing: UInt,
        iconOnHoverZoom: Decimal,
        isShowIconTitle: Bool,
        isHideOnMisclick: Bool,
        isStickyGrid: Bool,
        isShowWinTitleButtons: Bool,
        background: ColorHSBValue,
        backgroundDark: ColorHSBValue
    ) {
        self.ID = ID
        self.title = title
        self.zoom = zoom
        self.spacing = spacing
        self.iconOnHoverZoom = iconOnHoverZoom
        self.isShowIconTitle = isShowIconTitle
        self.isHideOnMisclick = isHideOnMisclick
        self.isStickyGrid = isStickyGrid
        self.isShowWinTitleButtons = isShowWinTitleButtons
        self.background = background
        self.backgroundDark = backgroundDark
    }

    init?(ID: ProfileID) {
        guard let modelProfile = ModelProfile.select(ID: ID) else { return nil }
        self.ID                    = modelProfile.id
        self.title                 = modelProfile.title
        self.zoom                  = modelProfile.zoom
        self.spacing               = modelProfile.spacing
        self.iconOnHoverZoom       = modelProfile.iconOnHoverZoom
        self.isShowIconTitle       = modelProfile.isShowIconTitle
        self.isHideOnMisclick      = modelProfile.isHideOnMisclick
        self.isStickyGrid          = modelProfile.isStickyGrid
        self.isShowWinTitleButtons = modelProfile.isShowWinTitleButtons
        self.background            = ColorHSBValue(decode: modelProfile.background)     ?? ThisApp.NEW_PROFILE_BACKGROUND
        self.backgroundDark        = ColorHSBValue(decode: modelProfile.backgroundDark) ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK
    }

    static func == (lhs: ProfileValue, rhs: ProfileValue) -> Bool {
        lhs.ID                    == rhs.ID                    &&
        lhs.title                 == rhs.title                 &&
        lhs.zoom                  == rhs.zoom                  &&
        lhs.spacing               == rhs.spacing               &&
        lhs.iconOnHoverZoom       == rhs.iconOnHoverZoom       &&
        lhs.isShowIconTitle       == rhs.isShowIconTitle       &&
        lhs.isHideOnMisclick      == rhs.isHideOnMisclick      &&
        lhs.isStickyGrid          == rhs.isStickyGrid          &&
        lhs.isShowWinTitleButtons == rhs.isShowWinTitleButtons &&
        lhs.background            == rhs.background            &&
        lhs.backgroundDark        == rhs.backgroundDark
    }

    static func < (lhs: ProfileValue, rhs: ProfileValue) -> Bool {
        lhs.title < rhs.title
    }

    func modelUpdate() -> Bool {
        ModelProfile.update(
            ModelProfile(
                ID                   : self.ID,
                title                : self.title,
                zoom                 : self.zoom,
                spacing              : self.spacing,
                iconOnHoverZoom      : self.iconOnHoverZoom,
                isShowIconTitle      : self.isShowIconTitle,
                isHideOnMisclick     : self.isHideOnMisclick,
                isStickyGrid         : self.isStickyGrid,
                isShowWinTitleButtons: self.isShowWinTitleButtons,
                background           : self.background    .encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_ENCODED,
                backgroundDark       : self.backgroundDark.encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK_ENCODED
            ), autoInsert: true
        )
    }

    func modelInsert() -> Bool {
        ModelProfile.insert(
            ModelProfile(
                ID                   : self.ID,
                title                : self.title,
                zoom                 : self.zoom,
                spacing              : self.spacing,
                iconOnHoverZoom      : self.iconOnHoverZoom,
                isShowIconTitle      : self.isShowIconTitle,
                isHideOnMisclick     : self.isHideOnMisclick,
                isStickyGrid         : self.isStickyGrid,
                isShowWinTitleButtons: self.isShowWinTitleButtons,
                background           : self.background    .encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_ENCODED,
                backgroundDark       : self.backgroundDark.encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK_ENCODED
            )
        )
    }

    static func modelSelectAll() -> [ProfileID: ProfileValue] {
        var result: [ProfileID: ProfileValue] = [:]
        for (modelProfileID, modelProfile) in ModelProfile.selectAll() {
            result[modelProfileID] = ProfileValue(
                ID                   : modelProfileID,
                title                : modelProfile.title,
                zoom                 : modelProfile.zoom,
                spacing              : modelProfile.spacing,
                iconOnHoverZoom      : modelProfile.iconOnHoverZoom,
                isShowIconTitle      : modelProfile.isShowIconTitle,
                isHideOnMisclick     : modelProfile.isHideOnMisclick,
                isStickyGrid         : modelProfile.isStickyGrid,
                isShowWinTitleButtons: modelProfile.isShowWinTitleButtons,
                background           : ColorHSBValue(decode: modelProfile.background     ) ?? ThisApp.NEW_PROFILE_BACKGROUND,
                backgroundDark       : ColorHSBValue(decode: modelProfile.backgroundDark ) ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK
            )
        }
        return result
    }

    static func modelDelete(_ ID: ProfileID) -> Bool {
        ModelProfile.delete(ID: ID)
    }

}
