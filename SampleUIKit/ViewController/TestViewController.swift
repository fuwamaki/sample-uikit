//
//  TestViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class TestViewController: UIViewController {

    static func instantiate() -> TestViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! TestViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
