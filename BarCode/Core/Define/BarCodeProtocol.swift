//
//  BarCodeProtocol.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/15.
//

import Foundation

public protocol BarCodeProtocol {
    var barCode: String { get }
    var payload: String { get }
    var checkDigit: String { get }
    
    static func generate(content: String) throws -> String
    static func caculateCheckDigit(content: String) throws -> Int
    static func checkDigit(barCode: String) throws -> Bool
    
    init(barCode: String) throws
    init(payload: String) throws
}
