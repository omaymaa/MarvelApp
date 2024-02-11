//
//  SectionTableViewCell.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 07/02/2024.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import RxDataSources

class SectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register(UINib(nibName: "MarvelCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MarvelCategoryCollectionViewCell")
        }
    }
    @IBOutlet weak var sectionTitle: UILabel!
    var isPressed: ((_ index: Int, _ data: StoriesItem, _ allData: [StoriesItem]) -> ())?
    private let disposeBag = DisposeBag()
    
    var data: BehaviorRelay<[StoriesItem]> = BehaviorRelay(value: [])
    var selectedData: StoriesItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }
    
    func config(item: [StoriesItem], title: String) {
        sectionTitle.text = title
        data.accept(item)
        print("Data accepted:", item)

    }
    
    private func setupBindings() {
        data
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "MarvelCategoryCollectionViewCell", cellType: MarvelCategoryCollectionViewCell.self)) { (row, element, cell) in
                cell.marvelCategoryName.text = element.name
                cell.marvelCategoryImg.image = UIImage(named: "icn-nav-marvel")
            }
            .disposed(by: disposeBag)
        collectionView.rx.itemSelected
                   .subscribe(onNext: { [weak self] indexPath in
                       guard let index = self?.validateIndexPath(indexPath), let data = self?.data.value else {
                           return
                       }
                       let selectedItem = data[index]
                       self?.selectedData = selectedItem
                       self?.isPressed?(index, selectedItem, data)
                   })
                   .disposed(by: disposeBag)

        // Customize layout if needed
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func validateIndexPath(_ indexPath: IndexPath) -> Int? {
            guard indexPath.row < data.value.count else {
                return nil
            }
            return indexPath.row
        }
}

    extension SectionTableViewCell: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width / 3, height: 340) // Adjust this as needed
        }
    }
