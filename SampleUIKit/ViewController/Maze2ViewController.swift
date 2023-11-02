//
//  Maze2ViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/11/02.
//

import UIKit
import PencilKit

final class Maze2ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBAction private func clickClearButton(_ sender: UIBarButtonItem) {
        canvasView.drawing = PKDrawing()
        items = entity.defaultItems
        updateDataSource()
    }

    private enum Section {
        case main
    }

    static func instantiate() -> Maze2ViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        let viewController = storyboard.instantiateInitialViewController() as! Maze2ViewController
        viewController.entity = entity1
        return viewController
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, MazeItem>!
    private var isShowedPerfectAlert: Bool = false
    private var entity: MazeEntity!
    private lazy var items: [MazeItem] = {
        entity.defaultItems
    }()

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
        updateDataSource()
    }

    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, MazeItem> { cell, indexPath, item in
                let content = cell.defaultContentConfiguration()
                cell.contentConfiguration = content
                var backgroundConfig = cell.defaultBackgroundConfiguration()
                switch item.type {
                case .dot, .wallHorizontal, .wallVertical:
                    backgroundConfig.backgroundColor = .darkGray
                case .spaceVertical, .spaceHorizontal, .square:
                    backgroundConfig.backgroundColor = .systemBackground
                    backgroundConfig.backgroundColor = item.isValid ? .systemTeal : .systemBackground
                }
                cell.backgroundConfiguration = backgroundConfig
            }
        dataSource = UICollectionViewDiffableDataSource<Section, MazeItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MazeItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func showPerfectAlert() {
        guard !isShowedPerfectAlert else { return }
        isShowedPerfectAlert = true
        let alert = UIAlertController(title: "よくできました！！！", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "とじる", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension Maze2ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let oneSide: CGFloat = (collectionView.frame.width - CGFloat(8 * entity.dotSideCount) - 0.01) / CGFloat(entity.roadSideCount) // 0.01は調整用
        return items[indexPath.row].type.size(collectionViewFrame: collectionView.frame, oneSide: oneSide)
    }
}

// MARK: CustomCanvasViewDelegate
extension Maze2ViewController: CustomCanvasViewDelegate {
    func check(location: CGPoint) {
        if let index = items.firstIndex(where: { $0.isRange(
            collectionViewFrame: collectionView.frame,
            location: location,
            entity: entity
        )}),
           !items[index].isValid,
           items[index].type.isSpace {
            items[index] = items[index].valid
            updateDataSource()
        }

    }
    func checkComplete() {
        let isCompleted = items
            .filter { $0.isValid }
            .compactMap { $0.index }
            .allContains(entity.validIds)
        if isCompleted {
            showPerfectAlert()
        }
    }
}

private final class CustomCanvasView: PKCanvasView {
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasDelegate?.checkComplete()
    }
}

private protocol CustomCanvasViewDelegate: AnyObject {
    func check(location: CGPoint)
    func checkComplete()
}

private enum MazeItemType {
    case dot
    case wallHorizontal
    case spaceHorizontal
    case wallVertical
    case spaceVertical
    case square

    var isSpace: Bool {
        return switch self {
        case .dot, .wallHorizontal, .wallVertical: false
        case .spaceHorizontal, .spaceVertical, .square: true
        }
    }

    func size(collectionViewFrame: CGRect, oneSide: CGFloat) -> CGSize {
        return switch self {
        case .dot:
            CGSize(width: 8, height: 8)
        case .wallHorizontal, .spaceHorizontal:
            CGSize(width: oneSide, height: 8)
        case .wallVertical, .spaceVertical:
            CGSize(width: 8, height: oneSide)
        case .square:
            CGSize(width: oneSide, height: oneSide)
        }
    }
}

private struct MazeItem: Hashable {
    let index: Int
    let type: MazeItemType
    var isValid: Bool

    init(_ index: Int, _ type: MazeItemType, isValid: Bool = false) {
        self.index = index
        self.type = type
        self.isValid = isValid
    }

    var valid: MazeItem {
        MazeItem(index, type, isValid: true)
    }

