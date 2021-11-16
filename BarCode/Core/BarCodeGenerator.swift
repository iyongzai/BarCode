//
//  BarCodeGenerator.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/15.
//

import Foundation

public struct BarCodeGenerator {
    public static func generate(barCodeType: BarCodeType.ContentType) throws -> String {
        switch barCodeType {
        case .ean13(let content):
            return try EAN13.generate(content: content)
        case .upca(let content):
            return try UPCA.generate(content: content)
        }
    }
    public static func checkDigit(barCodeType: BarCodeType) throws -> Bool {
        switch barCodeType {
        case .ean13(let content):
            return try EAN13.checkDigit(barCode: content)
        case .upca(let content):
            return try UPCA.checkDigit(barCode: content)
        }
    }
}
