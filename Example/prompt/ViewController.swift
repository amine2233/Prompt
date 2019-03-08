//
//  ViewController.swift
//  prompt
//
//  Created by amine2233 on 03/06/2019.
//  Copyright (c) 2019 amine2233. All rights reserved.
//

import UIKit
import Prompt

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func showprompt(_ sender: UIButton?) {
        self.displayPrompt("test", level: .error, style: .statusBar, timeout: 0, nil)
    }
    
    @IBAction
    func hideprompt(_ sender: UIButton?) {
        self.hidePrompt(sender)
    }
}

