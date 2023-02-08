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

public class BarCodeImageView: UIView {
    public var barCode: BarCodeType! {
        didSet { setNeedsDisplay() }
    }
    public var conf: BarCodeImageConf = .init(backgroundColor: .white, barColor: .black, font: BarCodeFont.scaleWithFontName("PingFangSC-Ultralight"), size: BarCodeImageSize.upca.scale(4)) {
        didSet { setNeedsDisplay() }
    }
    
    public override func draw(_ rect: CGRect) {
        guard barCode != nil else {
            print("barCode == nil")
            return
        }
        
        var p: CGPath!
        switch barCode {
        case .upca(let barCode):
            p = BarCodePathGenerator.generate(barcode: .upca(barCode), conf: conf)
        case .upce(let barCode):
            p = BarCodePathGenerator.generate(barcode: .upce(barCode), conf: conf)
        case .ean13(_):
            return
        case .none:
            return
        }
        guard let path = p else {
            return
        }
        let bezierPath = UIBezierPath(cgPath: path)
        bezierPath.lineWidth = conf.size.barWidth
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        
        bezierPath.stroke()
    }
}

