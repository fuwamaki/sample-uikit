//
//  CounterViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/08/25.
//

import UIKit

final class CounterViewController: UITableViewController {

    static func instantiate() -> CounterViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! CounterViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let indexPath = IndexPath(row: 5, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}
