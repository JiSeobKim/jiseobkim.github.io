//
//  VC2.swift
//  postNotiCenter
//
//  Created by JiseobKim on 27/10/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit

class VC2: UIViewController {

    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(change2), name: .changeLabel, object: nil)
    }
    
    
    @objc func change2(_ notification: Notification) {
        let getValue = notification.object as! String
        self.label2.text = "Change \(getValue)"
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
