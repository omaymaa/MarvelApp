//
//  HomeViewModel.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import RxSwift

final class HomeViewModel {
    
    // MARK: Properties
    
    private let repository: HomeRepository = HomeRepositoryImplementation()
    private let charactersSubject = BehaviorSubject<[MarvelCharacters]>(value: [])
    
    public var charactersList: Observable<[MarvelCharacters]> {
        return self.charactersSubject.asObserver()
    }
    public var selectedCharacter = PublishSubject<MarvelCharacters>()
    
    private let disposeBag = DisposeBag()
    // MARK: Methods
    
    init() {
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        repository.getCharacters()
            .asObservable()
            .subscribe { [weak self] in
                guard let self else { return }
                self.charactersSubject.onNext($0)
            }.disposed(by: disposeBag)
    }
    
    
   
    
    
    
}


//    private func subscribeToLoadMore() {
//            currentDisplayedItemSubject
//                .filter { $0 > 0 }
//                .filter { ((try? self.searchResultsSubject.value())?.count ?? 0) - 2 == $0 }
//                .subscribe(onNext: { [weak self] _ in
//                    guard let strongSelf = self else { return }
//                    if let keyword = try? strongSelf.searchTextSubject.value() {
//                        strongSelf.loadMovies(with: keyword)
//                    }
//                }).disposed(by: disposeBag)
//    }
