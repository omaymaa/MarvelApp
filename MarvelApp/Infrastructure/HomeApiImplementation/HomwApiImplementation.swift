//
//  HomwApiImplementation.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import RxSwift

final class HomwApiImplementation: HomeApiRepository {
    func getMarvelCharacters(offset: Int, limit: Int) -> Single<MarvelModel> {
        let parameters = ["offset": offset, "limit": limit]
        let url = "characters"
        
        return request(endPoint: url, method: .get, parameters: parameters)
    }
}
