//
//  MarvelDetailsViewModel.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 10/02/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import UIKit

class MarvelDetailsViewModel {
    // Inputs
    let loadDetails = PublishSubject<Void>()

    // Outputs
    let characterDetails: Observable<MarvelCharacters>
    let sections: Observable<[SectionModel<String, [StoriesItem]>]>
    
    var presentGalleryViewController: ((_ galleryViewController: UIViewController) -> Void)?

    private let disposeBag = DisposeBag()
    private let detailsSubject = BehaviorSubject<MarvelCharacters?>(value: nil)

    init() {
        self.characterDetails = detailsSubject
            .compactMap { $0 }
            .asObservable()

        // Explicitly specify the type for each SectionModel
        self.sections = detailsSubject
            .map { character -> [SectionModel<String, [StoriesItem]>]? in
                guard let character = character else { return nil }
                let comicsItems = character.comics?.items ?? []
                let seriesItems = character.series?.items ?? []
                let storiesItems = character.stories?.items ?? []
                let eventsItems = character.events?.items ?? []

                return [
                    SectionModel<String, [StoriesItem]>(model: "Comics", items: [comicsItems]),
                    SectionModel<String, [StoriesItem]>(model: "Series", items: [seriesItems]),
                    SectionModel<String, [StoriesItem]>(model: "Stories", items: [storiesItems]),
                    SectionModel<String, [StoriesItem]>(model: "Events", items: [eventsItems])
                ]
            }
            .compactMap { $0 }  // Remove nil values

    }

    // Method to set character details
    func setCharacterDetails(_ character: MarvelCharacters) {
        print("setCharacterDetails called with character:", character)
        detailsSubject.onNext(character)
    }
    
}

