
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit

@Observable final class ProfileValue: Equatable, Comparable {

    public let ID: ProfileID
    public var title: ProfileTitle           { didSet { if (oldValue != title)            { _ = self.modelUpdate() } } }
    public var zoom: Decimal                 { didSet { if (oldValue != zoom)             { _ = self.modelUpdate() } } }
    public var spacing: UInt                 { didSet { if (oldValue != spacing)          { _ = self.modelUpdate() } } }
    public var iconOnHoverZoom: Decimal      { didSet { if (oldValue != iconOnHoverZoom)  { _ = self.modelUpdate() } } }
    public var isShowTitle: Bool             { didSet { if (oldValue != isShowTitle)      { _ = self.modelUpdate() } } }
    public var isHideOnMisclick: Bool        { didSet { if (oldValue != isHideOnMisclick) { _ = self.modelUpdate() } } }
    public var isStickyGrid: Bool            { didSet { if (oldValue != isStickyGrid)     { _ = self.modelUpdate() } } }
    public var background: ColorHSBValue     { didSet { if (oldValue != background)       { _ = self.modelUpdate() } } }
    public var backgroundDark: ColorHSBValue { didSet { if (oldValue != backgroundDark)   { _ = self.modelUpdate() } } }

    static var embeddedProfile: Self {
        Self(
            ID              : ThisApp.EMBEDDED_PROFILE_ID,
            title           : NSLocalizedString(ThisApp.NEW_PROFILE_TITLE, comment: ""),
            zoom            : ThisApp.NEW_PROFILE_ZOOM,
            spacing         : ThisApp.NEW_PROFILE_SPACING,
            iconOnHoverZoom : ThisApp.NEW_PROFILE_ICON_ON_HOVER_ZOOM,
            isShowTitle     : ThisApp.NEW_PROFILE_IS_SHOW_TITLE,
            isHideOnMisclick: ThisApp.NEW_PROFILE_IS_HIDE_ON_MISCLICK,
            isStickyGrid    : ThisApp.NEW_PROFILE_IS_STICKY_GRID,
            background      : ThisApp.NEW_PROFILE_BACKGROUND,
            backgroundDark  : ThisApp.NEW_PROFILE_BACKGROUND_DARK
        )
    }

    init(
        ID: ProfileID,
        title: ProfileTitle,
        zoom: Decimal,
        spacing: UInt,
        iconOnHoverZoom: Decimal,
        isShowTitle: Bool,
        isHideOnMisclick: Bool,
        isStickyGrid: Bool,
        background: ColorHSBValue,
        backgroundDark: ColorHSBValue
    ) {
        self.ID = ID
        self.title = title
        self.zoom = zoom
        self.spacing = spacing
        self.iconOnHoverZoom = iconOnHoverZoom
        self.isShowTitle = isShowTitle
        self.isHideOnMisclick = isHideOnMisclick
        self.isStickyGrid = isStickyGrid
        self.background = background
        self.backgroundDark = backgroundDark
    }

    init?(ID: ProfileID) {
        guard let modelProfile = ModelProfile.select(ID: ID) else { return nil }
        self.ID               = modelProfile.id
        self.title            = modelProfile.title
        self.zoom             = modelProfile.zoom
        self.spacing          = modelProfile.spacing
        self.iconOnHoverZoom  = modelProfile.iconOnHoverZoom
        self.isShowTitle      = modelProfile.isShowTitle
        self.isHideOnMisclick = modelProfile.isHideOnMisclick
        self.isStickyGrid     = modelProfile.isStickyGrid
        self.background       = ColorHSBValue(decode: modelProfile.background)     ?? ThisApp.NEW_PROFILE_BACKGROUND
        self.backgroundDark   = ColorHSBValue(decode: modelProfile.backgroundDark) ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK
    }

    static func == (lhs: ProfileValue, rhs: ProfileValue) -> Bool {
        lhs.ID               == rhs.ID               &&
        lhs.title            == rhs.title            &&
        lhs.zoom             == rhs.zoom             &&
        lhs.spacing          == rhs.spacing          &&
        lhs.iconOnHoverZoom  == rhs.iconOnHoverZoom  &&
        lhs.isShowTitle      == rhs.isShowTitle      &&
        lhs.isHideOnMisclick == rhs.isHideOnMisclick &&
        lhs.isStickyGrid     == rhs.isStickyGrid     &&
        lhs.background       == rhs.background       &&
        lhs.backgroundDark   == rhs.backgroundDark
    }

    static func < (lhs: ProfileValue, rhs: ProfileValue) -> Bool {
        lhs.title < rhs.title
    }

    func modelUpdate() -> Bool {
        ModelProfile.update(
            ModelProfile(
                ID              : self.ID,
                title           : self.title,
                zoom            : self.zoom,
                spacing         : self.spacing,
                iconOnHoverZoom : self.iconOnHoverZoom,
                isShowTitle     : self.isShowTitle,
                isHideOnMisclick: self.isHideOnMisclick,
                isStickyGrid    : self.isStickyGrid,
                background      : self.background    .encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_ENCODED,
                backgroundDark  : self.backgroundDark.encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK_ENCODED
            ), autoInsert: true
        )
    }

    func modelInsert() -> Bool {
        ModelProfile.insert(
            ModelProfile(
                ID              : self.ID,
                title           : self.title,
                zoom            : self.zoom,
                spacing         : self.spacing,
                iconOnHoverZoom : self.iconOnHoverZoom,
                isShowTitle     : self.isShowTitle,
                isHideOnMisclick: self.isHideOnMisclick,
                isStickyGrid    : self.isStickyGrid,
                background      : self.background    .encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_ENCODED,
                backgroundDark  : self.backgroundDark.encode() ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK_ENCODED
            )
        )
    }

    static func modelSelectAll() -> [ProfileID: ProfileValue] {
        var result: [ProfileID: ProfileValue] = [:]
        ModelProfile.selectAll().forEach { (ID: ProfileID, modelProfile: ModelProfile) in
            result[ID] = ProfileValue(
                ID              : ID,
                title           : modelProfile.title,
                zoom            : modelProfile.zoom,
                spacing         : modelProfile.spacing,
                iconOnHoverZoom : modelProfile.iconOnHoverZoom,
                isShowTitle     : modelProfile.isShowTitle,
                isHideOnMisclick: modelProfile.isHideOnMisclick,
                isStickyGrid    : modelProfile.isStickyGrid,
                background      : ColorHSBValue(decode: modelProfile.background     ) ?? ThisApp.NEW_PROFILE_BACKGROUND,
                backgroundDark  : ColorHSBValue(decode: modelProfile.backgroundDark ) ?? ThisApp.NEW_PROFILE_BACKGROUND_DARK
            )
        }
        return result
    }

    static func modelDelete(_ ID: ProfileID) -> Bool {
        ModelProfile.delete(ID: ID)
    }

}
