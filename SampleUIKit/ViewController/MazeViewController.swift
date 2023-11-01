//
//  MazeViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/11/01.
//

import UIKit
import PencilKit

final class MazeViewController: UIViewController {

    static func instantiate() -> MazeViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! MazeViewController
    }

    private lazy var canvasView: CustomCanvasView = {
        let canvasView = CustomCanvasView(frame: view.frame)
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .blue, width: 7)
        return canvasView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvasView)
    }
}

final class CustomCanvasView: PKCanvasView {
    private var prevEventTime: TimeInterval?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        print(location)
    }
}
