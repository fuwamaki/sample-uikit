//
//  WhiteViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/31.
//

import UIKit

final class WhiteViewController: UIViewController {

    static func instantiate() -> WhiteViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! WhiteViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
