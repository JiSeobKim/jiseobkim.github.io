//
//  AddNameViewController.swift
//  Class&UIButton
//
//  Created by JiseobKim on 15/07/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit

class AddNameViewController: UIViewController {

    @IBOutlet var btnSave: DefaultBtn!
    @IBOutlet var btnSave2: BtnWithBackGroundColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼 비활성화
        btnSave.isOn = .Off
    }
    
    
    @IBAction func editChanged(_ sender: UITextField) {
        // 조건: 글자가 비어있는가??
        if sender.text?.isEmpty == true {
            // 버튼 비활성화
            btnSave.isOn = .Off
        } else {
            // 버튼 활성화
            btnSave.isOn = .On
        }
        
        // 배경색 있는 버튼
        if sender.text?.isEmpty == true {
            btnSave2.isOn = .Off
        } else {
            btnSave2.isOn = .On
        }
    }
}
