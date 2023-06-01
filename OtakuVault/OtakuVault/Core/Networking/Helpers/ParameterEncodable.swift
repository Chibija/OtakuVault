//
//  ParameterEncoding.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/18/23.
//

import Foundation

public typealias Parameters = [String: Any]

protocol ParameterEncodable {
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}

struct JSONEncoding: ParameterEncodable {
    
    static var `default`: JSONEncoding = JSONEncoding()
    
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        
        guard let parameters = parameters else { return urlRequest }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("\(Constants.clientID)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
            }
            
            urlRequest.httpBody = data
        } catch {
            throw OVError.NetworkError.invalidURL
        }
        return urlRequest
    }
}

struct URLEncoding: ParameterEncodable {
    
    static var `default`: URLEncoding = URLEncoding()
    
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
                
        guard let parameters = parameters else { return urlRequest }
        
        // TODO: Add actual logic maybe with an enum that return a boolean
        if urlRequest.httpMethod == nil {
            guard let url = urlRequest.url else {
                throw OVError.NetworkResponseError.unableToDecode
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                }
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("\(Constants.clientID)", forHTTPHeaderField: "X-MAL-CLIENT-ID")
            }
            
            guard let url = urlRequest.url else {
                throw OVError.NetworkResponseError.unableToDecode
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
                    URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                }
                
                guard let query = urlComponents.percentEncodedQuery else {
                    throw OVError.NetworkResponseError.unableToDecode
                }
                
                urlRequest.httpBody = Data(query.utf8)
            }
        }
        return urlRequest
    }
}

