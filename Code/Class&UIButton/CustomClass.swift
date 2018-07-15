//
//  CustomClass.swift
//  Class&UIButton
//
//  Created by JiseobKim on 15/07/2018.
//  Copyright © 2018 JiseobKim. All rights reserved.
//
import UIKit

class DefaultBtn: UIButton {
    
    // 버튼 상태 종류
    enum btnState {
        case On
        case Off
    }
    
    // 기본 값 = off 상태
    var isOn: btnState = .Off {
        didSet {
            setting()
        }
    }
    
    // on 컬러
    var onTintColor: UIColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    
    // off 컬러
    var offTintColor: UIColor = .gray
    
    // 1. 스토리보드로 버튼 구현시
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 기본 셋팅
        setting()
    }
    // 2. 코드로 버튼을 구현시
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 기본 셋팅
        setting()
    }
   
    
    func setting() {
        // on 컬러 (기본색)
        
        switch isOn {
        case .On:
            self.setTitleColor(onTintColor, for: .normal)
            self.isUserInteractionEnabled = true
        case .Off:
            self.setTitleColor(offTintColor, for: .normal)
            self.isUserInteractionEnabled = false
        }
    }
}


class BtnWithBackGroundColor: DefaultBtn {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 새로운 조건
        addSomeThing()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 새로운 조건
        addSomeThing()
    }
    
    func addSomeThing() {
        self.backgroundColor = .green
        self.layer.cornerRadius = 5
        // 추가 요청
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) // 폰트 볼드 및 사이즈 17
        self.offTintColor = .white // off 컬러 흰색
        self.onTintColor = .red // on 컬러 레드
        self.setting() // 바뀐것으로 셋팅 !
    }
}
