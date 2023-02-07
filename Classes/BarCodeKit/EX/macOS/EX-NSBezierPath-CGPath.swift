//
//  EX-NSBezierPath-CGPath.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/12/6.
//

import AppKit
import CoreGraphics

extension NSBezierPath {
    
    convenience init(cgPath: CGPath) {
        self.init()
        cgPath.applyWithBlock { elementPointer in
            let points = elementPointer.pointee.points
            switch elementPointer.pointee.type {
            case .moveToPoint:
                self.move(to: points[0] as NSPoint)
            case .addLineToPoint:
                self.line(to: points[0] as NSPoint)
            case .addQuadCurveToPoint:
                let qp0 = self.currentPoint
                let qp1 = points[0] as NSPoint
                let qp2 = points[1] as NSPoint
                var cp1: NSPoint = .zero
                var cp2: NSPoint = .zero
                let m: CGFloat = (2.0 / 3.0)
                cp1.x = (qp0.x + ((qp1.x - qp0.x) * m))
                cp1.y = (qp0.y + ((qp1.y - qp0.y) * m))
                cp2.x = (qp2.x + ((qp1.x - qp2.x) * m))
                cp2.y = (qp2.y + ((qp1.y - qp2.y) * m))
                self.curve(to: qp2, controlPoint1: cp1, controlPoint2: cp2)
            case .addCurveToPoint:
                self.curve(to: points[2], controlPoint1: points[0], controlPoint2: points[1])
            case .closeSubpath:
                self.close()
            @unknown default:
                fatalError()
            }
        }
    }
}
