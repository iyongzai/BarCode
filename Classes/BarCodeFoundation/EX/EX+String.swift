//
//  EX+String.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/15.
//

import Foundation

extension String {
    
    //    let str = "1234567890"
    //
    //    let str1 = str[6]    // 获取某一个下标的字符串
    //      // 7
    //
    //    let str2 = str[2..<6]   // 获取下标 n到m的字符串 0 <= n < m <= str.count
    //        // 3456
    //
    //    let str3 = str[2,6]     // 获取下标n 长度len 的字符串
    //        // 345678
    //
    //    let str4 = str.substring(to: 5)   //从 0 到 n个 ，也就是前面n个字符
    //        // 12345
    //
    //    let str5 = str.substring(from: 5) // 从 n 到 尾
    //        // 67890
    
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
}

