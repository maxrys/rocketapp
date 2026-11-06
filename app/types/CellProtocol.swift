
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol CellProtocol: View {

    var ID       : CellIDValue { get }
    var size     : CGFloat     { get }
    var isVisible: Bool        { get set }

}
