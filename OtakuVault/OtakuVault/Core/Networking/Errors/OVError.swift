//
//  OVError.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/19/23.
//

import Foundation

struct OVError {
    enum NetworkError: Error {
        case invalidURL
    }
    
    enum NetworkResponseError: Error {
        case success
        case notFound
        case badRequest
        case notAcceptable
        case failed
        case noData
        case unableToDecode
    }
}

extension OVError.NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Unreachable URL", comment: "")
        }
    }
}

extension OVError.NetworkResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .success:
            return NSLocalizedString("", comment: "")
        case .notFound:
            return NSLocalizedString("The specified resource could not be found", comment: "")
        case .badRequest:
            return NSLocalizedString("Bad request.", comment: "")
        case .notAcceptable:
            return NSLocalizedString("You requested a format that isn't json.", comment: "")
        case .failed:
            return NSLocalizedString("Network request failed.", comment: "")
        case .noData:
            return NSLocalizedString("Response returned with no data to decode.", comment: "")
        case .unableToDecode:
            return NSLocalizedString("Could not decode the response.", comment: "")
        }
    }
}

