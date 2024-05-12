
import UIKit

import Foundation


struct MovieElement: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

func fetchData(complitionHandler: @escaping ([Movie]?) -> Void){
    // 1- url
    let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=abe7089daa19c4b98bff89bb7fe1acac")
    // 2- request
    let request = URLRequest(url: url!)
    // 3- session
    let session = URLSession(configuration: .default)
    //URLSession.shared
    // 4- task
    let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
            print("Error: \(error)")
            complitionHandler(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            complitionHandler(nil)
            return
        }
        
        print("Received data:")
        print(String(data: data, encoding: .utf8) ?? "Unable to decode data as UTF-8")
        
        do {
            let json = try JSONDecoder().decode(MovieElement.self, from: data)
            let results = json.results
            complitionHandler(results)
        } catch let error {
            print("Error decoding JSON: \(error)")
            complitionHandler(nil)
        }
    }
    task.resume()
}
