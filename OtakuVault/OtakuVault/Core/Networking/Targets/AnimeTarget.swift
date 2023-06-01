//
//  AnimeTarget.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/30/23.
//

import Foundation

enum AnimeTarget {
    case getAnimeRanking(ranking: AnimeRankingType)
}
 
extension AnimeTarget: TargetType {
    var path: String {
        switch self {
        case .getAnimeRanking:
            return "/anime/ranking"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAnimeRanking:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAnimeRanking(let rankingType):
            let parameters = [
                "ranking_type": "\(rankingType)"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .getAnimeRanking:
            return .none
        }
    }
}

enum AnimeRankingType: String {
    case all
    case airing
    case upcoming
    case tv
    case ova
    case movie
    case special
    case bypopularity
    case favorite
}
