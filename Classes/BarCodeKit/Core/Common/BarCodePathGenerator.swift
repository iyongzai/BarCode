//
//  BarCodePathGenerator.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

import CoreGraphics
import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class BarCodePathGenerator {
    
    /// generate path
    /// - Parameters:
    ///   - barcode: barcode
    ///   - conf: include bar width, bar height and so on.
    /// - Returns: path
    public static func generate(barcode: BarCodeType, conf: BarCodeImageConf) -> CGPath? {
        switch barcode {
        case .ean13(_):
            return nil
        case .upca(let upca):
            return try? generateUPCA(upca, conf: conf)
        case .upce(let upce):
            return try? generateUPCE(upce, conf: conf)
        }
    }
}
