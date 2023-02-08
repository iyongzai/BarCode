//
//  ViewController.swift
//  BarCodeDemo-Mac
//
//  Created by zhiyong yin on 2021/12/4.
//

import Cocoa
import BarCode

class ViewController: NSViewController {
    
    @IBOutlet weak var upcaImageView: NSImageView!
    @IBOutlet weak var upceImageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testMikCouponBarcode()

        DispatchQueue.main.async {
            //self.imageView.image = UPCImageGenerator.generate(upca: "042100005264", size: .upca.scale(4), font: .default)
            self.upcaImageView.image = UPCImageGenerator.generate(upca: "042100005264", conf: .init(backgroundColor: .white,
                                                                                                    barColor: .black,
                                                                                                    font: .scaleWithFontName("PingFangSC-Ultralight"),
                                                                                                    size: .upca.scale(4)))
            self.upceImageView.image = UPCImageGenerator.generate(upce: "00123457", conf: .init(backgroundColor: .white.withAlphaComponent(0.8),
                                                                                                barColor: .systemPink.withAlphaComponent(0.7),
                                                                                                font: .scaleWithFontName("PingFangSC-Ultralight"),
                                                                                                size: .upca.scale(4)))
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func testGenerateUPCE() {
        //生成一批upce
        var upcePayloads: [String] = []
        while true {
            guard upcePayloads.count < 100 else {
                break
            }
            let random = "\(arc4random_uniform(9))\(arc4random_uniform(9))\(arc4random_uniform(9))\(arc4random_uniform(9))\(arc4random_uniform(9))"
            // XXNNN0
            upcePayloads.append("0\(random)0")
            // XXNNN1
            upcePayloads.append("0\(random)1")
            // XXNNN2
            upcePayloads.append("0\(random)2")
            // XXXNN3
            upcePayloads.append("0\(random)3")
            // XXXXN4
            upcePayloads.append("0\(random)4")
            // XXXXX5
            upcePayloads.append("0\(random)5")
            // XXXXX6
            upcePayloads.append("0\(random)6")
            // XXXXX7
            upcePayloads.append("0\(random)7")
            // XXXXX8
            upcePayloads.append("0\(random)8")
            // XXXXX9
            upcePayloads.append("0\(random)9")
        }
        
        func checkLuhn(number: String) -> Bool {
            var isOdd = true
            var sum = 0

            for index in number.indices.reversed() {
                let digit = Int(number[index].asciiValue! - 48)
                sum += isOdd ? digit : (digit * 3)
                isOdd = !isOdd
            }

            return (sum % 10) == 0
        }
        
        print("upce:-----------------")
        upcePayloads.forEach {
            let upce = try! UPCE.init(payload: $0)
            print(upce.barCode)
        }
        print("upca:-----------------")
        upcePayloads.forEach {
            let upce = try! UPCE.init(payload: $0)
            let upcaBarCode = upce.upcaBarCode
            print(upcaBarCode)
            if !(try! UPCA.checkDigit(barCode: upcaBarCode)) {
                print("error")
            }
            if !checkLuhn(number: upcaBarCode) {
                print("error")
            }
        }
    }
    
    
    func testMikCouponBarcode() {
        let arr = ["840010079652837400355081122088",
                   "840010079652837363007860822086",
                   "840010079652898350611021322081",
                   "840010085102930480413041622083",
                   "840010034922910640404520822085",
                   "840010035601294430602441622083",
                   "840010079652850350120211222083"]
        func rbbByLuhnMethod(_ number: String) -> Int {
            var sum = 0
            let oddWeight = 2
            let evenWeight = 1
            var barcodeString = "barcodeString"
            var weightString = "weightString"
            var multiply = "multiply"
            var addDigits = "addDigits"
            for (i, elem) in number.enumerated() {
                let intValue = Int(String(elem))!
                barcodeString += ",\(intValue)"
                let isOdd = i%2 == 0 //奇数位
                weightString += ",\(isOdd ? oddWeight : evenWeight)"
                
                let multiplyValue = intValue*(isOdd ? oddWeight : evenWeight)
                let addDigitsValue = multiplyValue > 9 ? multiplyValue-9 : multiplyValue
                sum += addDigitsValue
                multiply += ",\(multiplyValue)"
                addDigits += ",\(addDigitsValue)"
            }
            let mod10 = sum%10
            let checkDigit = mod10 == 0 ? 0 : 10-mod10
            print(barcodeString)
            print(weightString)
            print(multiply)
            print(addDigits)
            print("sum,\(sum)")
            print("mod10,\(mod10)")
            print("luhnCheckDigit,\(checkDigit)")
            return sum
        }

        arr.forEach {
            var valueString = $0.substring(from: 1)
            valueString = valueString.substring(to: valueString.count-1)
            print("----------------------")
            print("'\($0)")
            
            let _ = rbbByLuhnMethod(valueString)
        }
    }

}

