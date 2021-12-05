//
//  BarCodePathGenerator.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

import CoreGraphics
import Foundation
import UIKit

class BarCodePathGenerator {
    
    struct BarSize {
        /// standard bar's width and height. 标准尺寸时的条宽(0.936 = 0.013/(1/72.0))和条高(73.44 = 1.02/(1/72.0))
        static let upca = try! BarSize(barWidth: 0.936, barHeight: 73.44)
        var barWidth: CGFloat
        var barHeight: CGFloat
        var quietZoneWidth: CGFloat { 9.5*barWidth }
        var scale: CGFloat { barWidth/BarSize.upca.barWidth }
        
        init(barWidth: CGFloat, barHeight: CGFloat) throws {
            guard barHeight >= 0.8*barHeight, barHeight <= 2*barHeight else {
                throw BarCodeError.dataError("The height of the barcode must be between 80%~200% of the standard height")
            }
            self.barWidth = barWidth
            self.barHeight = barHeight
        }
    }
    
    /// generate path
    /// - Parameters:
    ///   - barcode: barcode
    ///   - size: bar width, bar height.
    /// - Returns: path
    static func generate(barcode: BarCodeType, size: BarSize = BarSize.upca) -> CGPath? {
        switch barcode {
        case .ean13(_):
            return nil
        case .upca(let upca):
            return try? generateUPCA(upca, size: size)
        }
    }
    
    fileprivate static func generateUPCA(_ upca: String, size: BarSize) throws -> CGPath {
        
        guard BarCodeValidateRegex.upca(upca).isRight else {
            throw BarCodeError.upcaFormatInvalid
        }
        //let insets = UIEdgeInsets.zero
        let unit = size.barWidth
        let dataBarHeight: CGFloat = size.barHeight
        let guardLineHeight: CGFloat = dataBarHeight+5*unit
        
        
        let path = CGMutablePath()
        var x: CGFloat = 0
        
        // 9 space for quiet zone 静区9个空
        
        // Start 101(bar-space-bar) 起始符 101
        x = (size.quietZoneWidth)
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: guardLineHeight))
        x += 2*unit
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: guardLineHeight))
        
        // data 数据部分
        for (i, elem) in upca.enumerated() {
            let encodings: [Bool] = {
                i < 6
                ? try! EANBarCodeEncoding.oddEncoding(for: UInt8(String(elem))!)
                : try! EANBarCodeEncoding.evenCEncoding(for: UInt8(String(elem))!)
            }()
            for (j, barOrSpace) in encodings.enumerated() {
                x += 1*unit
                if barOrSpace {
                    // 12+CGFloat(7*i)+CGFloat(j)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: (i == 0 || i == upca.count-1) ? guardLineHeight : dataBarHeight))
                }
            }
            if i == 5 {
                // Middle 中间分隔符
                x += 2*unit
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: guardLineHeight))
                x += 2*unit
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: guardLineHeight))
                x += 1*unit
            }
        }
        // End 101(bar-space-bar) 终止符 101
        x += 1*unit
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: guardLineHeight))
        x += 2*unit
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: guardLineHeight))
        
        x += 2*unit
        path.move(to: CGPoint(x: x, y: 0))
        
//        x += (size.quietZoneWidth)*unit
//        path.move(to: CGPoint(x: x, y: 0))

        // human-readable interpretation
        // text x
        // first number
        let fontSize: CGFloat = 7*size.scale
        var textX: CGFloat = (size.quietZoneWidth)-fontSize
        // 调整字间距
        var number = 2*Int(size.scale)
        let num = CFNumberCreate(kCFAllocatorDefault, .sInt8Type, &number)
        //[attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .ultraLight),
                          NSAttributedString.Key(rawValue: kCTKernAttributeName as String): num! as CFNumber]
        var attributedString = NSMutableAttributedString(string: upca[0], attributes: attributes)
        var charPaths = attributedString.characterPaths(position: CGPoint(x: textX, y: dataBarHeight))
        charPaths.forEach { path.addPath($0) }
        
        // left data
        textX = 20*unit
        attributedString = NSMutableAttributedString(string: upca[1..<6], attributes: attributes)
        charPaths = attributedString.characterPaths(position: CGPoint(x: textX, y: guardLineHeight+fontSize/2))
        charPaths.forEach { path.addPath($0) }
        
        // right data
        textX = 60*unit
        attributedString = NSMutableAttributedString(string: upca[6..<11], attributes: attributes)
        charPaths = attributedString.characterPaths(position: CGPoint(x: textX, y: guardLineHeight+fontSize/2))
        charPaths.forEach { path.addPath($0) }

        
        // last number
        textX = x
        attributedString = NSMutableAttributedString(string: upca[0], attributes: attributes)
        charPaths = attributedString.characterPaths(position: CGPoint(x: textX, y: dataBarHeight))
        charPaths.forEach { path.addPath($0) }
        
        
        x += (size.quietZoneWidth)
        path.move(to: CGPoint(x: x, y: guardLineHeight+fontSize))
        
        return path
    }
}
