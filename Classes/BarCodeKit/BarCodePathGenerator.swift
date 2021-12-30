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


public struct BarCodeImageSize {
    /// standard bar's width and height. 标准尺寸时的条宽(0.936 = 0.013/(1/72.0))和条高(73.44 = 1.02/(1/72.0))
    static let upca = BarCodeImageSize(barWidth: 0.936, barHeight: 73.44)
    var barWidth: CGFloat
    var barHeight: CGFloat
    var quietZoneWidth: CGFloat { 9.5*barWidth }
    var scale: CGFloat { barWidth/BarCodeImageSize.upca.barWidth }
    
    public init(barWidth: CGFloat, barHeight: CGFloat) {
        self.barWidth = barWidth
        self.barHeight = barHeight
    }
    
    public func scale(_ scale: CGFloat) -> BarCodeImageSize {
        return BarCodeImageSize(barWidth: self.barWidth*scale, barHeight: self.barHeight*scale)
    }
}

class BarCodePathGenerator {
    
    /// generate path
    /// - Parameters:
    ///   - barcode: barcode
    ///   - size: bar width, bar height.
    /// - Returns: path
    static func generate(barcode: BarCodeType, size: BarCodeImageSize = BarCodeImageSize.upca, font: BarCodeFont) -> CGPath? {
        switch barcode {
        case .ean13(_):
            return nil
        case .upca(let upca):
            return try? generateUPCA(upca, size: size, font: font)
        case .upce(let upce):
            return try? generateUPCE(upce, size: size, font: font)
        }
    }
}
