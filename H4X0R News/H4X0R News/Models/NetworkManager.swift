//
//  NetworkManager.swift
//  H4X0R News
//
//  Created by Rosliakov Evgenii on 01.08.2021.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    let urlString = "http://hn.algolia.com/api/v1/search?tags=front_page"
    
    func fetchData() {
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Data fetching error: %@", error.localizedDescription)
            }
            let decoder = JSONDecoder()
            if let safeData = data {
                do {
                    let decoded = try decoder.decode(PostData.self, from: safeData)
                    DispatchQueue.main.async {
                        self.posts = decoded.hits
                    }
                } catch let error {
                    print("Data decoding error: %@", error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
