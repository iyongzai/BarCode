//
//  UPCAImageGenerator.swift
//  BarCodeDemo
//
//  Created by zhiyong yin on 2021/12/4.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif


public class UPCAImageGenerator {
    @available(iOS 4.0, *)
    public static func generate(upca: String) -> UIImage? {
        
        let size = BarCodePathGenerator.BarSize.upca
        let path = UIBezierPath.init(cgPath: BarCodePathGenerator.generate(barcode: .upca(upca), size: size)!)
        path.lineWidth = size.barWidth

        
        UIGraphicsBeginImageContextWithOptions(path.bounds.size, false, UIScreen.main.scale)
        //this gets the graphic context
        let context = UIGraphicsGetCurrentContext()
        
        //you can stroke and/or fill
        context?.setLineWidth(path.lineWidth)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.strokePath()
        path.stroke()
        
        //now get the image from the context
        let bezierImage = UIGraphicsGetImageFromCurrentImageContext()
        try? bezierImage?.pngData()?.write(to: URL(fileURLWithPath: "\(NSHomeDirectory())/tmp/upca.png"))
        UIGraphicsEndImageContext()
        
        return bezierImage
    }
    
    
}


//extension UPCAImageGenerator {
//    @available(macOS 8.0, *)
//    public static func generate(upca: String) -> NSImage? {
//
//        return nil
//    }
//}
