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
    
    public static var checkDigitInvalid: BarCodeError          { BarCodeError.digitInvalid("The check digit is incorrect") }
    public static var notNumber: BarCodeError                  { BarCodeError.formatInvalid("The string is not a numeric type") }
    
    public static var ean13FormatInvalid: BarCodeError         { BarCodeError.formatInvalid("The length must be 13 digits") }
    public static var ean13ContentFormatInvalid: BarCodeError  { BarCodeError.formatInvalid("The length must be 12 digits") }
    public static var ean8FormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 8 digits") }
    public static var ean8ContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 7 digits") }
    
    public static var upcaFormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 12 digits") }
    public static var upcaContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 11 digits") }
    public static var upceFormatInvalid: BarCodeError          { BarCodeError.formatInvalid("The length must be 8 digits") }
    public static var upceContentFormatInvalid: BarCodeError   { BarCodeError.formatInvalid("The length must be 6 or 7 digits, and the first digit must be 0 or 1 when the length is 7") }
    public static var upcaConvertToUpceError: BarCodeError     { BarCodeError.formatInvalid("UPCA convert to UPCE error") }
    
    public var desc: String {
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
