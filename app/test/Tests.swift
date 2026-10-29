
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Testing
import Foundation

struct Tests {

    @Test func test_bool_operator() async throws {
        var value: Bool!

        value = true ; value &= true ; value &= true ; #expect(value == true )
        value = true ; value &= true ; value &= false; #expect(value == false)
        value = true ; value &= false; value &= true ; #expect(value == false)
        value = true ; value &= false; value &= false; #expect(value == false)
        value = false; value &= true ; value &= true ; #expect(value == false)
        value = false; value &= true ; value &= false; #expect(value == false)
        value = false; value &= false; value &= true ; #expect(value == false)
        value = false; value &= false; value &= false; #expect(value == false)
    }

    @Test func test_CellID() async throws {
        #expect( CellIDValue(rowNum: 0x00, colNum: 0x00).raw == 0x0000 )
        #expect( CellIDValue(rowNum: 0x00, colNum: 0x0f).raw == 0x000f )
        #expect( CellIDValue(rowNum: 0x00, colNum: 0xf0).raw == 0x00f0 )
        #expect( CellIDValue(rowNum: 0x0f, colNum: 0x00).raw == 0x0f00 )
        #expect( CellIDValue(rowNum: 0xf0, colNum: 0x00).raw == 0xf000 )

        #expect( CellIDValue(rowNum: 0xff, colNum: 0xff).raw == 0xffff )
        #expect( CellIDValue(rowNum: 0xff, colNum: 0xf0).raw == 0xfff0 )
        #expect( CellIDValue(rowNum: 0xff, colNum: 0x0f).raw == 0xff0f )
        #expect( CellIDValue(rowNum: 0xf0, colNum: 0xff).raw == 0xf0ff )
        #expect( CellIDValue(rowNum: 0x0f, colNum: 0xff).raw == 0x0fff )
    }

    @Test func test_GridPlaceIDValue() async throws {
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x000f), sector: 0x00).raw == 0x000f00 + 0x00 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x00f0), sector: 0x00).raw == 0x00f000 + 0x00 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x0f00), sector: 0x00).raw == 0x0f0000 + 0x00 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0xf000), sector: 0x00).raw == 0xf00000 + 0x00 )

        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x000f), sector: 0x07).raw == 0x000f00 + 0x07 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x00f0), sector: 0x07).raw == 0x00f000 + 0x07 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x0f00), sector: 0x07).raw == 0x0f0000 + 0x07 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0xf000), sector: 0x07).raw == 0xf00000 + 0x07 )

        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x000f), sector: 0x70).raw == 0x000f00 + 0x70 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x00f0), sector: 0x70).raw == 0x00f000 + 0x70 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0x0f00), sector: 0x70).raw == 0x0f0000 + 0x70 )
        #expect( GridPlaceIDValue(cellID: CellIDValue(raw: 0xf000), sector: 0x70).raw == 0xf00000 + 0x70 )

        #expect( GridPlaceIDValue(raw: 0x0000000f00 + 0x00) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000000f), sector: 0x00) )
        #expect( GridPlaceIDValue(raw: 0x000000f000 + 0x00) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x000000f0), sector: 0x00) )
        #expect( GridPlaceIDValue(raw: 0x00000f0000 + 0x00) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x00000f00), sector: 0x00) )
        #expect( GridPlaceIDValue(raw: 0x0000f00000 + 0x00) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000f000), sector: 0x00) )

        #expect( GridPlaceIDValue(raw: 0x0000000f00 + 0x07) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000000f), sector: 0x07) )
        #expect( GridPlaceIDValue(raw: 0x000000f000 + 0x07) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x000000f0), sector: 0x07) )
        #expect( GridPlaceIDValue(raw: 0x00000f0000 + 0x07) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x00000f00), sector: 0x07) )
        #expect( GridPlaceIDValue(raw: 0x0000f00000 + 0x07) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000f000), sector: 0x07) )

        #expect( GridPlaceIDValue(raw: 0x0000000f00 + 0x70) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000000f), sector: 0x70) )
        #expect( GridPlaceIDValue(raw: 0x000000f000 + 0x70) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x000000f0), sector: 0x70) )
        #expect( GridPlaceIDValue(raw: 0x00000f0000 + 0x70) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x00000f00), sector: 0x70) )
        #expect( GridPlaceIDValue(raw: 0x0000f00000 + 0x70) == GridPlaceIDValue(cellID: CellIDValue(raw: 0x0000f000), sector: 0x70) )
    }

}
