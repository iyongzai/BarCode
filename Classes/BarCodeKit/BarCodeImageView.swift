//
//  BarCodeImageView.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

import UIKit

class BarCodeImageView: UIView {
    
    var barCode: String! {
        didSet { setNeedsDisplay() }
    }
    var barSize = try! BarCodePathGenerator.BarSize(barWidth: BarCodePathGenerator.BarSize.upca.barWidth*4,
                                                    barHeight: BarCodePathGenerator.BarSize.upca.barHeight*4) {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        guard barCode != nil else {
            print("barCode == nil")
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        if let path = BarCodePathGenerator.generate(barcode: .upca(barCode), size: barSize) {
            context?.addPath(path)
        }
        // Store | 描边, 将路径绘制出来 Fill | 填充, 将路径的封闭空间绘制出来
        context?.setLineWidth(barSize.barWidth)
        context?.drawPath(using: .stroke)
    }
}

