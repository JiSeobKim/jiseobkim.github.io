//
//  ViewController.swift
//  postNotiCenter
//
//  Created by JiseobKim on 24/10/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(printSomeThing(_:)), name: .doItSomeThing, object: nil)
        
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .doItSomeThing, object: "JS")
        
        
    }
    
    
    @objc func printSomeThing(_ notification: Notification) {
        
        if let strObject = notification.object as? String {
            self.label.text = "호출자 : \(strObject)"
            self.label.sizeToFit()
        }
        
        print("do it something")
    }


}




extension Notification.Name {
    static let doItSomeThing = Notification.Name("doItSomeThing")
}
