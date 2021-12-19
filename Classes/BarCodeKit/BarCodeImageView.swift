//
//  BarCodeImageView.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

class BarCodeImageView: UIView {
    
    var barCode: String! {
        didSet { setNeedsDisplay() }
    }
    var barSize = BarCodeImageSize.upca.scale(4) {
        didSet { setNeedsDisplay() }
    }
    var font = BarCodeFont.scaleWithFontName("PingFangSC-Ultralight") {//BarCodeFont.default {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        guard barCode != nil else {
            print("barCode == nil")
            return
        }
        
        
        guard let path = BarCodePathGenerator.generate(barcode: .upca(barCode), size: barSize, font: font) else {
            return
        }
        let bezierPath = UIBezierPath(cgPath: path)
        bezierPath.lineWidth = barSize.barWidth
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        
        bezierPath.stroke()
    }
}

