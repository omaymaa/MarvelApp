//
//  MarvelDetailsViewController.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 07/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MarvelDetailsViewController: UIViewController {

    @IBOutlet weak var marvelDescription: UILabel!
    @IBOutlet weak var marvelName: UILabel!
    @IBOutlet weak var marvelImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionTableViewCell")
        }
    }
    
    var marvelDetailsViewModel = MarvelDetailsViewModel()
    let disposeBag = DisposeBag()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, [StoriesItem]>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, [StoriesItem]>>(
            configureCell: { [weak self] (_, tableView, indexPath, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath) as? SectionTableViewCell else {
                    fatalError("Unable to dequeue SectionTableViewCell")
                }

                // Configure the cell
                let sectionModel = self?.dataSource.sectionModels[indexPath.section]
                
                // Configure the cell
                cell.sectionTitle.text = sectionModel?.model
                cell.config(item: element, title: sectionModel?.model ?? "")
                cell.isPressed = { [weak self] index, data, allData in
                                   self?.showGallery(for: index, with: allData)
                               }

                return cell
            }
        )
        return dataSource
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        bindCharacterDetails()
        // Bind the data source to the table view
        marvelDetailsViewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        // Trigger the details loading
        marvelDetailsViewModel.loadDetails.onNext(())
    }

    private func bindCharacterDetails() {
        print("Binding character details")

        marvelDetailsViewModel.characterDetails
            .subscribe(onNext: { [weak self] character in
                print("Received character details:", character)
                DispatchQueue.main.async {
                    self?.marvelName.text = character.name
                    self?.marvelDescription.text = character.description
                    let imageUrl = URL(string: character.imageURl)
                    self?.marvelImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "icn-nav-marvel"))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showGallery(for index: Int, with data: [StoriesItem]) {
            let galleryViewController = AppStoryboard.Gallery.viewController(viewControllerClass: GalleryViewController.self)
            galleryViewController.modalPresentationStyle = .fullScreen
            galleryViewController.viewModel = GalleryViewModel()
        // Set data and selected index in the viewModel
            galleryViewController.viewModel.setData(data, selectedIndex: index)



            present(galleryViewController, animated: true)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {
           return
         }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
            }

    }

}
