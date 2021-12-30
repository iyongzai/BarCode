//
//  UPCE.swift
//  BarCode
//
//  Created by ayong on 2021/12/27.
//

import Foundation


public struct UPCE: EAN {
    
    public let barCode: String
    /// system symbol(1 digits, 0/1)
    public var systemSymbol: String { barCode[0..<1] }
    /// 7 digits
    public var payload: String { barCode[0..<7] }
    public var sixDigits: String { barCode[1..<7] }
    public var checkDigit: String { String(barCode.last!) }
    public var upcaBarCode: String { try! Self.convertToUPCA(from: payload) }
    
    
    /// generate barCode with payload
    /// - Parameter payload: 6/7 digits
    /// - Returns: barCode
    public static func generate(payload: String) throws -> String {
        do {
            let checkDigit = try caculateCheckDigit(payload: payload)
            guard payload.count == 7 else {
                return "0\(payload)\(checkDigit)"
            }
            return "\(payload)\(checkDigit)"
        } catch let err { throw err }
    }
    
    
    /// caculate check digit
    /// - Parameter payload: 6/7 digits
    /// - Returns: return check digit
    public static func caculateCheckDigit(payload: String) throws -> Int {
        guard BarCodeValidateRegex.ContentValidateRegex.upce(payload).isRight else {
            throw BarCodeError.upceContentFormatInvalid
        }
        do {
            let upca = try convertToUPCA(from: payload)
            return Int(String(upca.last!))!
        } catch let err { throw err }
    }

    public static func checkDigit(barCode: String) throws -> Bool {
        guard BarCodeValidateRegex.upce(barCode).isRight else {
            throw BarCodeError.upceFormatInvalid
        }
        do {
            let payload = barCode[0..<7]
            let upca = try convertToUPCA(from: payload)
            return upca.last == barCode.last
        } catch let err { throw err }
    }
    
    static func checkPayloadFormat(payload: String) -> Bool {
        guard BarCodeValidateRegex.ContentValidateRegex.upce(payload).isRight else {
            return false
        }
        guard payload.count == 7 else {
            return true
        }
        return payload[0] == "0" || payload[0] == "1"
    }
    static func formatPayload(_ payload: String) throws -> String {
        guard checkPayloadFormat(payload: payload) else {
            throw BarCodeError.upceContentFormatInvalid
        }
        var rightPayload: String
        switch payload.count {
        case 6:
            rightPayload = "0\(payload)"
        case 7:
            guard payload[0] == "0" || payload[0] == "1" else {
                throw BarCodeError.upceContentFormatInvalid
            }
            rightPayload = payload
        default:
            throw BarCodeError.upceContentFormatInvalid
        }
        return rightPayload
    }
    
    /*
     | UPC-E Number | Insertion Digits | Expanded UPC-A Number |
     | ------------ | ---------------- | --------------------- |
     | # # # # # 0  | 00000            | # # 00000 # # #       |
     | # # # # # 1  | 10000            | # # 10000 # # #       |
     | # # # # # 2  | 20000            | # # 20000 # # #       |
     | # # # # # 3  | 00000            | # # # 00000 # #       |
     | # # # # # 4  | 00000            | # # # # 00000 #       |
     | # # # # # 5  | 0000             | # # # # # 00005       |
     | # # # # # 6  | 0000             | # # # # # 00006       |
     | # # # # # 7  | 0000             | # # # # # 00007       |
     | # # # # # 8  | 0000             | # # # # # 00008       |
     | # # # # # 9  | 0000             | # # # # # 00009       |
     */
    static func convertToUPCA(from payload: String) throws -> String {
        do {
            // 7 digits
            var newPayload = try formatPayload(payload)
            let mfgCodesAndProductCodes = newPayload.substring(from: 1)
            let firstNum = newPayload[0]
            let lastNum = Int(String(mfgCodesAndProductCodes.last!))!
            switch lastNum {
            case 0...2:
                newPayload = mfgCodesAndProductCodes[0..<2]+"\(lastNum)0000"+mfgCodesAndProductCodes[2..<5]
            case 3:
                newPayload = mfgCodesAndProductCodes[0..<3]+"00000"+mfgCodesAndProductCodes[3..<5]
            case 4:
                newPayload = mfgCodesAndProductCodes[0..<4]+"00000"+mfgCodesAndProductCodes[4..<5]
            case 5...9:
                newPayload = mfgCodesAndProductCodes[0..<5]+"0000\(lastNum)"
            default:
                break
            }
            newPayload = firstNum+newPayload
            return try UPCA(payload: newPayload).barCode
        } catch let err { throw err }
    }
    
    public init(barCode: String) throws {
        guard BarCodeValidateRegex.upce(barCode).isRight else {
            throw BarCodeError.upceFormatInvalid
        }
        do {
            guard try Self.checkDigit(barCode: barCode) else {
                throw BarCodeError.checkDigitInvalid
            }
            self.barCode = barCode
        } catch let err {
            throw err
        }
    }
    public init(payload: String) throws {
        guard BarCodeValidateRegex.ContentValidateRegex.upce(payload).isRight else {
            throw BarCodeError.upceContentFormatInvalid
        }
        do {
            self.barCode = try Self.generate(payload: payload)
        } catch let err { throw err }
    }
    /*
     Condition A (Example: 023456000073 = 02345673)
     If D11 equals 5, 6, 7, 8 or 9, and D6 is not 0, and D7-D10 are all 0, then,
     DataToEncode = D1 D2 D3 D4 D5 D6 D11 D12
     
     Condition B (Example: 023450000017 = 02345147)
     If D6-D10 are 0 and D5 is not 0, then,
     DataToEncode = D1 D2 D3 D4 D5 D11 “4” D12
     
     Condition C (Example: 063200009716 = 06397126)
     If D5-D8 = 0 and D4 = 0, 1 or 2, then,
     DataToEncode = D1 D2 D3 D9 D10 D11 D4 D12
     
     Condition D (Example: 086700000939 = 08679339)
     If D5-D9 = 0 and D4 = 3-9, then,
     DataToEncode = D1 D2 D3 D4 D10 D11 “3” D12
     */
    public init(upca upcaObj: UPCA) throws {
        let upca = upcaObj.barCode
        if Int(upca[10])! >= 5, Int(upca[10])! <= 9,
           upca[5] != "0",
           upca[6..<10] == "0000" {
            barCode = upca[0..<6]+upca[10..<12]
        }else if upca[5..<10] == "00000",
                 upca[4] != "0" {
            barCode = upca[0..<5]+upca[10]+"4"+upca[11]
        }else if upca[4..<8] == "0000",
                 Int(upca[3])! >= 0, Int(upca[3])! <= 2 {
            barCode = upca[0..<3]+upca[8..<11]+upca[3]+upca[11]
        }else if upca[4..<9] == "00000",
                 Int(upca[3])! >= 3, Int(upca[3])! <= 9 {
            barCode = upca[0..<4]+upca[9..<11]+"3"+upca[11]
        }else{
            throw BarCodeError.upcaConvertToUpceError
        }
    }
    public init(upca: String) throws {
        do {
            try self.init(upca: try UPCA(barCode: upca))
        } catch let err { throw err }
    }
}
