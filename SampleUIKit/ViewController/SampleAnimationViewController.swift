//
//  SampleAnimationViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class SampleAnimationViewController: UIViewController {

    @IBOutlet private weak var blockLabel: UILabel!

    @IBAction private func clickTest(_ sender: UIButton) {
        let viewController = TestViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    static func instantiate() -> SampleAnimationViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! SampleAnimationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        blockLabel.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: {
            self.blockLabel.alpha = 1.0
        }, completion: nil)
    }
}
