//
//  BarCodeType.swift
//  BarCode
//
//  Created by ayong on 2021/11/15.
//

import Foundation

public enum BarCodeType {
    
    public enum ContentType {
        case ean13(String)
        case upca(String)
        case mikReceipt(String)
    }
    
    case ean13(String)
    case upca(String)
    case mikReceipt(String)
}
