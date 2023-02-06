//
//  EX-String-BezierPath.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/5.
//

import Foundation
import CoreText


extension String {
    
    func getBezierPath(font: BCFont, origin: CGPoint = .zero) -> CGPath {

        let ctFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attributed = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : ctFont])
         
        let letters = CGMutablePath()
        
        let line = CTLineCreateWithAttributedString(attributed as CFAttributedString)
        
        let runArray = CTLineGetGlyphRuns(line)
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let  CTFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            let runFont = CFDictionaryGetValue(CTRunGetAttributes(run), CTFontName)
            
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                
                var glyph: CGGlyph = CGGlyph()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                
                var characterPosition = CGPoint.zero
                CTRunGetPositions(run, thisGlyphRange, &characterPosition)
                characterPosition.x += origin.x
                characterPosition.y += origin.y
                
                if let letter = CTFontCreatePathForGlyph(unsafeBitCast(runFont, to: CTFont.self), glyph, nil) {
                    let t = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y+letter.boundingBox.height)
                    letters.addPath(letter, transform: t)
                }
             }
         }
        return letters
     }
}


extension NSAttributedString {
    func getBezierPath(position: CGPoint) -> CGPath {

        let path = CGMutablePath()
        //var characterPaths = [CGPath]()
        let line = CTLineCreateWithAttributedString(self)

        //guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return [] }
        guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return path }


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
                    var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y+glyphPath.boundingBox.height)
                    if let charPath = glyphPath.copy(using: &transform) {
                        path.addPath(charPath)
                    }
                }
            }
        }
        return path
    }
}
