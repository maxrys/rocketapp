
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
        #expect( CellID(rowNum: 0, colNum: 0b0000).value == 0b0_00000000 + 0b0000 )
        #expect( CellID(rowNum: 0, colNum: 0b0001).value == 0b0_00000000 + 0b0001 )
        #expect( CellID(rowNum: 0, colNum: 0b0010).value == 0b0_00000000 + 0b0010 )
        #expect( CellID(rowNum: 0, colNum: 0b0011).value == 0b0_00000000 + 0b0011 )
        #expect( CellID(rowNum: 0, colNum: 0b0100).value == 0b0_00000000 + 0b0100 )
        #expect( CellID(rowNum: 0, colNum: 0b0101).value == 0b0_00000000 + 0b0101 )
        #expect( CellID(rowNum: 0, colNum: 0b0110).value == 0b0_00000000 + 0b0110 )
        #expect( CellID(rowNum: 0, colNum: 0b0111).value == 0b0_00000000 + 0b0111 )
        #expect( CellID(rowNum: 0, colNum: 0b1000).value == 0b0_00000000 + 0b1000 )

        #expect( CellID(rowNum: 1, colNum: 0b0000).value == 0b1_00000000 + 0b0000 )
        #expect( CellID(rowNum: 1, colNum: 0b0001).value == 0b1_00000000 + 0b0001 )
        #expect( CellID(rowNum: 1, colNum: 0b0010).value == 0b1_00000000 + 0b0010 )
        #expect( CellID(rowNum: 1, colNum: 0b0011).value == 0b1_00000000 + 0b0011 )
        #expect( CellID(rowNum: 1, colNum: 0b0100).value == 0b1_00000000 + 0b0100 )
        #expect( CellID(rowNum: 1, colNum: 0b0101).value == 0b1_00000000 + 0b0101 )
        #expect( CellID(rowNum: 1, colNum: 0b0110).value == 0b1_00000000 + 0b0110 )
        #expect( CellID(rowNum: 1, colNum: 0b0111).value == 0b1_00000000 + 0b0111 )
        #expect( CellID(rowNum: 1, colNum: 0b1000).value == 0b1_00000000 + 0b1000 )

        #expect( CellID(rowNum: 0b0000_0000, colNum: 0b0000_0000).value == 0b0000_0000_0000_0000 + 0b0000_0000 )
        #expect( CellID(rowNum: 0b1111_1111, colNum: 0b0000_0000).value == 0b1111_1111_0000_0000 + 0b0000_0000 )
        #expect( CellID(rowNum: 0b0000_0000, colNum: 0b1111_1111).value == 0b0000_0000_0000_0000 + 0b1111_1111 )
        #expect( CellID(rowNum: 0b1111_1111, colNum: 0b1111_1111).value == 0b1111_1111_0000_0000 + 0b1111_1111 )
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
