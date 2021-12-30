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
        case upca(String)
    }
    
    case number(String)
    case ean13(String)
    case upca(String)
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
        case .upca(let content):
            contentAndRegex = (content, "^[0-9]{12}$")
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
        case .upca(let content):
            contentAndRegex = (content, "^[0-9]{11}$")
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", contentAndRegex.regex)
        return predicate.evaluate(with: contentAndRegex.content)
    }
}
