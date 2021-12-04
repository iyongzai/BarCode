//
//  EAN8.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/12/4.
//

import Foundation


public struct EAN8: EAN {
    
    public let barCode: String
    
    public var payload: String { barCode[0..<7] }
    
    public var gs1Prefix: String { barCode[0..<3] }
    
    public var checkDigit: String { String(barCode.last!) }
    
    public static func generate(payload: String) throws -> String {
        do {
            let checkDigit = try caculateCheckDigit(payload: payload)
            return "\(payload)\(checkDigit)"
        } catch let err { throw err }
    }
    
    public static func caculateCheckDigit(payload: String) throws -> Int {
        
        guard BarCodeValidateRegex.ContentValidateRegex.ean8(payload).isRight else {
            throw BarCodeError.ean8ContentFormatInvalid
        }
        var sum1 = 0
        var sum2 = 0
        for (i, elem) in payload.reversed().enumerated() {
            if i%2 == 0 {
                sum1 += Int(elem.asciiValue!-48)
            }else{
                sum2 += Int(elem.asciiValue!-48)
            }
        }
        let mod10 = (sum1*3+sum2)%10
        return mod10 == 0 ? 0 : 10-mod10
    }
    
    public static func checkDigit(barCode: String) throws -> Bool {
        guard BarCodeValidateRegex.ean8(barCode).isRight else {
            throw BarCodeError.ean8FormatInvalid
        }
        do {
            let checkDigit = try caculateCheckDigit(payload: barCode[0..<7])
            return barCode.last!.asciiValue!-48 == checkDigit
        } catch let err { throw err }
    }
    
    public init(barCode: String) throws {
        guard BarCodeValidateRegex.ean8(barCode).isRight else {
            throw BarCodeError.ean8FormatInvalid
        }
        self.barCode = barCode
    }
    
    public init(payload: String) throws {
        guard BarCodeValidateRegex.ContentValidateRegex.ean8(payload).isRight else {
            throw BarCodeError.ean8ContentFormatInvalid
        }
        do {
            self.barCode = try Self.generate(payload: payload)
        } catch let err { throw err }
    }
}
