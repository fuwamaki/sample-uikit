//
//  QiitaListViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/10/12.
//

import UIKit

final class QiitaListViewController: UIViewController {

    private enum Section {
        case main
    }

    private enum UnavailableState {
        case normal
        case empty(text: String)
        case loading
        case error
    }

    @IBOutlet private weak var collectionView: UICollectionView!

    private var apiClient = APIClient()
    private var items: [QiitaItem] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, QiitaItem>!

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchBar.tintColor = .systemTeal
        controller.searchBar.placeholder = "placeholder"
        return controller
    }()

    static func instantiate() -> QiitaListViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! QiitaListViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        setupUnavailableConfiguration(state: .normal)
        setupCollectionViewLayout()
        setupDataSource()
        setupInitialData()
    }

    private func setupUnavailableConfiguration(state: UnavailableState) {
        switch state {
        case .normal:
            self.contentUnavailableConfiguration = nil
        case .empty(let text):
            var config = UIContentUnavailableConfiguration.search()
            config.text = "No results for \"\(text)\""
            config.secondaryText = "Please try again after some time or tap Retry"
            var buttonConfig =  UIButton.Configuration.filled()
            buttonConfig.title = "Retry"
            config.button = buttonConfig
            config.buttonProperties.primaryAction = UIAction(handler: { _ in
                self.search(text: text)
            })
            self.contentUnavailableConfiguration = config
        case .loading:
            var config = UIContentUnavailableConfiguration.loading()
            config.text = "Fetching content. Please wait..."
            config.textProperties.font = .boldSystemFont(ofSize: 18)
            self.contentUnavailableConfiguration = config
        case .error:
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "exclamationmark.triangle")
            config.text = "Not founded."
            self.contentUnavailableConfiguration = config
        }
    }

    private func setupCollectionViewLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, QiitaItem> { cell, indexPath, item in
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                DispatchQueue.global().async {
                    if let url = URL(string: item.user.profileImageUrl),
                       let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data)?.resize(width: 40, height: 40) {
                            DispatchQueue.main.async {
                                content.image = image
                                cell.contentConfiguration = content
                            }
                        }
                    } else {
                        cell.contentConfiguration = content
                    }
                }
            }
        dataSource = UICollectionViewDiffableDataSource<Section, QiitaItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
    }

    private func setupInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, QiitaItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func search(text: String) {
        Task {
            setupUnavailableConfiguration(state: .loading)
            do {
                items = try await apiClient.fetchQiitaItem(query: text)
                setupInitialData()
                setupUnavailableConfiguration(state: items.isEmpty ? .empty(text: text) : .normal)
            } catch let error {
                debugPrint(error.localizedDescription)
                setupUnavailableConfiguration(state: .error)
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension QiitaListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            self.items = []
            setupInitialData()
            return
        }
        search(text: searchBarText)
    }
}
