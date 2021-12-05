//
//  EAN.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

// reference: https://en.wikipedia.org/wiki/International_Article_Number

import Foundation


public protocol EAN {
    var payload: String { get }
    var checkDigit: String { get }

    static func generate(payload: String) throws -> String
    static func caculateCheckDigit(payload: String) throws -> Int
    static func checkDigit(barCode: String) throws -> Bool

    init(payload: String) throws
}


/*
 | Number   | Odd     | Even B  | Even C  |
 | -------- | ------- | ------- | ------- |
 | 0        | 0001101 | 0100111 | 1110010 |
 | 1        | 0011001 | 0110011 | 1100110 |
 | 2        | 0010011 | 0011011 | 1101100 |
 | 3        | 0111101 | 0100001 | 1000010 |
 | 4        | 0100011 | 0011101 | 1011100 |
 | 5        | 0110001 | 0111001 | 1001110 |
 | 6        | 0101111 | 0000101 | 1010000 |
 | 7        | 0111011 | 0010001 | 1000100 |
 | 8        | 0110111 | 0001001 | 1001000 |
 | 9        | 0001011 | 0010111 | 1110100 |
 */
public enum EANBarCodeEncoding {
    public static func oddEncoding(for number: UInt8) throws -> [Bool] {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.odd
    }
    public static func evenBEncoding(for number: UInt8) throws -> [Bool] {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.evenB
    }
    public static func evenCEncoding(for number: UInt8) throws -> [Bool] {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.evenC
    }
    
    public typealias EANBarCodeEncodingsTuple = (odd: [Bool], evenB: [Bool], evenC: [Bool])
    public static var allEncodings: [UInt8 : EANBarCodeEncodingsTuple] {
        [0 : ([false,false,false,true,true,false,true], [false,true,false,false,true,true,true], [true,true,true,false,false,true,false]),
         1 : ([false,false,true,true,false,false,true], [false,true,true,false,false,true,true], [true,true,false,false,true,true,false]),
         2 : ([false,false,true,false,false,true,true], [false,false,true,true,false,true,true], [true,true,false,true,true,false,false]),
         3 : ([false,true,true,true,true,false,true], [false,true,false,false,false,false,true], [true,false,false,false,false,true,false]),
         4 : ([false,true,false,false,false,true,true], [false,false,true,true,true,false,true], [true,false,true,true,true,false,false]),
         5 : ([false,true,true,false,false,false,true], [false,true,true,true,false,false,true], [true,false,false,true,true,true,false]),
         6 : ([false,true,false,true,true,true,true], [false,false,false,false,true,false,true], [true,false,true,false,false,false,false]),
         7 : ([false,true,true,true,false,true,true], [false,false,true,false,false,false,true], [true,false,false,false,true,false,false]),
         8 : ([false,true,true,false,true,true,true], [false,false,false,true,false,false,true], [true,false,false,true,false,false,false]),
         9 : ([false,false,false,true,false,true,true], [false,false,true,false,true,true,true], [true,true,true,false,true,false,false])]
    }
}
