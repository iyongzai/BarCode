//
//  Luhn.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

import Foundation


public struct Luhn {
    public static func generateCheckDigit(payload number: String) throws -> String {
        guard BarCodeValidateRegex.number(number).isRight else {
            throw BarCodeError.notNumber
        }
        let mod10 = number.reversed().enumerated().map({
            let digit = Int(String($0.element))!
            let even = $0.offset % 2 == 1
            return even ? digit : digit == 9 ? 9 : digit * 2 % 9
        }).reduce(0, +) % 10
        return mod10 == 0 ? "0" : "\(10-mod10)"
    }
    // https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Swift
    public static func check(_ number: String) -> Bool {
        return number.reversed().enumerated().map({
            let digit = Int(String($0.element))!
            let even = $0.offset % 2 == 0
            return even ? digit : digit == 9 ? 9 : digit * 2 % 9
        }).reduce(0, +) % 10 == 0
    }
}

