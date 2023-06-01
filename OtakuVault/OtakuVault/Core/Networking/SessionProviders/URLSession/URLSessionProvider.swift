//
//  URLSessionProvider.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/19/23.
//

import Foundation
import Combine

struct URLSessionProvider: NetworkProviderType {
    let provider: URLSession
    
    init(provider: URLSession = .shared) {
        self.provider = provider
    }
    
    func request(_ target: TargetType) -> AnyPublisher<NetworkResponse, Error> {
        do {
            let request = try buildRequest(target)
            return provider.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .map { (data: $0.data, httpResponse: $0.response as? HTTPURLResponse) }
                .mapError {
                    return $0
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: OVError.NetworkResponseError.failed)
                .eraseToAnyPublisher()
        }
    }
    
    func buildRequest(_ target: TargetType) throws -> URLRequest {
        var request = URLRequest(url: target.baseURL.appendingPathComponent(target.path))
        request.httpMethod = target.method.rawValue
        
        request = addAuthType(target, request)

        switch target.task {
        case .requestParameters(let parameters, let encoding):
            return try encoding.encode(request, with: parameters)
        }
    }
    
    func addAuthType(_ target: TargetType, _ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        switch target.authorizationType {
        case .none:
            return request
        case .basic(let code):
            guard let data = code.data(using: .utf8) else { return request }
            let credentials = data.base64EncodedData()
            modifiedRequest.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
            return modifiedRequest
        case .bearer(let code):
            modifiedRequest.addValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
            return modifiedRequest
        }
    }
}
