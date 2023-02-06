//
//  UPCVC.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

import UIKit

enum UPCType {
    case upca
    case upce
}

class UPCVC: UIViewController {
    @IBOutlet weak var barcodeImageView: BarCodeImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var barCodeTF: UITextField!
    
    var barCode: BarCodeType = .upca("042100005264") {
        didSet { DispatchQueue.main.async { self.barcodeImageView.barCode = self.barCode } }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        barcodeImageView.barCode = barCode
        switch barCode {
        case .ean13(let barCode):
            self.navigationItem.title = "EAN13"
            self.barCodeTF.text = barCode[0..<12]
        case .upca(let barCode):
            self.navigationItem.title = "UPCA"
            self.barCodeTF.text = barCode[0..<11]
        case .upce(let barCode):
            self.navigationItem.title = "UPCE"
            self.barCodeTF.text = barCode[0..<7]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateImage()
    }

    
    @IBAction func generateAction() {
        do {
            switch barCode {
            case .ean13(_):
                return
            case .upca(_):
                let upcaObj = try UPCA(payload: barCodeTF.text ?? "")
                self.barCode = .upca(upcaObj.barCode)
                generateImage()
            case .upce(_):
                let upceObj = try UPCE(payload: barCodeTF.text ?? "")
                self.barCode = .upce(upceObj.barCode)
                generateImage()
            }
        } catch let err {
            let vc = UIAlertController(title: "Oops!", message: (err as? BarCodeError)?.desc ?? err.localizedDescription, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func generateImage() {
        var image: UIImage!
        switch barCode {
        case .ean13(_):
            return
        case .upca(let upca):
            //image = UPCImageGenerator.generate(upca: "042100005264", size: .upca, font: .default)
            image = UPCImageGenerator.generate(upca: upca, conf: .init(backgroundColor: .white, barColor: .orange, font: .scaleWithFontName("PingFangSC-Ultralight"), size: .upca))
        case .upce(let upce):
            image = UPCImageGenerator.generate(upce: upce, conf: .init(backgroundColor: .white, barColor: .orange, font: .scaleWithFontName("PingFangSC-Ultralight"), size: .upca.scale(2)))
        }
        guard image != nil else { return }
        
        imageView.image = image
    }
}

extension UPCVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
