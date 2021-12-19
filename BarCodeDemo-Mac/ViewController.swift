//
//  ViewController.swift
//  BarCodeDemo-Mac
//
//  Created by zhiyong yin on 2021/12/4.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //imageView.image = UPCAImageGenerator.generate(upca: "042100005264", size: .upca.scale(4), font: .default)
        imageView.image = UPCAImageGenerator.generate(upca: "042100005264", size: .upca.scale(4), font: .scaleWithFontName("PingFangSC-Ultralight"))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

