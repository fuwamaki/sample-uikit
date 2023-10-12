//
//  SampleEmptyViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/10/12.
//

import UIKit

final class SampleEmptyViewController: UIViewController {

    static func instantiate() -> SampleEmptyViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! SampleEmptyViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "logo.playstation")
        config.text = "PlayStation"
        config.button = .filled()
        config.secondaryText = "No new games Found"
        contentUnavailableConfiguration = config
    }
}
