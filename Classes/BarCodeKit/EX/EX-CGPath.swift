//
//  EX-CGPath.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/12/11.
//

import Foundation
import CoreGraphics

extension CGPath {
    func forEach(body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body,to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody,function: callback)
    }
}
