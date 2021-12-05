//
//  EX-String-BezierPath.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/5.
//

import Foundation
import CoreText

extension String {
    
//    func generateBezierPath(withMaxWidth: CGFloat) -> CGPath {
//
//        let paths = CGMutablePath()
//        guard let fontName = __CFStringMakeConstantString("SnellRoundhand") else {
//            return paths
//        }
//        let fontRef:AnyObject = CTFontCreateWithName(fontName, 18, nil)
//
//        let attrString = NSAttributedString(string: self, attributes: [NSAttributedString.Key(rawValue: kCTFontAttributeName as String) : fontRef])
//        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
//        let runA = CTLineGetGlyphRuns(line)
//
//
//        for runIndex in 0..<CFArrayGetCount(runA) {
//            let run = CFArrayGetValueAtIndex(runA, runIndex);
//            let runb = unsafeBitCast(run, to: CTRun.self)
//
//            let  CTFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
//
//            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb),CTFontName)
//            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)
//
//            let width = withMaxWidth
//
//            var temp = 0
//            var offset:CGFloat = 0.0
//
//            for i in 0..<CTRunGetGlyphCount(runb) {
//                let range = CFRangeMake(i, 1)
//                let glyph:UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
//                glyph.initialize(to: 0)
//                let position:UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
//                position.initialize(to: .zero)
//                CTRunGetGlyphs(runb, range, glyph)
//                CTRunGetPositions(runb, range, position);
//
//                let temp3 = CGFloat(position.memory.x)
//                let temp2 = (Int) (temp3 / width)
//                let temp1 = 0
//                if(temp2 > temp1){
//
//                    temp = temp2
//                    offset = position.memory.x - (CGFloat(temp) * width)
//                }
//                let path = CTFontCreatePathForGlyph(runFontS,glyph.memory,nil)
//                let x = position.memory.x - (CGFloat(temp) * width) - offset
//                let y = position.memory.y - (CGFloat(temp) * 80)
//                var transform = CGAffineTransformMakeTranslation(x, y)
//                CGPathAddPath(paths, &transform, path)
//                glyph.destroy()
//                glyph.dealloc(1)
//                position.destroy()
//                position.dealloc(1)
//            }
//
//        }
//
//        let bezierPath = UIBezierPath()
//        bezierPath.moveToPoint(CGPointZero)
//        bezierPath.appendPath(UIBezierPath(CGPath: paths))
//
//        return bezierPath
//    }
}


extension NSAttributedString {
    func characterPaths(position: CGPoint) -> [CGPath] {

        let line = CTLineCreateWithAttributedString(self)

        guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}

        var characterPaths = [CGPath]()

        for glyphRun in glyphRuns {
            guard let attributes = CTRunGetAttributes(glyphRun) as? [String:AnyObject] else { continue }
            let font = attributes[kCTFontAttributeName as String] as! CTFont

            for index in 0..<CTRunGetGlyphCount(glyphRun) {
                let glyphRange = CFRangeMake(index, 1)

                var glyph = CGGlyph()
                CTRunGetGlyphs(glyphRun, glyphRange, &glyph)

                var characterPosition = CGPoint()
                CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
                characterPosition.x += position.x
                characterPosition.y += position.y

                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
                    if let charPath = glyphPath.copy(using: &transform) {
                        characterPaths.append(charPath)
                    }
                }
            }
        }
        return characterPaths
    }
}
