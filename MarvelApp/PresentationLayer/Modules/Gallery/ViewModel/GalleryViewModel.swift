//
//  GalleryViewModel.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 11/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class GalleryViewModel {
    // Inputs
    let data = BehaviorSubject<[StoriesItem]>(value: [])
    let selectedIndex = BehaviorSubject<Int>(value: 0)
    let onNextPressed = PublishSubject<Void>()
    let onPreviousPressed = PublishSubject<Void>()

    // Outputs
    let currentPage: Observable<Int>
    let numberOfPages: Observable<String>

    private let disposeBag = DisposeBag()

    init() {
        numberOfPages = data.map { "\($0.count)" }

        // Initialize currentPage observable
        currentPage = selectedIndex
            .map { $0 + 1 }  // Adjusting for 1-based index

        setupBindings()
    }

    func setData(_ newData: [StoriesItem], selectedIndex: Int) {
        data.onNext(newData)
        self.selectedIndex.onNext(selectedIndex)
    }

    func nextPressed() {
        do {
            let newDataCount = try data.value().count

            let nextIndex = (try selectedIndex.value() + 1) % newDataCount
            selectedIndex.onNext(nextIndex)
        } catch {
            print("Error getting current page value: \(error)")
        }
    }

    func previousPressed() {
        do {
            let newDataCount = try data.value().count

            let previousIndex = (try selectedIndex.value() - 1 + newDataCount) % newDataCount
            selectedIndex.onNext(previousIndex)
        } catch {
            print("Error getting current page value: \(error)")
        }
    }

    private func setupBindings() {
        onNextPressed
            .subscribe(onNext: { [weak self] in
                self?.nextPressed()
            })
            .disposed(by: disposeBag)

        onPreviousPressed
            .subscribe(onNext: { [weak self] in
                self?.previousPressed()
            })
            .disposed(by: disposeBag)
    }

    func scrollViewDidEndDecelerating(withIndex index: Int) {
        // Update the selectedIndex
        selectedIndex.onNext(index)
    }
}
