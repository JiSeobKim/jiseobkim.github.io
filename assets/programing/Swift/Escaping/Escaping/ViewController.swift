//
//  ViewController.swift
//  Escaping
//
//  Created by 김지섭 on 2018. 7. 29..
//  Copyright © 2018년 김지섭. All rights reserved.
//

import UIKit
// Alamofire import 하기
import Alamofire


// 1. 졸업 작품 당시 (전역함수)
func getNSDicData(url: String) -> NSDictionary? {
    // 1-1. 필요한 nsDic이 될값
    var returnValue: NSDictionary?
    // 1-2. 요청
    let request = Alamofire.request(url)
    // 1-3. 응답
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            
            // 4. 받아온 데이터를 NSDictionary로 변환
            guard let nsDic = obj as? NSDictionary else { return }
            // 5. returnValue에 지정
            returnValue = nsDic
            
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
    
    // 6. 돌려주기
    return returnValue
}

// Escaping

func useEscaping(url: String, whenIfFailed: @escaping () -> Void, handler: @escaping (NSDictionary) -> Void) {
    
    let request = Alamofire.request(url)
    
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            
            guard let nsDic = obj as? NSDictionary else { return }
            handler(nsDic)
            
        case .failure(let e):
            
            // 통신 실패시
            print(e.localizedDescription)
            whenIfFailed()
        }
    }
}


// 2. 뷰컨트롤러
class ViewController: UIViewController {

    @IBOutlet var lbText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 2-1. url 선언 및 초기화
        let url = "http://localhost/~jiseobkim/Escaping1.php"
        
        // 2-2. escaping 사용한 함수 호출
//        useEscaping(url: url) { (nsDic) in
//            guard let text = nsDic["text"] as? String else { return }
//
//            print("(Escaping 사용)text: \(text)")
//        }
//
//        // (return 방식 사용한 전역 함수 사용)
//        print("(함수 return 사용)text: \(getNSDicData(url: url))")
        
        
        func ifFailed() {
            print("실패했어요")
        }
    
        useEscaping(url: url, whenIfFailed: {
            print("실패했어요")
        }) { (nsDic) in
            guard let text = nsDic["text"] as? String else { return }

            print("(Escaping 사용)text: \(text)")
        }
        
        
//        useEscaping(url: url, whenIfFailed: ifFailed()) { (nsDic) in
//            guard let text = nsDic["text"] as? String else { return }
//            print("(Escaping 사용)text: \(text)")
//        }
        
    }
}








/*
// 2.기본적인 통신 방법
func defaultNetwork(){
    // 3.URL 선언 및 초기화
    let url = "http://localhost/~jiseobkim/Escaping1.php"
    let request = Alamofire.request(url)
    
    request.responseJSON { (response) in
        switch response.result {
        case .success(let obj):
            // 4.통신으로 받아온 값 출력
            print(obj)
            // 5.딕셔너리로 변환
            guard let nsDic = obj as? NSDictionary else { return }
            // 6.nsDic의 'text'라는 키의 값을 String으로 가져온다.
            guard let text = nsDic["text"] as? String else { return }
            // 7. lbText라는 Label의 텍스트 값으로 지정
            self.lbText.text = text
            
        case .failure(let e):
            print(e.localizedDescription)
        }
    }
}









func useReturn() -> String {
    let imgURL1 = "http://localhost/~jiseobkim/Escaping1.php"
    let imgURL2 = "http://localhost/~jiseobkim/Escaping2.php"
    let imgURL3 = "http://localhost/~jiseobkim/Escaping3.php"
    
    let links = [imgURL1, imgURL2, imgURL3]
    
    var attachedText = ""
    
    for link in links {
        // URL 선언 및 초기화
        let url = link
        let request = Alamofire.request(url)
        
        request.responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                guard let nsDic = obj as? NSDictionary else { return }
                guard let text = nsDic["text"] as? String else { return }
                
                attachedText += text
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    
    return ""
}


func useEscaping(completeHandler: @escaping (String)->()) {
    
    let imgURL1 = "http://localhost/~jiseobkim/Escaping1.php"
    let imgURL2 = "http://localhost/~jiseobkim/Escaping2.php"
    let imgURL3 = "http://localhost/~jiseobkim/Escaping3.php"
    
    let links = [imgURL1, imgURL2, imgURL3]
    
    var attacedText = ""
    var count = 1
    let maxCount = links.count
    
    for link in links {
        let request = Alamofire.request(link)
        
        request.responseJSON { (response) in
            
            
            switch response.result {
            case .success(let obj):
                guard let nsDic = obj as? NSDictionary else { return }
                guard let text = nsDic["text"] as? String else { return }
                
                attacedText += "\(text) "
                
                if count == maxCount {
                    completeHandler(attacedText)
                } else {
                    count += 1
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


*/
