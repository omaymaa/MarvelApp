//
//  BrochurePopupViewController.swift
//  dekkan
//
//  Created by Omar on 25/04/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class GalleryViewController: UIViewController {

    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backForward: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberOfPagesLabel: UILabel!

    var viewModel: GalleryViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()

        // Subscribe to currentPage to get the initial value
        viewModel.currentPage
            .subscribe(onNext: { [weak self] index in
                // Scroll to the initial selected index
                self?.collectionView.scrollToItem(at: IndexPath(item: index - 1, section: 0), at: .centeredHorizontally, animated: false)
            })
            .disposed(by: disposeBag)
    }

    private func setupBindings() {
        // Bindings for data
        viewModel.data
            .observe(on: MainScheduler.instance) // Ensure UI updates are on the main thread
            .bind(to: collectionView.rx.items(cellIdentifier: "GalleryCollectionViewCell", cellType: GalleryCollectionViewCell.self)) { (index, element, cell) in
                // Update the cell content
                cell.itemName.text = element.name
                cell.itemImage.image = UIImage(named: "icn-nav-marvel")

            }
            .disposed(by: disposeBag)

        // Bindings for currentPage and numberOfPages
        viewModel.currentPage
            .map { "\($0)" }
            .bind(to: numberOfPagesLabel.rx.text)
            .disposed(by: disposeBag)

        // Bindings for closePressed, nextPressed, and previousPressed
        forwardButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onNextPressed.onNext(())
            })
            .disposed(by: disposeBag)

        backForward.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onPreviousPressed.onNext(())
            })
            .disposed(by: disposeBag)

        // Bind scrollViewDidEndDecelerating
        collectionView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                self?.scrollViewDidEndDecelerating()
            })
            .disposed(by: disposeBag)
    }

    func scrollViewDidEndDecelerating() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        viewModel.scrollViewDidEndDecelerating(withIndex: indexPath.row)
    }

    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func nextPressed(_ sender: Any) {
        viewModel.onNextPressed.onNext(())
    }

    @IBAction func previousePressed(_ sender: Any) {
        viewModel.onPreviousPressed.onNext(())
    }
}


extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
