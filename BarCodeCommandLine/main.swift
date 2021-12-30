//
//  main.swift
//  BarCodeCommandLine
//
//  Created by zhiyong yin on 2021/12/4.
//





do {
    // test ean13
    let ean13Content = "938930748560"
    let ean13BarCode = try BarCodeGenerator.generate(barCodeType: .ean13(ean13Content))
    print("ean13=\(ean13BarCode)")
    print("check ean13: \((try BarCodeGenerator.checkDigit(barCodeType: .ean13(ean13BarCode))))")
    
    
    // test upca
    let upcaContent = "63938200039"
    let upcaBarCode = try BarCodeGenerator.generate(barCodeType: .upca(upcaContent))
    print("upca=\(upcaBarCode)")
    print("check upca: \((try BarCodeGenerator.checkDigit(barCodeType: .upca(upcaBarCode))))")
    
    let upcaobj = try UPCA(barCode: upcaBarCode)
    print(upcaobj.barCode, upcaobj.payload)
    
    
    // test upce
    let upceContent1 = "0234567"
    let upceContent2 = "234567"
    let upceBarCode1 = try BarCodeGenerator.generate(barCodeType: .upce(upceContent1))
    let upceBarCode2 = try BarCodeGenerator.generate(barCodeType: .upce(upceContent2))
    print("upce=\(upceBarCode1)")
    print("check upce: \((try BarCodeGenerator.checkDigit(barCodeType: .upce(upceBarCode1))))")
    print("upce=\(upceBarCode2)")
    print("check upce: \((try BarCodeGenerator.checkDigit(barCodeType: .upce(upceBarCode2))))")

    let upceObj1 = try UPCE(payload: upceContent1)
    print("upce payload: \(upceBarCode1), upce: \(upceObj1.barCode), upca: \(upceObj1.upcaBarCode)")
    let upceObj2 = try UPCE(payload: upceContent2)
    print("upce payload: \(upceBarCode2), upce: \(upceObj2.barCode), upca: \(upceObj2.upcaBarCode)")
    let upceObj3 = try UPCE(barCode: upceBarCode1)
    print("upce payload: \(upceBarCode1), upce: \(upceObj3.barCode), upca: \(upceObj3.upcaBarCode)")
    let upceObj4 = try UPCE(barCode: upceBarCode2)
    print("upce payload: \(upceBarCode2), upce: \(upceObj4.barCode), upca: \(upceObj4.upcaBarCode)")


    let upca1 = "023456000073"
    let upca2 = "023450000017"
    let upca3 = "063200009716"
    let upca4 = "086700000939"
    print("upca1: \(upca1), upce: \(try UPCE(upca: upca1).barCode)")
    print("upca2: \(upca2), upce: \(try UPCE(upca: upca2).barCode)")
    print("upca3: \(upca3), upce: \(try UPCE(upca: upca3).barCode)")
    print("upca4: \(upca4), upce: \(try UPCE(upca: upca4).barCode)")

} catch let err { print(err) }


let initialBits: UInt8 = 0b00001111
  
//修改第几位数据
var location = 4


var result = initialBits >> location & 1
// 转化为字符串
var stringOfInvertedBits = String(result, radix: 2)
print(stringOfInvertedBits)
//输出：1
