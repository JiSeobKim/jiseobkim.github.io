//
//  VC3.swift
//  postNotiCenter
//
//  Created by JiseobKim on 27/10/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit

class VC3: UIViewController {

    
    @IBOutlet weak var label3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(change3), name: .changeLabel, object: nil)
    }
    
    
    @objc func change3(_ notification: Notification) {
        let getValue = notification.object as! String
        self.label3.text = "Change \(getValue)"
    }
    
    @IBAction func doPost(_ sender: UIButton) {
        NotificationCenter.default.post(name: .changeLabel, object: "Object")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
