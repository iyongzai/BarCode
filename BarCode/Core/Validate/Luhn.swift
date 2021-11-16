//
//  Luhn.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

import Foundation


public struct Luhn {
    public static func luhn(_ number: String) -> Bool {
        return number.reversed().enumerated().map({
            let digit = Int(String($0.element))!
            let even = $0.offset % 2 == 0
            return even ? digit : digit == 9 ? 9 : digit * 2 % 9
        }).reduce(0, +) % 10 == 0
    }
}

