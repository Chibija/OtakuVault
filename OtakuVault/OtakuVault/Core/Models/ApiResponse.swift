//
//  ApiResponse.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 6/1/23.
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let data: [T]
    let paging: ResponsePaging
}

struct ResponsePaging: Codable {
    var next: String
}
