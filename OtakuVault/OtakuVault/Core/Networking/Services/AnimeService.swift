//
//  AnimeService.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/30/23.
//

import Foundation
import Combine

protocol HasAnimeService {
    var animeService: AnimeServiceType { get }
}

protocol AnimeServiceType {
    func getTopRaking(for rankingType: AnimeRankingType) -> AnyPublisher<ApiResponse<RankingAnime>, Error>
}

struct AnimeService: AnimeServiceType {
    let provider: NetworkProviderType
    
    init(provider: NetworkProviderType) {
        self.provider = provider
    }
    
    func getTopRaking(for rankingType: AnimeRankingType) -> AnyPublisher<ApiResponse<RankingAnime>, Error> {
        provider.request(AnimeTarget.getAnimeRanking(ranking: rankingType))
    }
    
    
}
