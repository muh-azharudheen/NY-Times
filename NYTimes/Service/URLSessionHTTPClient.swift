//
//  URLSessionHTTPClient.swift
//  NYTimes
//
//  Created by Muhammed Azharudheen on 26/10/1400 AP.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
    func get<T: Decodable>(from url: URL, completion: @escaping (Swift.Result<T, Error>) -> Void)
}

extension HTTPClient {
    
    func get<T: Decodable>(from url: URL, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        
        get(from: url) { (result: Swift.Result<(Data, HTTPURLResponse), Error>) in
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode(T.self, from: result.0)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
    }
}
