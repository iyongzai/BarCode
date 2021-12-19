//
//  BarCodeFont.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/12/19.
//

#if os(iOS)
import UIKit
public typealias EXFont = UIFont
#elseif os(macOS)
import AppKit
public typealias EXFont = NSFont
#endif


public enum BarCodeFont {
    case `default`
    case scaleWithFontName(String)
    case font(EXFont)
    case none
}
