//
//  VC2.swift
//  postNotiCenter
//
//  Created by JiseobKim on 24/10/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import Foundation


import UIKit

class VC2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func btnAction2(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: .doItSomeThing, object: "VC2")
    }
}
