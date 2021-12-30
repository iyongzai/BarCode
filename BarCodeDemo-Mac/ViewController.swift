//
//  ViewController.swift
//  BarCodeDemo-Mac
//
//  Created by zhiyong yin on 2021/12/4.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var upcaImageView: NSImageView!
    @IBOutlet weak var upceImageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            //self.imageView.image = UPCImageGenerator.generate(upca: "042100005264", size: .upca.scale(4), font: .default)
            self.upcaImageView.image = UPCImageGenerator.generate(upca: "042100005264", size: .upca.scale(4), font: .scaleWithFontName("PingFangSC-Ultralight"))
            self.upceImageView.image = UPCImageGenerator.generate(upce: "00123457", size: .upca.scale(4), font: .scaleWithFontName("PingFangSC-Ultralight"))
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

