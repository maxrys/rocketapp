
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
        #expect( CellID(rowNum: 0x00, colNum: 0x00).value == 0x0000 )
        #expect( CellID(rowNum: 0x00, colNum: 0x0f).value == 0x000f )
        #expect( CellID(rowNum: 0x00, colNum: 0xf0).value == 0x00f0 )
        #expect( CellID(rowNum: 0x0f, colNum: 0x00).value == 0x0f00 )
        #expect( CellID(rowNum: 0xf0, colNum: 0x00).value == 0xf000 )

        #expect( CellID(rowNum: 0xff, colNum: 0xff).value == 0xffff )
        #expect( CellID(rowNum: 0xff, colNum: 0xf0).value == 0xfff0 )
        #expect( CellID(rowNum: 0xff, colNum: 0x0f).value == 0xff0f )
        #expect( CellID(rowNum: 0xf0, colNum: 0xff).value == 0xf0ff )
        #expect( CellID(rowNum: 0x0f, colNum: 0xff).value == 0x0fff )
    }

    @Test func test_cellModelID() async throws {
        #expect( CellModelID(ID: 0x000f, sector: 0x00).value == 0x000f00 + 0x00 )
        #expect( CellModelID(ID: 0x00f0, sector: 0x00).value == 0x00f000 + 0x00 )
        #expect( CellModelID(ID: 0x0f00, sector: 0x00).value == 0x0f0000 + 0x00 )
        #expect( CellModelID(ID: 0xf000, sector: 0x00).value == 0xf00000 + 0x00 )

        #expect( CellModelID(ID: 0x000f, sector: 0x07).value == 0x000f00 + 0x07 )
        #expect( CellModelID(ID: 0x00f0, sector: 0x07).value == 0x00f000 + 0x07 )
        #expect( CellModelID(ID: 0x0f00, sector: 0x07).value == 0x0f0000 + 0x07 )
        #expect( CellModelID(ID: 0xf000, sector: 0x07).value == 0xf00000 + 0x07 )

        #expect( CellModelID(ID: 0x000f, sector: 0x70).value == 0x000f00 + 0x70 )
        #expect( CellModelID(ID: 0x00f0, sector: 0x70).value == 0x00f000 + 0x70 )
        #expect( CellModelID(ID: 0x0f00, sector: 0x70).value == 0x0f0000 + 0x70 )
        #expect( CellModelID(ID: 0xf000, sector: 0x70).value == 0xf00000 + 0x70 )

        #expect( CellModelID(decodeFrom: 0x0000000f00 + 0x00) == CellModelID(ID: 0x0000000f, sector: 0x00) )
        #expect( CellModelID(decodeFrom: 0x000000f000 + 0x00) == CellModelID(ID: 0x000000f0, sector: 0x00) )
        #expect( CellModelID(decodeFrom: 0x00000f0000 + 0x00) == CellModelID(ID: 0x00000f00, sector: 0x00) )
        #expect( CellModelID(decodeFrom: 0x0000f00000 + 0x00) == CellModelID(ID: 0x0000f000, sector: 0x00) )

        #expect( CellModelID(decodeFrom: 0x0000000f00 + 0x07) == CellModelID(ID: 0x0000000f, sector: 0x07) )
        #expect( CellModelID(decodeFrom: 0x000000f000 + 0x07) == CellModelID(ID: 0x000000f0, sector: 0x07) )
        #expect( CellModelID(decodeFrom: 0x00000f0000 + 0x07) == CellModelID(ID: 0x00000f00, sector: 0x07) )
        #expect( CellModelID(decodeFrom: 0x0000f00000 + 0x07) == CellModelID(ID: 0x0000f000, sector: 0x07) )

        #expect( CellModelID(decodeFrom: 0x0000000f00 + 0x70) == CellModelID(ID: 0x0000000f, sector: 0x70) )
        #expect( CellModelID(decodeFrom: 0x000000f000 + 0x70) == CellModelID(ID: 0x000000f0, sector: 0x70) )
        #expect( CellModelID(decodeFrom: 0x00000f0000 + 0x70) == CellModelID(ID: 0x00000f00, sector: 0x70) )
        #expect( CellModelID(decodeFrom: 0x0000f00000 + 0x70) == CellModelID(ID: 0x0000f000, sector: 0x70) )
    }

}
