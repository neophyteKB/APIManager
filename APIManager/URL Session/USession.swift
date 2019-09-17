//
//  USession.swift
//  S3Upload
//
//  Created by Kamal on 16/09/19.
//  Copyright © 2019 Kamal. All rights reserved.
//

import Foundation

enum HttpMethods: String {
    case get, post, put, delete
}
struct APIManager {
    static var shared = APIManager()
    
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func request<T: Decodable>(url: URL,
                               method: HttpMethods = .post,
                               params: [String: Any]? = nil,
                               headers: [String:String]? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        if let header = headers {
            urlRequest.allHTTPHeaderFields = header
        }
        if let params = params,
            let httpbody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            urlRequest.httpBody = httpbody
        }
        urlRequest.httpMethod = method.rawValue.uppercased()
        
        URLSession.shared.request(with: urlRequest) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    let error = NSError(domain: "Wrong status code",
                                        code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                                        userInfo: nil)
                    completion(.failure(error))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                    return
                } catch {
                    let error = NSError(domain: "decoding issue", code: 0, userInfo: nil)
                    completion(.failure(error))
                    return
                }
            }
        }.resume()
    }
}

extension URLSession {
    func request(with urlRequest: URLRequest, result:@escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        })
        
    }
}
