//
//  HomeApiRepSitory.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import RxSwift
protocol HomeApiRepository: RemoteAPI {
    func getMarvelCharachters() -> Single<MarvelModel> 
}
