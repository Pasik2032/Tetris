//
//  NetworkAPI.swift
//  Tetris
//
//  Created by Даниил Пасилецкий on 09.05.2022.
//

import Foundation

protocol NetworkOnline {
    func getOnline(completion: @escaping (Result<[UserModel]?, Error>) -> Void)
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

    public static func getNetworkOnline() -> NetworkOnline {
        return shared
    }
}
