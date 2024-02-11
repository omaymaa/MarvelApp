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
    func getCharacters() -> Single<[MarvelCharacters]> {
        remoteApi.getMarvelCharachters()
            .asObservable()
            .compactMap {
                $0.data?.results?
                .map  {
                    MarvelCharacters($0)}  }
            .asSingle()
    }
}
