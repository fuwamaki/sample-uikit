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
        items = defaultItems
        setupInitialData()
    }

    private enum Section {
        case main
    }

    static func instantiate() -> Maze2ViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! Maze2ViewController
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, MazeItem>!

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

    private lazy var items: [MazeItem] = {
        defaultItems
    }()

    private var defaultItems: [MazeItem] {
        [
            MazeItem(0, .dot), MazeItem(1, .wallHorizontal), MazeItem(2, .dot), MazeItem(3, .wallHorizontal), MazeItem(4, .dot), MazeItem(5, .wallHorizontal), MazeItem(6, .dot), MazeItem(7, .wallHorizontal), MazeItem(8, .dot), MazeItem(9, .wallHorizontal), MazeItem(10, .dot), MazeItem(11, .spaceHorizontal), MazeItem(12, .dot),
            MazeItem(13, .wallVertical), MazeItem(14, .square), MazeItem(15, .spaceVertical), MazeItem(16, .square), MazeItem(17, .spaceVertical), MazeItem(18, .square), MazeItem(19, .spaceVertical), MazeItem(20, .square), MazeItem(21, .spaceVertical), MazeItem(22, .square), MazeItem(23, .spaceVertical), MazeItem(24, .square), MazeItem(25, .wallVertical),
            MazeItem(26, .dot), MazeItem(27, .spaceHorizontal), MazeItem(28, .dot), MazeItem(29, .wallHorizontal), MazeItem(30, .dot), MazeItem(31, .wallHorizontal), MazeItem(32, .dot), MazeItem(33, .wallHorizontal), MazeItem(34, .dot), MazeItem(35, .wallHorizontal), MazeItem(36, .dot), MazeItem(37, .wallHorizontal), MazeItem(38, .dot),
            MazeItem(39, .wallVertical), MazeItem(40, .square), MazeItem(41, .wallVertical), MazeItem(42, .square), MazeItem(43, .spaceVertical), MazeItem(44, .square), MazeItem(45, .spaceVertical), MazeItem(46, .square), MazeItem(47, .spaceVertical), MazeItem(48, .square), MazeItem(49, .spaceVertical), MazeItem(50, .square), MazeItem(51, .wallVertical),
            MazeItem(52, .dot), MazeItem(53, .spaceHorizontal), MazeItem(54, .dot), MazeItem(55, .spaceHorizontal), MazeItem(56, .dot), MazeItem(57, .wallHorizontal), MazeItem(58, .dot), MazeItem(59, .wallHorizontal), MazeItem(60, .dot), MazeItem(61, .spaceHorizontal), MazeItem(62, .dot), MazeItem(63, .wallHorizontal), MazeItem(64, .dot),
            MazeItem(65, .wallVertical), MazeItem(66, .square), MazeItem(67, .spaceVertical), MazeItem(68, .square), MazeItem(69, .wallVertical), MazeItem(70, .square), MazeItem(71, .spaceVertical), MazeItem(72, .square), MazeItem(73, .wallVertical), MazeItem(74, .square), MazeItem(75, .spaceVertical), MazeItem(76, .square), MazeItem(77, .wallVertical),
            MazeItem(78, .dot), MazeItem(79, .wallHorizontal), MazeItem(80, .dot), MazeItem(81, .wallHorizontal), MazeItem(82, .dot), MazeItem(83, .spaceHorizontal), MazeItem(84, .dot), MazeItem(85, .spaceHorizontal), MazeItem(86, .dot), MazeItem(87, .wallHorizontal), MazeItem(88, .dot), MazeItem(89, .spaceHorizontal), MazeItem(90, .dot),
            MazeItem(91, .wallVertical), MazeItem(92, .square), MazeItem(93, .spaceVertical), MazeItem(94, .square), MazeItem(95, .spaceVertical), MazeItem(96, .square), MazeItem(97, .wallVertical), MazeItem(98, .square), MazeItem(99, .spaceVertical), MazeItem(100, .square), MazeItem(101, .spaceVertical), MazeItem(102, .square), MazeItem(103, .wallVertical),
            MazeItem(104, .dot), MazeItem(105, .spaceHorizontal), MazeItem(106, .dot), MazeItem(107, .wallHorizontal), MazeItem(108, .dot), MazeItem(109, .wallHorizontal), MazeItem(110, .dot), MazeItem(111, .wallHorizontal), MazeItem(112, .dot), MazeItem(113, .wallHorizontal), MazeItem(114, .dot), MazeItem(115, .spaceHorizontal), MazeItem(116, .dot),
            MazeItem(117, .wallVertical), MazeItem(118, .square), MazeItem(119, .wallVertical), MazeItem(120, .square), MazeItem(121, .spaceVertical), MazeItem(122, .square), MazeItem(123, .spaceVertical), MazeItem(124, .square), MazeItem(125, .spaceVertical), MazeItem(126, .square), MazeItem(127, .wallVertical), MazeItem(128, .square), MazeItem(129, .wallVertical),
            MazeItem(130, .dot), MazeItem(131, .spaceHorizontal), MazeItem(132, .dot), MazeItem(133, .spaceHorizontal), MazeItem(134, .dot), MazeItem(135, .wallHorizontal), MazeItem(136, .dot), MazeItem(137, .spaceHorizontal), MazeItem(138, .dot), MazeItem(139, .wallHorizontal), MazeItem(140, .dot), MazeItem(141, .wallHorizontal), MazeItem(142, .dot),
            MazeItem(143, .wallVertical), MazeItem(144, .square), MazeItem(145, .spaceVertical), MazeItem(146, .square), MazeItem(147, .spaceVertical), MazeItem(148, .square), MazeItem(149, .wallVertical), MazeItem(150, .square), MazeItem(151, .spaceVertical), MazeItem(152, .square), MazeItem(153, .spaceVertical), MazeItem(154, .square), MazeItem(155, .wallVertical),
            MazeItem(156, .dot), MazeItem(157, .wallHorizontal), MazeItem(158, .dot), MazeItem(159, .wallHorizontal), MazeItem(160, .dot), MazeItem(161, .wallHorizontal), MazeItem(162, .dot), MazeItem(163, .wallHorizontal), MazeItem(164, .dot), MazeItem(165, .wallHorizontal), MazeItem(166, .dot), MazeItem(167, .spaceHorizontal), MazeItem(168, .dot)
        ]
    }

    private func setupInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MazeItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private var isShowed: Bool = false
    private func showPerfectAlert() {
        guard !isShowed else { return }
        isShowed = true
        let alert = UIAlertController(title: "よくできました！！！", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "とじる", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

extension Maze2ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return items[indexPath.row].type.size(collectionViewFrame: collectionView.frame)
    }
}

