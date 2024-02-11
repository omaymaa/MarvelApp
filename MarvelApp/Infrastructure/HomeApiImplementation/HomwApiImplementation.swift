//
//  HomwApiImplementation.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import RxSwift
final class HomwApiImplementation: HomeApiRepository {
    func getMarvelCharachters() -> Single<MarvelModel> {
        request(endPoint: "characters", method: .get, parameters: nil)
    }
    
}
