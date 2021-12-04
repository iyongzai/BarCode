//
//  BarCodeProtocol.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/15.
//

import Foundation

public protocol BarCodeProtocol {
    var barCode: String { get }
    
    
    init(barCode: String) throws
}