extension Maze2ViewController: CustomCanvasViewDelegate {
    func check(location: CGPoint) {
        if let index = items.firstIndex(where: { $0.isRange(
            collectionViewFrame: collectionView.frame,
            location: location
        ) }),
           !items[index].isValid,
           items[index].type.isSpace {
            items[index] = items[index].valid
            setupInitialData()
        }

        let validIndexList = items.filter { $0.isValid }.compactMap { $0.index }
        if validIndexList.contains(24),
           validIndexList.contains(14),
           validIndexList.contains(16),
           validIndexList.contains(18),
           validIndexList.contains(20),
           validIndexList.contains(22),
           validIndexList.contains(40),
           validIndexList.contains(42),
           validIndexList.contains(44),
           validIndexList.contains(46),
           validIndexList.contains(48),
           validIndexList.contains(66),
           validIndexList.contains(68),
           validIndexList.contains(70),
           validIndexList.contains(72),
           validIndexList.contains(74),
           validIndexList.contains(76),
           validIndexList.contains(92),
           validIndexList.contains(94),
           validIndexList.contains(96),
           validIndexList.contains(98),
           validIndexList.contains(100),
           validIndexList.contains(102),
           validIndexList.contains(118),
           validIndexList.contains(120),
           validIndexList.contains(122),
           validIndexList.contains(124),
           validIndexList.contains(144),
           validIndexList.contains(146),
           validIndexList.contains(150),
           validIndexList.contains(152),
           validIndexList.contains(154) {
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
}

private protocol CustomCanvasViewDelegate: AnyObject {
    func check(location: CGPoint)
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

    func size(collectionViewFrame: CGRect) -> CGSize {
        let oneSide: CGFloat = (collectionViewFrame.width - (8 * 7) - 0.1) / 6 // 0.1は調整用
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

    func isRange(collectionViewFrame: CGRect, location: CGPoint) -> Bool {
        let origin = CGPoint(x: collectionViewFrame.minX, y: collectionViewFrame.minY)
        let oneSide: CGFloat = (collectionViewFrame.width - (8 * 7) - 0.1) / 6 // 0.1は調整用
        let width = type.size(collectionViewFrame: collectionViewFrame).width
        let height = type.size(collectionViewFrame: collectionViewFrame).height
        let numberX = index % 13
        let numberY = index / 13
        let itemX = origin.x + CGFloat(CGFloat(numberX / 2) * CGFloat(8.0 + oneSide)) + CGFloat(CGFloat(numberX % 2) * 8.0)
        let itemY = origin.y + CGFloat(CGFloat(numberY / 2) * CGFloat(8.0 + oneSide)) + CGFloat(CGFloat(numberY % 2) * 8.0)
        let itemFrame = CGRect(x: itemX, y: itemY, width: width, height: height)
        return (itemFrame.minX <= location.x && location.x <= itemFrame.maxX)
        && (itemFrame.minY <= location.y && location.y <= itemFrame.maxY)
    }
}
