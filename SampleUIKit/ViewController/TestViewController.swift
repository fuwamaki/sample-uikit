//
//  TestViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class TestViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!

    private var testTip = TestTip()

    static func instantiate() -> TestViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! TestViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { @MainActor in
            for await shouldDisplay in testTip.shouldDisplayUpdates {
                if shouldDisplay {
                    let tipView = TipUIView(testTip)
                    view.addSubview(tipView)
                    NSLayoutConstraint.activate([
                        tipView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
                        tipView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
                        tipView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -24.0)
                    ])
                } else if let tipView = view.subviews.first(where: { $0 is TipUIView }) {
                    tipView.removeFromSuperview()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

import TipKit

struct TestTip: Tip {
    var title: Text {
        Text("test")
    }

    var message: Text? {
        Text("massage")
    }

    var image: Image? {
        Image(systemName: "scribble")
    }

    var options: [TipOption] {
        [MaxDisplayCount(1)]
    }
}
