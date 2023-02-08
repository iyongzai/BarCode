//
//  BarCodePathGenerator-UPCE.swift
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


public extension BarCodePathGenerator {
    static func generateUPCE(_ upce: String, conf: BarCodeImageConf) throws -> CGPath {
        let size = conf.size
        let font = conf.font
        
        guard BarCodeValidateRegex.upce(upce).isRight else {
            throw BarCodeError.upceFormatInvalid
        }
        var upceObj: UPCE
        do {
            upceObj = try UPCE(barCode: upce)
        } catch let err { throw err }

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
        let sixDigits = upceObj.sixDigits
        let encodingType = upceObj.encodingType
        for (i, elem) in sixDigits.enumerated() {
            let encodings: UInt8 = {
                encodingType[i] == "O"
                ? try! EANBarCodeEncoding.oddEncoding(for: UInt8(String(elem))!)
                : try! EANBarCodeEncoding.evenBEncoding(for: UInt8(String(elem))!)
            }()
            for j in 0..<7 {
                let barOrSpace = encodings >> (6-j) & 1
                x += 1*unit
                if barOrSpace != 0 {
                    // 12+CGFloat(7*i)+CGFloat(j)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: dataBarHeight))
                }
            }
        }
        // End 010101(space-bar-space-bar-space-bar) 终止符 010101
        x += 2*unit
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: guardLineHeight))
        x += 2*unit
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
        let BCFont: BCFont? = {
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
        guard let showFont = BCFont else {
            return path
        }
        let attributes = [NSAttributedString.Key.font: showFont,
                          NSAttributedString.Key(rawValue: kCTKernAttributeName as String): num! as CFNumber]
        // first number
        var textX: CGFloat = (size.quietZoneWidth)-stdFontSize
        
        var attributedString = NSMutableAttributedString(string: upce[0], attributes: attributes)
//        var charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight-showFont.capHeight))
        var charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight))
        path.addPath(charsPath)
        
        // data
        textX = 12.5*unit
        attributedString = NSMutableAttributedString(string: upce[1..<7], attributes: attributes)
        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight+size.scale))
        let transform = CGAffineTransform(translationX: (41*unit-charsPath.boundingBox.width)/2, y: 0)
        path.addPath(charsPath, transform: transform)
                
        // last number
        textX = x
        attributedString = NSMutableAttributedString(string: upce[7], attributes: attributes)
//        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight-showFont.capHeight))
        charsPath = attributedString.getBezierPath(position: CGPoint(x: textX, y: dataBarHeight))
        path.addPath(charsPath)
        
        return path
    }
}

/*
 | UPC-A check digit | UPC-E parity pattern for UPC-A number system 0 | UPC-E parity pattern for UPC-A number system 1 |
 | :---------------: | :--------------------------------------------: | :--------------------------------------------: |
 |         0         |                     EEEOOO                     |                     OOOEEE                     |
 |         1         |                     EEOEOO                     |                     OOEOEE                     |
 |         2         |                     EEOOEO                     |                     OOEEOE                     |
 |         3         |                     EEOOOE                     |                     OOEEEO                     |
 |         4         |                     EOEEOO                     |                     OEOOEE                     |
 |         5         |                     EOOEEO                     |                     OEEOOE                     |
 |         6         |                     EOOOEE                     |                     OEEEOO                     |
 |         7         |                     EOEOEO                     |                     OEOEOE                     |
 |         8         |                     EOEOOE                     |                     OEOEEO                     |
 |         9         |                     EOOEOE                     |                     OEEOEO                     |
 */
fileprivate extension UPCE {
    static var allEncodingsTypes: [UInt8 : [String]] {
        [0 : ["EEEOOO", "OOOEEE"],
         1 : ["EEOEOO", "OOEOEE"],
         2 : ["EEOOEO", "OOEEOE"],
         3 : ["EEOOOE", "OOEEEO"],
         4 : ["EOEEOO", "OEOOEE"],
         5 : ["EOOEEO", "OEEOOE"],
         6 : ["EOOOEE", "OEEEOO"],
         7 : ["EOEOEO", "OEOEOE"],
         8 : ["EOEOOE", "OEOEEO"],
         9 : ["EOOEOE", "OEEOEO"]]
    }
    /// Encoding type. eg: "EEEOOO"
    var encodingType: String {
        let types = Self.allEncodingsTypes[UInt8(checkDigit)!]!
        return types[Int(systemSymbol)!]
    }
}
