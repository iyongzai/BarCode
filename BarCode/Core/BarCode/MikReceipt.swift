//
//  MikReceipt.swift
//  BarCode
//
//  Created by zhiyong yin on 2021/11/16.
//

import Foundation

fileprivate extension MikReceipt {
    /*
     0    1    2    3    4    5    6    7    8    9
     1    5    9    4    8    6    2    3    7    0
     */
    static var valueMap: [Int:Int] { [0:1, 1:5, 2:9, 3:4, 4:8, 5:6, 6:2, 7:3, 8:7, 9:0] }
    static var columnMap: [Int:Int] { [1:1, 2:2, 3:33,
                                       4:31, 5:32, 6:30,
                                       7:28, 8:29, 9:27,
                                       10:25, 11:26, 12:24,
                                       13:22, 14:23, 15:21,
                                       16:19, 17:20, 18:18,
                                       19:16, 20:17, 21:15,
                                       22:13, 23:14, 24:12,
                                       25:10, 26:11, 27:9,
                                       28:7, 29:8, 30:6,
                                       31:4, 32:5, 33:3] }
}

public struct MikReceipt: BarCodeProtocol {
    public var barCode: String
    
    public var payload: String { try! Self.caculatePayload(barCode: barCode) }
    
    public var checkDigit: String { barCode[2] }
    
    
    ///
    /// English:
    /// "Columns 1 & 2 remain in place
    /// Column 3 moved to Column 33
    /// Starting at Column 4 the remainder of the transaction information is placed into 10 chunks.  The chunks are then rearranged and moved from front to back.
    /// Chunk 1
    /// Columns 4, 5, 6 moved to Columns 30, 31, 32 - With Column 4 moving to Column 31, 5 moving to 32 and 6 moving to 30
    /// This same switching is repeated for each of the remaining 9 chunks.
    /// Once the columns have been rearranged then starting at column 3 using a simple cypher the numbers are changed.
    /// The barcode is then generated from this new arrangement.
    /// The Check Digit is a MOD10
    /// Chinese:
    /// 第1列和第2列保持不变
    /// 第3列移动到第33列
    /// 从第4列开始，执行10轮操作
    /// 第1轮
    /// 第4、5、6列分别移动到第31、32、30列
    /// 后面的列执行同样的操作，供再执行9次
    /// 校验位采用对10求余数的算法
    /// - Parameter payload: payload infomation
    /// - Returns: bar code
    public static func generate(payload: String) throws -> String {
        let checkDigit = try caculateCheckDigit(payload: payload)
        //
        // step 1: original infomation
        // eg: 890025105605100000100213150449304
        let originalInfoStr = "\(payload)\(checkDigit)"
        // Original Transaction Information --> Re-Ordered --> Translated
        // step 2: Re-Ordered
        // eg: 894309440153210100000105605105020
        // var reOrderedStr = ""
        // for i in 0..<33 { reOrderedStr += originalInfoStr[columnMap[i+1]!-1] }
        // step 3: Translated
        // eg: 898410881564951511111516216516191
        var translatedStr = ""
        for i in 0..<33 {
            let c = originalInfoStr[columnMap[i+1]!-1]
            if i == 0 || i == 1 {
                translatedStr += c
            }else{
                translatedStr += "\(valueMap[Int(c)!]!)"
            }
        }
        return translatedStr
    }
    
    /*
     Mik Receipt bar code Check Digit
     English:
     Length is 32 digits
     Odd digit weight is 2
     Even bit weight is 1
     The calculation process is as follows:
     Barcode data    8    9    0    0    2    5    1    0    5    6    0    5    1    0    0    0    0    0    1    0    0    2    1    3    1    5    0    4    4    9    3    0
     *****Weights    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1    2    1
     ****Multiply    16    9    0    0    4    5    2    0    10    6    0    5    2    0    0    0    0    0    2    0    0    2    2    3    2    5    0    4    8    9    6    0
     **Add digits    7    9    0    0    4    5    2    0    1    6    0    5    2    0    0    0    0    0    2    0    0    2    2    3    2    5    0    4    8    9    6    0
     Total 84
     Check digit  4

     Chinese:
     内容长度为32位数字，基数位权数为2，偶数位权数为1
     1、每个奇数位数字*权数(2)，得出的结果如果大于9，那么就个位数数字加上十位数数字（也等于结果-9，比如结果16，那么就计算1+6，或者16-9，得到7）
     2、每个偶数位数字*权数(1)
     3、把所有的add digits数字相加，得出总和Total
     4、Total对10求余数，余数就是校验位
     */
    
    public static func caculateCheckDigit(payload: String) throws -> Int {

        guard BarCodeValidateRegex.ContentValidateRegex.mikReceipt(payload).isRight else {
            throw BarCodeError.mikReceiptContentFormatInvalid
        }
        var sum = 0
        for (i, elem) in payload.enumerated() {
            if i%2 == 0 {
                let mValue = Int(elem.asciiValue!-48)*2
                sum += mValue > 9 ? mValue-9 : mValue
            }else{
                sum += Int(elem.asciiValue!-48)
            }
        }
        return sum%10
    }
    
    public static func caculateOriginalInfo(barCode: String) throws -> String {
        guard BarCodeValidateRegex.mikReceipt(barCode).isRight else {
            throw BarCodeError.mikReceiptFormatInvalid
        }
        // Barcode Data --> Translated --> Reordered
        // or
        // Barcode Data --> Reordered --> Translated
        let valueMap: [Int:Int] = {
            var newMap: [Int:Int] = [:]
            Self.valueMap.forEach { newMap[$1] = $0 }
            return newMap
        }()
        var translatedStr = ""
        for i in 0..<33 {
            let c = barCode[columnMap[i+1]!-1]
            if i == 0 || i == 1 {
                translatedStr += c
            }else{
                translatedStr += "\(valueMap[Int(c)!]!)"
            }
        }
        return translatedStr
    }
    public static func caculatePayload(barCode: String) throws -> String {
        let translatedStr = try caculateOriginalInfo(barCode: barCode)
        return translatedStr[0..<32]
    }
    
    public static func checkDigit(barCode: String) throws -> Bool {
        guard BarCodeValidateRegex.mikReceipt(barCode).isRight else {
            throw BarCodeError.mikReceiptFormatInvalid
        }
        let originalInfo = try caculateOriginalInfo(barCode: barCode)
        let payload = originalInfo[0..<32]
        let checkDigit = try caculateCheckDigit(payload: payload)
        
        return originalInfo.last!.asciiValue!-48 == checkDigit
    }
    
    
    public init(barCode: String) throws {
        guard BarCodeValidateRegex.mikReceipt(barCode).isRight else {
            throw BarCodeError.mikReceiptFormatInvalid
        }
        self.barCode = barCode
    }
    public init(payload: String) throws {
        guard BarCodeValidateRegex.ContentValidateRegex.mikReceipt(payload).isRight else {
            throw BarCodeError.mikReceiptContentFormatInvalid
        }
        self.barCode = try Self.generate(payload: payload)
    }
    
}
