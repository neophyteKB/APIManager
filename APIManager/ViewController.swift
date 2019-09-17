//
//  ViewController.swift
//  APIManager
//
//  Created by Kamal on 17/09/19.
//  Copyright © 2019 Kamal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiCall()
        // Do any additional setup after loading the view.
    }
    
    
    private func apiCall() {
        let url = URL(string: "https://api.denefits.com:3003/get_faq")!
        APIManager.shared.request(url: url, params: ["access_token": "93e6a90a7aa6ed44187e956507516d0d"]) { (result: Result<Success<[FAQ]>, Error>) in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let data):
                if data.isError == 1 {
                    print(data.flag)
                }
                else {
                    print(data.result.count)
                    print(data.result.forEach({print($0.question)}))
                }
            }
        }
    }


}

