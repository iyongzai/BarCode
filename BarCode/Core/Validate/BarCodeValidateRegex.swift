//
//  BarCodeValidateRegex.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/15.
//

import Foundation

public enum BarCodeValidateRegex {
    
    public enum ContentValidateRegex {
        case ean13(String)
        case ean8(String)
        case upca(String)
        case mikReceipt(String)
    }
    
    case number(String)
    case ean13(String)
    case ean8(String)
    case upca(String)
    case mikReceipt(String)
}

public extension BarCodeValidateRegex {
    var isRight: Bool {
        typealias ContentAndRegex = (content: String, regex: String)
        var contentAndRegex: ContentAndRegex
        
        switch self {
        case .number(let content):
            contentAndRegex = (content, "^[0-9]+$")
        case .ean13(let content):
            contentAndRegex = (content, "^[0-9]{13}$")
        case .ean8(let content):
            contentAndRegex = (content, "^[0-9]{8}$")
        case .upca(let content):
            contentAndRegex = (content, "^[0-9]{12}$")
        case .mikReceipt(let content):
            contentAndRegex = (content, "^[0-9]{33}$")
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", contentAndRegex.regex)
        return predicate.evaluate(with: contentAndRegex.content)
    }
}

public extension BarCodeValidateRegex.ContentValidateRegex {
    var isRight: Bool {
        typealias ContentAndRegex = (content: String, regex: String)
        var contentAndRegex: ContentAndRegex
        
        switch self {
        case .ean13(let content):
            contentAndRegex = (content, "^[0-9]{12}$")
        case .ean8(let content):
            contentAndRegex = (content, "^[0-9]{7}$")
        case .upca(let content):
            contentAndRegex = (content, "^[0-9]{11}$")
        case .mikReceipt(let content):
            contentAndRegex = (content, "^[0-9]{32}$")
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", contentAndRegex.regex)
        return predicate.evaluate(with: contentAndRegex.content)
    }
}
