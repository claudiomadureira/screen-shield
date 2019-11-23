//
//  ViewController.swift
//  MSScreenShield
//
//  Created by Cláudio Madureira on 11/23/2019.
//  Copyright (c) 2019 Cláudio Madureira. All rights reserved.
//

import UIKit
import MSScreenShield

class ViewController: UIViewController {
    
    @IBOutlet weak var txf: UITextField!
    
    lazy var screenshotListener: MSScreenshotListener = {
        return .init(handler: { [weak self] in
            // Do something after user taking screenshot.
            self?.txf.isHidden = true
            self?.txf.endEditing(false)
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txf.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        self.txf.layer.borderWidth = 1
        self.txf.layer.masksToBounds = true
        self.txf.layer.cornerRadius = 10
        
        MSScreenShield.allowsPrinting = true
        
        self.txf.addShield(withColor: .blue)
        
//        self.txf.removeShield()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MSScreenShield.bind(self.screenshotListener)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MSScreenShield.unbind(self.screenshotListener)
    }
    
}

