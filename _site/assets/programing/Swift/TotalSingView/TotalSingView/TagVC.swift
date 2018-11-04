//
//  ViewController.swift
//  TotalSingView
//
//  Created by JiseobKim on 04/11/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit

class TagVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var label: UILabel!
    
    let label1 = UILabel()
    let label2 = UILabel()

    
    override func viewDidLoad() {
        makeTest()
        
        label1.tag = 1
        label.tag = 1 // subView의 Label
        
    }
    
    
    @IBAction func changeText(_ sender: UIButton) {
        
        // Tag로 지정
        let label = self.view.viewWithTag(1) as! UILabel
        
        label.text = "JS Blog!"
        label.sizeToFit()
        
        
    }
    
    
    func makeTest() {
        
        
        
        
        // label 생성
        
        // 기본 셋팅
        label1.frame.size = CGSize(width: 100, height: 50)
        label1.text = "Label1"
        label1.sizeToFit()
        label1.textColor = .black
        label1.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 200)
        
        
        label2.frame.size = CGSize(width: 100, height: 50)
        label2.text = "Label2"
        label2.sizeToFit()
        label2.textColor = .black
        label2.center = self.view.center
        
        // 태그 지정
        label1.tag = 1
        
        
        // 화면 추가
        self.view.addSubview(label1)
//        self.view.addSubview(label2)
        
        
        
        
        
    }


}

