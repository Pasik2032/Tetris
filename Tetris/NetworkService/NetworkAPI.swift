//
//  NetworkAPI.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import Foundation

protocol NetworkOnline {
    func getOnline(completion: @escaping (Result<[UserModel]?, Error>) -> Void)
    func postUser(login: String, password: String, completion: @escaping ((String) -> Void) ) 
}

class NetworkAPI: NetworkOnline {

//        private let net = "localhost"
            private let net = "MacBook-Pro-10.local"

    private static let shared: NetworkAPI = NetworkAPI()

    private init() {}
    func getOnline(completion: @escaping (Result<[UserModel]?, Error>) -> Void){
        // get url.
        let urlString = "http://\(net):8080/user/online"
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode([UserModel].self, from: data!)
                completion(.success(obj))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }

    func postUser(login: String, password: String, completion: @escaping ((String) -> Void) ) {
        let url = URL(string: "http://\(net):8080/user/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": login,
            "password": password
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { return}

//            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                
//                return
//            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            completion(responseString ?? "Неизвестная ошибка")
        }

        task.resume()
    }

    public static func getNetworkOnline() -> NetworkOnline {
        return shared
    }
}
