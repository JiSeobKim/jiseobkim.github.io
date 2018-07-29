//
//  ViewController.swift
//  Escaping
//
//  Created by 김지섭 on 2018. 7. 29..
//  Copyright © 2018년 김지섭. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imgURL1 = "http://localhost/Escaping1.php"
        let imgURL2 = "http://localhost/Escaping2.php"
        let imgURL3 = "http://localhost/Escaping3.php"
        
        
        let links = [imgURL1, imgURL2, imgURL3]
        
        let testReturn = useReturn(links: links)
        print("useReturn: \(testReturn)")
        
        useEscaping(links: links) { (text) in
            print("useEscaping: \(text)")
        }
        
        
    }
    
    
    
    func defaultNetwork(){
        // URL 선언 및 초기화
        let url = "http://localhost/Escaping1.php"
        let request = Alamofire.request(url)
        
        request.responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                guard let nsDic = obj as? NSDictionary else { return }
                print(nsDic)
                break
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func useReturn(links: [String]) -> String {
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
    
    
    func useEscaping(links: [String], completeHandler: @escaping (String)->()) {
        
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


}

