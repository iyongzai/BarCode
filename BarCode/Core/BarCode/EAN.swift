//
//  EAN.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

import Foundation

public struct EAN13: BarCodeProtocol {
    
    public let barCode: String
    public var payload: String { barCode[0..<12] }
    public var checkDigit: String { barCode[12..<13] }
    
    public static func generate(payload: String) throws -> String {
        let checkDigit = try caculateCheckDigit(payload: payload)
        
        return "\(payload)\(checkDigit)"
    }
    
    /*
     EAN13 Check Digit
     English:
     Suppose the EAN content is numbered sequentially from left to right: N13, N12, N11, N10, N9, N8, N7, N6, N5, N4, N3, N2, N1, where N1 is the check digit required for preparation:
     1. sum1=(N2+N4+N6+N8+N10+N12)*3;
     2. sum2=N3+N5+N7+N9+N11+N13;
     3. Add sum1 and sum2, take the single digit and set it as mod10;
     4. Check digit N1 = 10-mod10 == 10 ? 0 : 10-mod10
     Chinese:
     内容部分从右往左，基数位权数为3，偶数位权数为1
     1、计算出奇数位之和
     2、计算出偶数位之和
     3、(奇数位之和*3+偶数位之和)对10求余数
     4、如果余数为0，校验位就是0，否则校验位为10-余数
     */
    
    public static func caculateCheckDigit(payload: String) throws -> Int {

        guard BarCodeValidateRegex.ContentValidateRegex.ean13(payload).isRight else {
            throw BarCodeError.ean13ContentFormatInvalid
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
        guard BarCodeValidateRegex.ean13(barCode).isRight else {
            throw BarCodeError.ean13FormatInvalid
        }
        let checkDigit = try caculateCheckDigit(payload: barCode[0..<12])
        
        return barCode.last!.asciiValue!-48 == checkDigit
    }
    
    public init(barCode: String) throws {
        guard BarCodeValidateRegex.ean13(barCode).isRight else {
            throw BarCodeError.ean13FormatInvalid
        }
        self.barCode = barCode
    }
    public init(payload: String) throws {
        guard BarCodeValidateRegex.ContentValidateRegex.ean13(payload).isRight else {
            throw BarCodeError.ean13ContentFormatInvalid
        }
        self.barCode = try Self.generate(payload: payload)
    }
}