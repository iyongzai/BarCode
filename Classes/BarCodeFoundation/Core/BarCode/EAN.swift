//
//  EAN.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

// reference: https://en.wikipedia.org/wiki/International_Article_Number

import Foundation


public protocol EAN {
    var barCode: String { get }
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
    public static func oddEncoding(for number: UInt8) throws -> UInt8 {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.odd
    }
    public static func evenBEncoding(for number: UInt8) throws -> UInt8 {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.evenB
    }
    public static func evenCEncoding(for number: UInt8) throws -> UInt8 {
        guard number < 10 else {
            throw BarCodeError.dataError("Value must be less than 10")
        }
        return allEncodings[number]!.evenC
    }
    
    public typealias EANBarCodeEncodingsTuple = (odd: UInt8, evenB: UInt8, evenC: UInt8)
    public static var allEncodings: [UInt8 : EANBarCodeEncodingsTuple] {
        [0 : (0b0001101, 0b0100111, 0b1110010),
         1 : (0b0011001, 0b0110011, 0b1100110),
         2 : (0b0010011, 0b0011011, 0b1101100),
         3 : (0b0111101, 0b0100001, 0b1000010),
         4 : (0b0100011, 0b0011101, 0b1011100),
         5 : (0b0110001, 0b0111001, 0b1001110),
         6 : (0b0101111, 0b0000101, 0b1010000),
         7 : (0b0111011, 0b0010001, 0b1000100),
         8 : (0b0110111, 0b0001001, 0b1001000),
         9 : (0b0001011, 0b0010111, 0b1110100)]
    }
}
