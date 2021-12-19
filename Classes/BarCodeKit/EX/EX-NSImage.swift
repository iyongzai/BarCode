//
//  EX-NSImage.swift
//  BarCodeDemo-Mac
//
//  Created by zhiyong yin on 2021/12/11.
//

// Reference: https://blog.csdn.net/HeroGuo_JP/article/details/88169702


import Foundation
import AppKit



public extension NSImage {
    enum NSImageSaveOPTError: Error {
    case saveError(String)
    }
    func save(to filePath: String) throws {
        self.lockFocus()
        //先设置 下面一个实例
        guard let bits = NSBitmapImageRep.init(focusedViewRect: NSRect(origin: .zero, size: self.size)) else {
            throw NSImageSaveOPTError.saveError("Create NSBitmapImageRep error")
        }
        self.unlockFocus()
        
        //再设置后面要用到得 props属性
        let imageProps = [NSBitmapImageRep.PropertyKey.compressionFactor : false]

        //之后 转化为NSData 以便存到文件中
        guard let imageData = bits.representation(using: .png, properties: imageProps) else {
            throw NSImageSaveOPTError.saveError("NSBitmapImageRep convert to Data error")
        }

        //设定好文件路径后进行存储就ok了
        try imageData.write(to: URL(fileURLWithPath: filePath), options: .atomic)
    }
}
