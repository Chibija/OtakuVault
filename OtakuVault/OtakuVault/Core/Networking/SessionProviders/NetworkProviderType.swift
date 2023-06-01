//
//  NetworkProviderType.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/19/23.
//

import Foundation
import Combine

typealias NetworkResponse = (data: Data, httpResponse: HTTPURLResponse?)

enum ResponseResult<String> {
    case success
    case failure(Error)
}

protocol NetworkProviderType {
    func request(_ target: TargetType) -> AnyPublisher<NetworkResponse, Error>
}

extension NetworkProviderType {
    func request<T: Codable>(_ target: TargetType, using decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        return request(target)
            .tryMap { (data, httpResponse) in
                let result = handleNetworkResponse(httpResponse)
                switch result {
                case .success:
                    return data
                case .failure(let error):
                    throw error
                }
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse?) -> ResponseResult<Error> {
        guard let response = response else { return .failure(OVError.NetworkResponseError.failed) }
        
        switch response.statusCode {
        case 200...299: return .success
        case 404: return .failure(OVError.NetworkResponseError.notFound)
        case 400: return .failure(OVError.NetworkResponseError.badRequest)
        case 406: return .failure(OVError.NetworkResponseError.notAcceptable)
        default: return .failure(OVError.NetworkResponseError.failed)
        }
    }
}