    func isRange(collectionViewFrame: CGRect, location: CGPoint, entity: MazeEntity) -> Bool {
        let origin = CGPoint(x: collectionViewFrame.minX, y: collectionViewFrame.minY)
        let oneSide: CGFloat = (collectionViewFrame.width - CGFloat(8 * entity.dotSideCount) - 0.01) / CGFloat(entity.roadSideCount) // 0.01は調整用
        let numberX = index % entity.sideCount
        let numberY = index / entity.sideCount
        let itemX = origin.x + CGFloat(CGFloat(numberX / 2) * CGFloat(8.0 + oneSide)) + CGFloat(CGFloat(numberX % 2) * 8.0)
        let itemY = origin.y + CGFloat(CGFloat(numberY / 2) * CGFloat(8.0 + oneSide)) + CGFloat(CGFloat(numberY % 2) * 8.0)
        let width = type.size(collectionViewFrame: collectionViewFrame, oneSide: oneSide).width
        let height = type.size(collectionViewFrame: collectionViewFrame, oneSide: oneSide).height
        let itemFrame = CGRect(x: itemX, y: itemY, width: width, height: height)
        return (itemFrame.minX <= location.x && location.x <= itemFrame.maxX)
        && (itemFrame.minY <= location.y && location.y <= itemFrame.maxY)
    }
}

private struct MazeEntity {
    let validIds: [Int]
    let dictionary: [(index: Int, type: MazeItemType)]

    init(validIds: [Int], dictionary: [(index: Int, type: MazeItemType)]) {
        self.validIds = validIds
        self.dictionary = dictionary
    }

    var defaultItems: [MazeItem] {
        dictionary.compactMap { MazeItem($0.index, $0.type) }
    }

    // 一辺の数。絶対奇数。
    var sideCount: Int {
        Int(sqrt(Double(dictionary.count)))
    }

    // 一辺のdot総数。
    var dotSideCount: Int {
        Int(sideCount/2) + 1
    }

    // 一辺のdot以外の総数。
    var roadSideCount: Int {
        sideCount - dotSideCount
    }
}

