//
//  MainViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/06/23.
//

import UIKit

class MainViewController: UIViewController {

    private enum Section {
        case main
    }

    private enum ListType: Int, CaseIterable {
        case sampleAnimation
        case counter
        case test
        case white
        case horizontalPage
        case feasibility
        case qiitaList
        case sampleEmpty

        var text: String {
            return switch self {
            case .sampleAnimation: "Sample Animation"
            case .counter: "Counter"
            case .test: "Test"
            case .white: "White"
            case .horizontalPage: "Horizontal Page"
            case .feasibility: "Feasibility"
            case .qiitaList: "Qiita List"
            case .sampleEmpty: "Sample Empty"
            }
        }

        var instantiate: UIViewController {
            return switch self {
            case .sampleAnimation: SampleAnimationViewController.instantiate()
            case .counter: CounterViewController.instantiate()
            case .test: TestViewController.instantiate()
            case .white: WhiteViewController.instantiate()
            case .horizontalPage: HorizontalPageViewController.instantiate()
            case .feasibility: FeasibilityViewController.instantiate()
            case .qiitaList: QiitaListViewController.instantiate()
            case .sampleEmpty: SampleEmptyViewController.instantiate()
            }
        }
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            collectionView.collectionViewLayout = layout
        }
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, ListType>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupDataSource()
        setupInitialData()
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, ListType> { cell, indexPath, item in
                var content = cell.defaultContentConfiguration()
                content.text = item.text
                cell.contentConfiguration = content
            }
        dataSource = UICollectionViewDiffableDataSource<Section, ListType>(
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListType>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ListType.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let viewController = ListType(rawValue: indexPath.row)!.instantiate
        navigationController?.pushViewController(viewController, animated: true)
    }
}
