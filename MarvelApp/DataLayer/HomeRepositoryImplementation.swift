//
//  HomeRepositoryImplementation.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import RxSwift

final class HomeRepositoryImplementation: HomeRepository {
    private let remoteApi: HomeApiRepository = HomwApiImplementation()
    
    var currentPage = 0
    let pageSize = 20 
    
    func getCharacters() -> Single<[MarvelCharacters]> {
        currentPage += 1
        return getCharactersForPage(page: currentPage)
            .do(onError: { [weak self] error in
                // Reset currentPage if there's an error to retry pagination
                print("Error fetching characters: \(error)")
                self?.currentPage -= 1
            })
    }
    
    private func getCharactersForPage(page: Int) -> Single<[MarvelCharacters]> {
        return remoteApi.getMarvelCharacters(offset: (page - 1) * pageSize, limit: pageSize)
            .asObservable()
            .compactMap { $0.data?.results?.map { MarvelCharacters($0) } }
            .asSingle()
    }
}