private let entity1 = MazeEntity(
    validIds: [
        14,
        16,
        18,
        20,
        22,
        24,
        40,
        42,
        44,
        46,
        48,
        66,
        68,
        70,
        72,
        74,
        76,
        92,
        94,
        96,
        98,
        100,
        102,
        118,
        120,
        122,
        124,
        144,
        146,
        150,
        152,
        154
    ],
    dictionary: [
        (index: 0, type: .dot),
        (index: 1, type: .wallHorizontal),
        (index: 2, type: .dot),
        (index: 3, type: .wallHorizontal),
        (index: 4, type: .dot),
        (index: 5, type: .wallHorizontal),
        (index: 6, type: .dot),
        (index: 7, type: .wallHorizontal),
        (index: 8, type: .dot),
        (index: 9, type: .wallHorizontal),
        (index: 10, type: .dot),
        (index: 11, type: .spaceHorizontal),
        (index: 12, type: .dot),
        (index: 13, type: .wallVertical),
        (index: 14, type: .square),
        (index: 15, type: .spaceVertical),
        (index: 16, type: .square),
        (index: 17, type: .spaceVertical),
        (index: 18, type: .square),
        (index: 19, type: .spaceVertical),
        (index: 20, type: .square),
        (index: 21, type: .spaceVertical),
        (index: 22, type: .square),
        (index: 23, type: .spaceVertical),
        (index: 24, type: .square),
        (index: 25, type: .wallVertical),
        (index: 26, type: .dot),
        (index: 27, type: .spaceHorizontal),
        (index: 28, type: .dot),
        (index: 29, type: .wallHorizontal),
        (index: 30, type: .dot),
        (index: 31, type: .wallHorizontal),
        (index: 32, type: .dot),
        (index: 33, type: .wallHorizontal),
        (index: 34, type: .dot),
        (index: 35, type: .wallHorizontal),
        (index: 36, type: .dot),
        (index: 37, type: .wallHorizontal),
        (index: 38, type: .dot),
        (index: 39, type: .wallVertical),
        (index: 40, type: .square),
        (index: 41, type: .wallVertical),
        (index: 42, type: .square),
        (index: 43, type: .spaceVertical),
        (index: 44, type: .square),
        (index: 45, type: .spaceVertical),
        (index: 46, type: .square),
        (index: 47, type: .spaceVertical),
        (index: 48, type: .square),
        (index: 49, type: .spaceVertical),
        (index: 50, type: .square),
        (index: 51, type: .wallVertical),
        (index: 52, type: .dot),
        (index: 53, type: .spaceHorizontal),
        (index: 54, type: .dot),
        (index: 55, type: .spaceHorizontal),
        (index: 56, type: .dot),
        (index: 57, type: .wallHorizontal),
        (index: 58, type: .dot),
        (index: 59, type: .wallHorizontal),
        (index: 60, type: .dot),
        (index: 61, type: .spaceHorizontal),
        (index: 62, type: .dot),
        (index: 63, type: .wallHorizontal),
        (index: 64, type: .dot),
        (index: 65, type: .wallVertical),
        (index: 66, type: .square),
        (index: 67, type: .spaceVertical),
        (index: 68, type: .square),
        (index: 69, type: .wallVertical),
        (index: 70, type: .square),
        (index: 71, type: .spaceVertical),
        (index: 72, type: .square),
        (index: 73, type: .wallVertical),
        (index: 74, type: .square),
        (index: 75, type: .spaceVertical),
        (index: 76, type: .square),
        (index: 77, type: .wallVertical),
        (index: 78, type: .dot),
        (index: 79, type: .wallHorizontal),
        (index: 80, type: .dot),
        (index: 81, type: .wallHorizontal),
        (index: 82, type: .dot),
        (index: 83, type: .spaceHorizontal),
        (index: 84, type: .dot),
        (index: 85, type: .spaceHorizontal),
        (index: 86, type: .dot),
        (index: 87, type: .wallHorizontal),
        (index: 88, type: .dot),
        (index: 89, type: .spaceHorizontal),
        (index: 90, type: .dot),
        (index: 91, type: .wallVertical),
        (index: 92, type: .square),
        (index: 93, type: .spaceVertical),
        (index: 94, type: .square),
        (index: 95, type: .spaceVertical),
        (index: 96, type: .square),
        (index: 97, type: .wallVertical),
        (index: 98, type: .square),
        (index: 99, type: .spaceVertical),
        (index: 100, type: .square),
        (index: 101, type: .spaceVertical),
        (index: 102, type: .square),
        (index: 103, type: .wallVertical),
        (index: 104, type: .dot),
        (index: 105, type: .spaceHorizontal),
        (index: 106, type: .dot),
        (index: 107, type: .wallHorizontal),
        (index: 108, type: .dot),
        (index: 109, type: .wallHorizontal),
        (index: 110, type: .dot),
        (index: 111, type: .wallHorizontal),
        (index: 112, type: .dot),
        (index: 113, type: .wallHorizontal),
        (index: 114, type: .dot),
        (index: 115, type: .spaceHorizontal),
        (index: 116, type: .dot),
        (index: 117, type: .wallVertical),
        (index: 118, type: .square),
        (index: 119, type: .wallVertical),
        (index: 120, type: .square),
        (index: 121, type: .spaceVertical),
        (index: 122, type: .square),
        (index: 123, type: .spaceVertical),
        (index: 124, type: .square),
        (index: 125, type: .spaceVertical),
        (index: 126, type: .square),
        (index: 127, type: .wallVertical),
        (index: 128, type: .square),
        (index: 129, type: .wallVertical),
        (index: 130, type: .dot),
        (index: 131, type: .spaceHorizontal),
        (index: 132, type: .dot),
        (index: 133, type: .spaceHorizontal),
        (index: 134, type: .dot),
        (index: 135, type: .wallHorizontal),
        (index: 136, type: .dot),
        (index: 137, type: .spaceHorizontal),
        (index: 138, type: .dot),
        (index: 139, type: .wallHorizontal),
        (index: 140, type: .dot),
        (index: 141, type: .wallHorizontal),
        (index: 142, type: .dot),
        (index: 143, type: .wallVertical),
        (index: 144, type: .square),
        (index: 145, type: .spaceVertical),
        (index: 146, type: .square),
        (index: 147, type: .spaceVertical),
        (index: 148, type: .square),
        (index: 149, type: .wallVertical),
        (index: 150, type: .square),
        (index: 151, type: .spaceVertical),
        (index: 152, type: .square),
        (index: 153, type: .spaceVertical),
        (index: 154, type: .square),
        (index: 155, type: .wallVertical),
        (index: 156, type: .dot),
        (index: 157, type: .wallHorizontal),
        (index: 158, type: .dot),
        (index: 159, type: .wallHorizontal),
        (index: 160, type: .dot),
        (index: 161, type: .wallHorizontal),
        (index: 162, type: .dot),
        (index: 163, type: .wallHorizontal),
        (index: 164, type: .dot),
        (index: 165, type: .wallHorizontal),
        (index: 166, type: .dot),
        (index: 167, type: .spaceHorizontal),
        (index: 168, type: .dot)
    ]
)
