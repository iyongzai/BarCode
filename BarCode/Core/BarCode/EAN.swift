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
