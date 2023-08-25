//
//  SampleAnimationViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class SampleAnimationViewController: UIViewController {

    static func instantiate() -> SampleAnimationViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! SampleAnimationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
