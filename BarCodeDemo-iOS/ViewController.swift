//
//  ViewController.swift
//  BarCodeDemo-iOS
//
//  Created by zhiyong yin on 2021/12/4.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var barcodeImageView: BarCodeImageView = {
//        let view = BarCodeImageView(frame: self.view.bounds)
        let view = BarCodeImageView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 400))
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupSubviewsConstraints()
        
        barcodeImageView.barCode = "042100005264"//"036000291452"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateImage()
    }

    func setupSubviews() {
        self.view.addSubview(barcodeImageView)
    }
    
    func setupSubviewsConstraints() {
//        NSLayoutConstraint.activate([
//            barcodeImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            barcodeImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            barcodeImageView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor),
//            barcodeImageView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor),
//        ])
    }
    
    func generateImage() {
        //imageView.image = UPCAImageGenerator.generate(upca: "042100005264", size: .upca, font: .default)
        imageView.image = UPCAImageGenerator.generate(upca: "042100005264", size: .upca, font: .scaleWithFontName("PingFangSC-Ultralight"))
        imageView.contentMode = .center
        self.view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 500, width: self.view.bounds.width, height: self.barcodeImageView.bounds.height)
    }
}

