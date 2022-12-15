//
//  APICaller.swift
//  NetflixApp
//
//  Created by Stefan Boblic on 13.12.2022.
//

import Foundation

struct Constants {
    static let TMDB_API_KEY = "0bcd6f923a1eac55805f7a3935ecc46a"
    static let YOUTUBE_API_KEY = "AIzaSyCQ-1Lk-vfeGBmmWggXZ2EyA-de4V2a0tk"
    static let YOUTUBE_BASE_URL = "https://youtube.googleapis.com"
    static let TMDB_BASE_URL = "https://api.themoviedb.org"
}

enum APIEndpoint {
    case getTrendingMovies
    case getTrendingTvs
    case getUpcomingMovies
    case getPopular
    case getTopRated
    case getDiscoverMovies
    case search(query: String)
    case getMovie(query: String)

    var path: String {
        switch self {
        case .getTrendingMovies:
            return "\(Constants.TMDB_BASE_URL)/3/trending/movie/day?api_key=\(Constants.TMDB_API_KEY)"
        case .getTrendingTvs:
            return "\(Constants.TMDB_BASE_URL)/3/trending/tv/day?api_key=\(Constants.TMDB_API_KEY)"
        case .getUpcomingMovies:
            return "\(Constants.TMDB_BASE_URL)/3/movie/upcoming?api_key=\(Constants.TMDB_API_KEY)&language=en-US&page=1"
        case .getTopRated:
            return "\(Constants.TMDB_BASE_URL)/3/movie/top_rated?api_key=\(Constants.TMDB_API_KEY)&language=en-US&page=1"
        case .getPopular:
            return "\(Constants.TMDB_BASE_URL)/3/movie/popular?api_key=\(Constants.TMDB_API_KEY)&language=en-US&page=1"
        case .getDiscoverMovies:
            return "\(Constants.TMDB_BASE_URL)/3/discover/movie?api_key=\(Constants.TMDB_API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        case .search(let query):
            return "\(Constants.TMDB_BASE_URL)/3/search/movie?api_key=\(Constants.TMDB_API_KEY)&query=\(query)"
        case .getMovie(let query):
            return "\(Constants.YOUTUBE_BASE_URL)/youtube/v3/search?q=\(query)&key=\(Constants.YOUTUBE_API_KEY)"
        }
    }

    var body: Data? {
        switch self {
        case .getPopular, .getTopRated, .getUpcomingMovies, .getTrendingTvs, .getTrendingMovies, .getDiscoverMovies, .search, .getMovie:
            return nil
        }
    }
}

enum APIError: Error {
    case failedToGetData
}

final class APICaller {
    static let shared = APICaller()

    private func configureRequest(apiEndpoint: APIEndpoint, resultHandler: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: apiEndpoint.path) else {
            resultHandler(.failure(.failedToGetData))
            return
        }

        var request = URLRequest(url: url)
        request.httpBody = apiEndpoint.body
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                resultHandler(.failure(.failedToGetData))
                return
            }

            resultHandler(.success(data))
        }
        task.resume()
    }

    func getTrendingMovies(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getTrendingMovies) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getTrendingTvs(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getTrendingTvs) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getUpcomingMovies(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getUpcomingMovies) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getPopular(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getPopular) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getTopRated(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getTopRated) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getDiscoverMovies(resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        configureRequest(apiEndpoint: .getDiscoverMovies) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func search(with query: String, resultHandler: @escaping (Result<[Title], APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        configureRequest(apiEndpoint: .search(query: query)) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    resultHandler(.success(result.results))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }

    func getMovie(with query: String, resultHandler: @escaping (Result<VideoElement, APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        configureRequest(apiEndpoint: .getMovie(query: query)) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                    resultHandler(.success(result.items[0]))
                } catch {
                    resultHandler(.failure(.failedToGetData))
                }
            case .failure:
                resultHandler(.failure(.failedToGetData))
            }
        }
    }
}
