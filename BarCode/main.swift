
//let ean13Content = "938930748560"
//let ean13BarCode = try BarCodeGenerator.generate(barCodeType: .ean13(ean13Content))
//print("ean13=\(ean13BarCode)")
//print("check ean13: \((try BarCodeGenerator.checkDigit(barCodeType: .ean13(ean13BarCode))))")
//
//
//let upcaContent = "63938200039"
//let upcaBarCode = try BarCodeGenerator.generate(barCodeType: .upca(upcaContent))
//print("upca=\(upcaBarCode)")
//print("check upca: \((try BarCodeGenerator.checkDigit(barCodeType: .upca(upcaBarCode))))")
//
//
//let upcaobj = try UPCA(barCode: upcaBarCode)
//print(upcaobj.barCode, upcaobj.payload)


let receiptContent = "89002510560510000010021315044930"
do {
    let receiptBarCode = try BarCodeGenerator.generate(barCodeType: .mikReceipt(receiptContent))
    print("receipt bar code: \(receiptBarCode)")
    print("check receipt: \((try BarCodeGenerator.checkDigit(barCodeType: .mikReceipt(receiptBarCode))))")
    print("receipt payload: \(try MikReceipt.caculatePayload(barCode: receiptBarCode))")
    let mikReceit = try MikReceipt(barCode: receiptBarCode)
    print(mikReceit.storeNumber)
} catch let err {
    print(err)
}
