//
//  HomeViewController.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 05/02/2024.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var totalCharacters = 0
    var isLoadingData = false
    
    var viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, MarvelCharacters>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MarvelCharacters>>(
            configureCell: { (_, tableView, indexPath, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MarvelTableViewCell", for: indexPath) as? MarvelTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: element)
                return cell
            })
        return dataSource
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        subscribe(to: viewModel.charactersList)
        tableView.rx.itemSelected
            .compactMap { (self.tableView.cellForRow(at:$0) as? MarvelTableViewCell)?.character }
          //  .bind(to: viewModel.selectedCharacter)
            .subscribe(onNext: {
                self.showCharacterDetail(for: $0)
            } )
            .disposed(by: disposeBag)
        

    }

    private func subscribe(to observable: Observable<[MarvelCharacters]>) {
        observable
            .map { $0.map {
                SectionModel(model: $0.name, items: [$0]) } }
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }

    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showCharacterDetail(for character: MarvelCharacters) {
        let detailsVC = AppStoryboard.CharacterDetails.viewController(viewControllerClass: MarvelDetailsViewController.self)
        // Pass the selected character to the details view model
        detailsVC.marvelDetailsViewModel = MarvelDetailsViewModel()
        detailsVC.marvelDetailsViewModel.setCharacterDetails(character)

        navigationController?.pushViewController(detailsVC, animated: true)
    }
 


    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}

