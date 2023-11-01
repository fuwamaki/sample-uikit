//
//  MazeViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/11/01.
//

import UIKit
import PencilKit

final class MazeViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBAction private func clickClearButton(_ sender: UIBarButtonItem) {
        canvasView.drawing = PKDrawing()
        items = Array(0..<64).compactMap { CellItem(id: $0) }
        setupInitialData()
    }

    private enum Section {
        case main
    }

    static func instantiate() -> MazeViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! MazeViewController
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, CellItem>!

    private lazy var canvasView: CustomCanvasView = {
        let canvasView = CustomCanvasView(frame: view.frame)
        canvasView.canvasDelegate = self
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pencil, color: .blue, width: 5)
        return canvasView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvasView)
        setupCollectionViewLayout()
        setupDataSource()
        setupInitialData()
    }

    private func setupCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.125),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.125)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, CellItem> { cell, indexPath, item in
                var content = cell.defaultContentConfiguration()
                content.textProperties.font = .systemFont(ofSize: 14)
                content.text = "\(String(item.id))"
                var backgroundConfig = cell.defaultBackgroundConfiguration()
                backgroundConfig.backgroundColor = item.isValid ? UIColor.systemMint : UIColor.systemBackground
                cell.backgroundConfiguration = backgroundConfig
                cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource<Section, CellItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
    }

    private lazy var items: [CellItem] = {
        Array(0..<64).compactMap { CellItem(id: $0) }
    }()

    private func setupInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MazeViewController: CustomCanvasViewDelegate {
    func check(location: CGPoint) {
        if let index = items.firstIndex(where: { $0.isRange(collectionViewFrame: collectionView.frame, location: location) }) {
            items[index] = CellItem(id: items[index].id, isValid: true)
            setupInitialData()
        }
    }
}

final class CustomCanvasView: PKCanvasView {
    weak var canvasDelegate: CustomCanvasViewDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        canvasDelegate?.check(location: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        canvasDelegate?.check(location: location)
    }
}

protocol CustomCanvasViewDelegate: AnyObject {
    func check(location: CGPoint)
}

struct CellItem: Hashable {
    let id: Int
    var isValid: Bool

    init(id: Int, isValid: Bool = false) {
        self.id = id
        self.isValid = isValid
    }

    func isRange(collectionViewFrame: CGRect, location: CGPoint) -> Bool {
        // 8*8だとして。
        let orgin = CGPoint(x: collectionViewFrame.minX, y: collectionViewFrame.minY)
        let width = collectionViewFrame.width / 8
        let height = collectionViewFrame.height / 8
        let itemFrame = CGRect(
            x: orgin.x + (width * CGFloat(id%8)),
            y: orgin.y + (height * CGFloat(id/8)),
            width: width,
            height: height
        )
        return (itemFrame.minX <= location.x && location.x <= itemFrame.maxX)
        && (itemFrame.minY <= location.y && location.y <= itemFrame.maxY)
    }
}
