
let ean13Content = "938930748560"
let ean13BarCode = try BarCodeGenerator.generate(barCodeType: .ean13(ean13Content))
print("ean13=\(ean13BarCode)")
print("check ean13: \((try BarCodeGenerator.checkDigit(barCodeType: .ean13(ean13BarCode))))")


let upcaContent = "63938200039"
let upcaBarCode = try BarCodeGenerator.generate(barCodeType: .upca(upcaContent))
print("upca=\(upcaBarCode)")
print("check upca: \((try BarCodeGenerator.checkDigit(barCodeType: .upca(upcaBarCode))))")


let upcaobj = try UPCA(barCode: upcaBarCode)
print(upcaobj.barCode, upcaobj.payload)
