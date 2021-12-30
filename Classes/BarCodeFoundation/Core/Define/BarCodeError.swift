//
//  BarCodeError.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

import Foundation

public enum BarCodeError: Error {
    case digitInvalid(String)
    case formatInvalid(String)
    case dataError(String)
    
    static var checkDigitInvalid: BarCodeError          { BarCodeError.digitInvalid("The check digit is incorrect") }
    static var notNumber: BarCodeError                  { BarCodeError.formatInvalid("The string is not a numeric type") }
    
    static var ean13FormatInvalid: BarCodeError         { BarCodeError.formatInvalid("The length must be 13 digits") }
    static var ean13ContentFormatInvalid: BarCodeError  { BarCodeError.formatInvalid("The length must be 12 digits") }
    static var ean8FormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 8 digits") }
    static var ean8ContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 7 digits") }
    
    static var upcaFormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 12 digits") }
    static var upcaContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 11 digits") }
    static var upceFormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 8 digits") }
    static var upceContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 6 or 7 digits, and the first digit must be 0 or 1 when the length is 7") }
    static var upcaConvertToUpceError: BarCodeError     { BarCodeError.formatInvalid("UPCA convert to UPCE error") }
    
    var desc: String {
        switch self {
        case .digitInvalid(let message):
            return message
        case .formatInvalid(let message):
            return message
        case .dataError(let message):
            return message
        }
    }
}
