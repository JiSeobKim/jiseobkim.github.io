//
//  ViewController.swift
//  DelegatePattern
//
//  Created by JiseobKim on 02/09/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//

import UIKit
protocol Bbang {
    func warning(name:String)
}

// MARK: USE Protocol
class VC1: UIViewController, Bbang {
    // 추가된 프로토콜 함수
    func warning(name: String) {
        self.lbName.text = name
    }
    
    // 이름 텍스트를 넣을 Label
    @IBOutlet weak var lbName: UILabel!
    
    // Label에 텍스트 적용
    func insert(name: String) {
        self.lbName.text = name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VC2 {
            vc.delegate = self
        }
    }
    
}





class VC2: UIViewController {
    // 이름 입력 받을 필드
    @IBOutlet var tfName: UITextField!
    
    
    // 변경점 1
    // VC1의 인스턴스
//    var delegate: VC1?
    // 프로토콜 변수 선언
    var delegate: Bbang?
    
    
    // 화면 돌아가는 버튼
    @IBAction func returnToVC1(_ sender: Any) {
        // 텍스트 필드 텍스트 가져오기
        let text = tfName.text
        
        // 변경점 2
        // VC1의 함수 호출
//        delegate?.insert(name: text!)
        delegate?.warning(name: text!)
        
        // VC2화면 제거
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: USE Delegate
//class VC1: UIViewController {
//
//
//    // 이름 텍스트를 넣을 Label
//    @IBOutlet weak var lbName: UILabel!
//
//    // Label에 텍스트 적용
//    func insert(name: String) {
//        self.lbName.text = name
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? VC2 {
//            vc.delegate = self
//        }
//    }
//
//}
//
//class VC2: UIViewController {
//    // 이름 입력 받을 필드
//    @IBOutlet var tfName: UITextField!
//    // VC1의 인스턴스
//    var delegate: VC1?
//    // 화면 돌아가는 버튼
//    @IBAction func returnToVC1(_ sender: Any) {
//        // 텍스트 필드 텍스트 가져오기
//        let text = tfName.text
//        // VC1의 함수 호출
//        delegate?.insert(name: text!)
//        // VC2화면 제거
//        self.dismiss(animated: true, completion: nil)
//    }
//
//}




