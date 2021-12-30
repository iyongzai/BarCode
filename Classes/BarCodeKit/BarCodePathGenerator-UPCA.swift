//
//  BarCodePathGenerator-UPCA.swift
//  BarCode
//
//  Created by ayong on 2021/12/30.
//

import CoreGraphics
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


extension BarCodePathGenerator {
    static func generateUPCA(_ upca: String, size: BarCodeImageSize, font: BarCodeFont) throws -> CGPath {
        
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
            let encodings: UInt8 = {
                i < 6
                ? try! EANBarCodeEncoding.oddEncoding(for: UInt8(String(elem))!)
                : try! EANBarCodeEncoding.evenCEncoding(for: UInt8(String(elem))!)
            }()
            for j in 0..<7 {
                let barOrSpace = encodings >> (6-j) & 1
                x += 1*unit
                if barOrSpace != 0 {
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
        // 字体大小 font size
        let stdFontSize: CGFloat = 7*size.scale
        defer {
            x += (size.quietZoneWidth)
            path.move(to: CGPoint(x: x, y: guardLineHeight+stdFontSize))
        }
        // text x
        // 调整字间距 text's space
        var number = 2*Int(size.scale)
        let num = CFNumberCreate(kCFAllocatorDefault, .sInt8Type, &number)
        // 字体 font
        let exfont: EXFont? = {
#if os(iOS)
            switch font {
            case .`default`:
                return UIFont.systemFont(ofSize: stdFontSize, weight: .ultraLight)
            case .scaleWithFontName(let name):
                let ft =  UIFont(name: name, size: stdFontSize)
                assert(ft != nil, "Unavailable font name")
                return ft
            case .font(let ft):
                return ft
            case .none:
                return nil
            }
#elseif os(macOS)
            switch font {
            case .`default`:
                return NSFont.systemFont(ofSize: stdFontSize, weight: .ultraLight)
            case .scaleWithFontName(let name):
                let ft =  NSFont(name: name, size: stdFontSize)
                assert(ft != nil, "Unavailable font name")
                return ft
            case .font(let ft):
                return ft
            case .none:
                return nil
            }
#endif
        }()
        guard let showFont = exfont else {
            return path
        }
        let attributes = [NSAttributedString.Key.font: showFont,
                          NSAttributedString.Key(rawValue: kCTKernAttributeName as String): num! as CFNumber]
        // first number
        var textX: CGFloat = (size.quietZoneWidth)-stdFontSize
        
        var attributedString = NSMutableAttributedString(string: upca[0], attributes: attributes)
        var charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight-showFont.capHeight))
        path.addPath(charsPath)
        
        // left data
        textX = 19.5*unit
        attributedString = NSMutableAttributedString(string: upca[1..<6], attributes: attributes)
        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight+size.scale))
        var transform = CGAffineTransform(translationX: (34*unit-charsPath.boundingBox.width)/2, y: 0)
        path.addPath(charsPath, transform: transform)
        
        // right data
        textX = 59.5*unit
        attributedString = NSMutableAttributedString(string: upca[6..<11], attributes: attributes)
        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight+size.barWidth))
        transform = CGAffineTransform(translationX: (34*unit-charsPath.boundingBox.width)/2, y: 0)
        path.addPath(charsPath, transform: transform)

        
        // last number
        textX = x
        attributedString = NSMutableAttributedString(string: upca[11], attributes: attributes)
        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight-showFont.capHeight))
        path.addPath(charsPath)
        
        return path
    }

}
