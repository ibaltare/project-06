//
//  NetworkService.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import Foundation

protocol NetworkProtocol {
    func networkRequest(url: String,credentials: String,httpMethod: HTTPMethod,completion: @escaping (Result<String, NetworkError>) -> Void)
    
    func networkRequest<R: Decodable, B: Encodable>(url: String,credentials: String,httpMethod: HTTPMethod,httpBody: B?,completion: @escaping (Result<R, NetworkError>) -> Void)
}

final class NetworkService: NetworkProtocol {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func networkRequest(url: String,credentials: String,httpMethod: HTTPMethod,completion: @escaping (Result<String, NetworkError>) -> Void) {
            
        guard let url = URL(string: url) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 else {
                completion( .failure(.notAuthenticated))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let result = String(data: data, encoding: .utf8) else {
                completion(.failure(.decoding))
                return
            }
            
            completion(.success(result))
        }
        
        task.resume()
    }
    
    func networkRequest<R: Decodable, B: Encodable>(url: String,
                                                    credentials: String,
                                                    httpMethod: HTTPMethod,
                                                    httpBody: B?,
                                                    completion: @escaping (Result<R, NetworkError>) -> Void) {
            
        guard let url = URL(string: url) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("Bearer \(credentials)", forHTTPHeaderField: "Authorization")
        
        if let httpBody = httpBody{
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(httpBody)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 else {
                completion( .failure(.notAuthenticated))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = try? JSONDecoder().decode(R.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(response))
        }
        
        task.resume()
    }
    
}
