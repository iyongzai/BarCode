//
//  BarCodeImageConf.swift
//  BarCode
//
//  Created by ayong on 2022/8/9.
//

import Foundation

#if os(iOS)
import UIKit
public typealias BCColor = UIColor
public typealias BCFont = UIFont
#elseif os(macOS)
import AppKit
public typealias BCColor = NSColor
public typealias BCFont = NSFont
#endif



public struct BarCodeImageConf {
    public var backgroundColor: BCColor = .white
    public var barColor: BCColor = .black
    public var font: BarCodeFont = .default
    public var size: BarCodeImageSize = .upca
}

public enum BarCodeFont {
    case `default`
    case scaleWithFontName(String)
    case font(BCFont)
    case none
}

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
