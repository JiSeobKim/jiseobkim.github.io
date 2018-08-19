//
//  ViewController.swift
//  Generic
//
//  Created by 김지섭 on 2018. 8. 19..
//  Copyright © 2018년 김지섭. All rights reserved.
//

import UIKit
import Alamofire

struct StructA: Codable {
    var hp: String?
    var name: String?
    var age: Int?
}

struct StructB: Codable {
    var country: String?
    var address: String?
}

struct StructC: Codable {
    var data1: StructA?
    var data2: StructB?
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: ListURL = .url3
        
        url.alamofireDefault(type: StructA()) { (nsDic) in
            if let value = nsDic {
                
                switch url {
                case .url1:
                    let object = self.useDecodable(type: StructA(), nsDic: value)
                    print(object!)
                case .url2:
                    let object = self.useDecodable(type: StructB(), nsDic: value)
                    print(object!)
                case .url3:
                    let object = self.useDecodable(type: StructC(), nsDic: value)
                    print(object!)
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func useDecodable<T: Codable>(type: T, nsDic: NSDictionary) -> T? {
        // JSON 변환
        do {
            // JSON 변환
            let JSONData = try JSONSerialization.data(withJSONObject: nsDic, options: .prettyPrinted)
            // Decodable을 이용해 객체를 얻음
            let data = try JSONDecoder().decode(T.self, from: JSONData)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    enum ListURL: String {
        case url1 = "http://localhost/Generic1.php"
        case url2 = "http://localhost/Generic2.php"
        case url3 = "http://localhost/Generic3.php"
        
        func alamofireDefault<T>(type: T, handler: @escaping (NSDictionary?)->Void) {
            // url 정의
            let url = self
            // 통신 진행
            let network = Alamofire.request(url.rawValue)
            // 통신 응답
            network.responseJSON { (response) in
                
                switch response.result {
                case .success(let object):
                    // NSDictionary 형태로 변경
                    guard let nsDic = object as? NSDictionary else {
                        // 캐스팅 실패
                        handler(nil)
                        return
                    }
                    
                    // 캐스팅 성공 & 반환
                    handler(nsDic)
                    
                    
                    break
                case .failure(let e):
                    print(e.localizedDescription)
                    handler(nil)
                }
            }
        }

    }
    

}

