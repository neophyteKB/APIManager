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
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        APIManager.shared.request(url: url, method: .get) { (result: Result<[Welcome], Error>) in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let data):
                print(data.count)
                print(data.forEach({print($0.title)}))
            }
        }
    }


}

