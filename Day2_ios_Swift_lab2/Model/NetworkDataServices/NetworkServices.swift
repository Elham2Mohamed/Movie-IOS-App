//
//  NetworkServixces.swift
//  DemoDay6
//
//  Created by JETS Mobile Lab on 09/05/2024.
//

import Foundation

protocol NetworkProtocol{
    
    func fetchDataFromAPI(url : String,completion: @escaping ([Movie]?) -> Void) 
}

class NetworkServices : NetworkProtocol{
    
    func fetchDataFromAPI(url : String,completion: @escaping ([Movie]?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error!)")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let movieElement = try decoder.decode(MovieElement.self, from: data)
                let results = movieElement.results
                completion(results)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

}
