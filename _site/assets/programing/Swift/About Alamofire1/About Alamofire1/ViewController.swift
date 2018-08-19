//
//  ViewController.swift
//  About Alamofire1
//
//  Created by 김지섭 on 2018. 7. 21..
//  Copyright © 2018년 김지섭. All rights reserved.
//

import UIKit
// 1. Alamofire 사용하기
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var lbHp: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var data1: UILabel!
    @IBOutlet weak var data2: UILabel!
    @IBOutlet weak var data3: UILabel!
    @IBOutlet weak var data4: UILabel!
    @IBOutlet weak var data5: UILabel!
    @IBOutlet weak var data6: UILabel!
    @IBOutlet weak var data7: UILabel!
    @IBOutlet weak var data8: UILabel!
    
    
    struct UserData: Codable {
        var hp: String?
        var name: String?
        var age: Int?
        var data1: String?
        var data2: String?
        var data3: String?
        var data4: String?
        var data5: String?
        var data6: String?
        var data7: String?
        var data8: String?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. URL 정의
        let url = "http://localhost/RESTFullAPI.php"
        
        // 3. 전송
        let doNetwork = Alamofire.request(url)
        
        // 4. 응답 처리
        doNetwork.responseJSON { (response) in
            // 5. 결과에 따른 switch문
            switch response.result {
            case .success(let obj):
                // 5-1. 통신 성공
                do {
                    
                    // obj(Any)를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    // JSON Decoder 사용 (Codable)
                    let getInstanceData = try JSONDecoder().decode(UserData.self, from: dataJSON)
                    
                    // 데이터 적용
                    self.lbHp.text = getInstanceData.hp
                    self.lbName.text = getInstanceData.name
                    self.lbAge.text = (getInstanceData.age ?? 0).description
                    self.data1.text = getInstanceData.data1
                    self.data2.text = getInstanceData.data2
                    self.data3.text = getInstanceData.data3
                    self.data4.text = getInstanceData.data4
                    self.data5.text = getInstanceData.data5
                    self.data6.text = getInstanceData.data6
                    self.data7.text = getInstanceData.data7
                    self.data8.text = getInstanceData.data8
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let e):
                // 5-2. 통신 실패
                print(e.localizedDescription)
                
            }
            
        }
        
    }
    
}


//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var lbHp: UILabel!
//    @IBOutlet weak var lbName: UILabel!
//    @IBOutlet weak var lbAge: UILabel!
//    @IBOutlet weak var data1: UILabel!
//    @IBOutlet weak var data2: UILabel!
//    @IBOutlet weak var data3: UILabel!
//    @IBOutlet weak var data4: UILabel!
//    @IBOutlet weak var data5: UILabel!
//    @IBOutlet weak var data6: UILabel!
//    @IBOutlet weak var data7: UILabel!
//    @IBOutlet weak var data8: UILabel!
//
//
//    struct UserData: Codable {
//        var hp: String?
//        var name: String?
//        var age: Int?
//        var data1: String?
//        var data2: String?
//        var data3: String?
//        var data4: String?
//        var data5: String?
//        var data6: String?
//        var data7: String?
//        var data8: String?
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // 2. URL 정의
//        let url = "http://localhost/RESTFullAPI.php"
//
//        // 3. 전송
//        let doNetwork = Alamofire.request(url)
//
//        // 4. 응답 처리
//        doNetwork.responseJSON { (response) in
//            // 5. 결과에 따른 switch문
//            switch response.result {
//            case .success(let obj):
//                // 5-1. 통신 성공
//                if let nsDictionary = obj as? NSDictionary {
//
//                    // 전화번호
//                    if let hp = nsDictionary["hp"] as? String {
//                        self.lbHp.text = hp
//                    }
//                    // 이름
//                    if let name = nsDictionary["name"] as? String {
//                        self.lbName.text = name
//                    }
//                    // 나이
//                    if let age = nsDictionary["age"] as? Int {
//                        self.lbAge.text = age.description
//                    }
//                    // Data1
//                    if let data1 = nsDictionary["data1"] as? String {
//                        self.data1.text = data1
//                    }
//                    // Data2
//                    if let data2 = nsDictionary["data2"] as? String {
//                        self.data2.text = data2
//                    }
//                    // Data3
//                    if let data3 = nsDictionary["data3"] as? String {
//                        self.data3.text = data3
//                    }
//                    // Data4
//                    if let data4 = nsDictionary["data4"] as? String {
//                        self.data4.text = data4
//                    }
//                    // Data5
//                    if let data5 = nsDictionary["data5"] as? String {
//                        self.data5.text = data5
//                    }
//                    // Data6
//                    if let data6 = nsDictionary["data6"] as? String {
//                        self.data6.text = data6
//                    }
//                    // Data7
//                    if let data7 = nsDictionary["data7"] as? String {
//                        self.data7.text = data7
//                    }
//                    // Data8
//                    if let data8 = nsDictionary["data8"] as? String {
//                        self.data8.text = data8
//                    }
//
//
//
//                }
//
//            case .failure(let e):
//                // 5-2. 통신 실패
//                print(e.localizedDescription)
//
//            }
//
//        }
//
//    }
//
//}
