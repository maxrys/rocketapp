
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

typealias BundleID = String
typealias ProfileID = UInt16
typealias ProfileTitle = String
typealias CellsByAxisCount = UInt8
typealias CellsDataSource = Dictionary<CellIDValue, CellValue>
typealias CellValuePath = WritableKeyPath<MiniGridValue, AppValue?>
typealias CellID_CellValue_Pair = (cellID: CellIDValue, cellValue: CellValue)
