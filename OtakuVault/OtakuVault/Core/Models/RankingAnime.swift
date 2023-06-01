//
//  RankingAnime.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 6/1/23.
//

import Foundation

struct RankingAnime: Codable {
    let node: Node
    let ranking: Ranking
}

struct Node: Codable {
    let id: Int
    let name: String
    var mainPicture: MainPicture
}

struct Ranking: Codable {
    let rank: Int
}

struct MainPicture: Codable {
    var medium: String
    var large: String
}
