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
    
    static let checkDigitInvalid = BarCodeError.digitInvalid("The check digit is incorrect")
    static let notNumber = BarCodeError.formatInvalid("The string is not a numeric type")
    
    static let ean13FormatInvalid = BarCodeError.formatInvalid("The length must be 13 digits")
    static let ean13ContentFormatInvalid = BarCodeError.formatInvalid("The length must be 12 digits")
    
    static let upcaFormatInvalid = BarCodeError.formatInvalid("The length must be 12 digits")
    static let upcaContentFormatInvalid = BarCodeError.formatInvalid("The length must be 11 digits")
}
