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
    private var allCharacters: [MarvelCharacters] = []
    public var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        
    private let disposeBag = DisposeBag()
    // MARK: Methods
    
    init() {
        fetchCharacters()
    }
    
    func loadMore() {
        isLoading.onNext(true) // Notify loading start
        fetchCharacters()
       }
    
    private func fetchCharacters() {
            repository.getCharacters()
                .asObservable()
                .subscribe { [weak self] event in
                    guard let self = self else { return }
                    
                    self.isLoading.onNext(false) // Notify loading stop
                    
                    switch event {
                    case .next(let newCharacters):
                        print("Received new characters: \(newCharacters)")
                        
                        if newCharacters.isEmpty {
                            // Handle end of data or error
                            print("No new characters.")
                        } else {
                            self.allCharacters += newCharacters
                            self.charactersSubject.onNext(self.allCharacters)
                            print("All characters so far: \(self.allCharacters)")
                        }
                    case .error(let error):
                        // Handle error
                        print("Error fetching characters: \(error)")
                    default:
                        break
                    }
                }
                .disposed(by: disposeBag)
        }
}

