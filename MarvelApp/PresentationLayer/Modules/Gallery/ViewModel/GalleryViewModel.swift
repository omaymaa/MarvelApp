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

    private var timer: Timer?
    private var disposeBag = DisposeBag()

    init() {
        numberOfPages = data.map { "\($0.count)" }

        // Initialize currentPage observable
        currentPage = Observable.combineLatest(selectedIndex, data)
            .map { selectedIndex, data in
                let adjustedIndex = (selectedIndex < data.count) ? selectedIndex : 0
                return adjustedIndex + 1  // Adjusting for 1-based index
            }

        setupBindings()
    }

    func setData(_ newData: [StoriesItem], selectedIndex: Int) {
        data.onNext(newData)
        self.selectedIndex.onNext(selectedIndex)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    @objc func fireTimer() {
        do {
            let currentValue = try selectedIndex.value()
            let newDataCount = try data.value().count

            selectedIndex.onNext((currentValue < newDataCount - 1) ? (currentValue + 1) : 0)
        } catch {
            print("Error getting current page value: \(error)")
        }
    }

    func nextPressed() {
        do {
            let currentValue = try selectedIndex.value()
            let newDataCount = try data.value().count

            selectedIndex.onNext((currentValue < newDataCount - 1) ? (currentValue + 1) : 0)
        } catch {
            print("Error getting current page value: \(error)")
        }
    }

    func previousPressed() {
        do {
            let currentValue = try selectedIndex.value()
            let newDataCount = try data.value().count

            selectedIndex.onNext((currentValue > 0) ? (currentValue - 1) : newDataCount - 1)
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
        selectedIndex.onNext(index + 1) // Adjusting for 1-based index
    }

    deinit {
        timer?.invalidate()
    }
}
