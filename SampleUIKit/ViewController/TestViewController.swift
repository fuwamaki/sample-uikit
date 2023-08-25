//
//  TestViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class TestViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!

    static func instantiate() -> TestViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! TestViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
