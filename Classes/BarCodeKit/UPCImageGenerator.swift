//
//  UPCImageGenerator.swift
//  BarCodeDemo
//
//  Created by zhiyong yin on 2021/12/4.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


public class UPCImageGenerator {}

#if os(iOS)
public extension UPCImageGenerator {
    @available(iOS 4.0, *)
    static func generate(upca: String, conf: BarCodeImageConf) -> UIImage? {
        guard let cgPath = BarCodePathGenerator.generate(barcode: .upca(upca), conf: conf) else {
            print("cgPath is nil")
            return nil
        }
        let path = UIBezierPath.init(cgPath: cgPath)
        path.lineWidth = conf.size.barWidth
        
        return generate(path: path, backgroundColor: conf.backgroundColor)
    }
    static func generate(upce: String, conf: BarCodeImageConf) -> UIImage? {
        guard let cgPath = BarCodePathGenerator.generate(barcode: .upce(upce), conf: conf) else {
            print("cgPath is nil")
            return nil
        }
        let path = UIBezierPath.init(cgPath: cgPath)
        path.lineWidth = conf.size.barWidth
        
        return generate(path: path, backgroundColor: conf.backgroundColor)
    }
    static func generate(path: UIBezierPath, backgroundColor: UIColor = .white) -> UIImage? {
        let imageSize = path.bounds.size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        //this gets the graphic context
        let context = UIGraphicsGetCurrentContext()
        
        //you can stroke and/or fill
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(CGRect(origin: .zero, size: imageSize))
        path.stroke()
        
        //now get the image from the context
        let bezierImage = UIGraphicsGetImageFromCurrentImageContext()
//        try? bezierImage?.pngData()?.write(to: URL(fileURLWithPath: "\(NSHomeDirectory())/tmp/upca.png"))
        UIGraphicsEndImageContext()
        
        return bezierImage
    }
}

#elseif os(macOS)
public extension UPCImageGenerator {
    @available(macOS 8.0, *)
    static func generate(upca: String, conf: BarCodeImageConf) -> NSImage! {
        
        guard let cgPath = BarCodePathGenerator.generate(barcode: .upca(upca), conf: conf) else {
            print("cgPath is nil")
            return nil
        }
        let path = NSBezierPath(cgPath: cgPath)
        path.lineWidth = conf.size.barWidth
        
        let canvas = NSImage(size: path.bounds.size, flipped: true) { rect in
            conf.backgroundColor.setFill()
            conf.barColor.setStroke()
            rect.fill()
            path.stroke()
            return true
        }
        
//        do {
//            try canvas.save(to: "\(NSHomeDirectory())/Downloads/drawPath.png")
//        } catch let error {
//            print(error)
//        }
                
        return canvas
    }
    @available(macOS 8.0, *)
    static func generate(upce: String, conf: BarCodeImageConf) -> NSImage! {
        
        guard let cgPath = BarCodePathGenerator.generate(barcode: .upce(upce), conf: conf) else {
            print("cgPath is nil")
            return nil
        }
        let path = NSBezierPath(cgPath: cgPath)
        path.lineWidth = conf.size.barWidth
        
        let canvas = NSImage(size: path.bounds.size, flipped: true) { rect in
            conf.backgroundColor.setFill()
            conf.barColor.setStroke()
            rect.fill()
            path.stroke()
            return true
        }
        
//        do {
//            try canvas.save(to: "\(NSHomeDirectory())/Downloads/drawPath.png")
//        } catch let error {
//            print(error)
//        }
                
        return canvas
    }

}
#endif

