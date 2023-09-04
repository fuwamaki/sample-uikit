//
//  FeasibilityViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/09/04.
//

import UIKit
import CoreLocation
import NetworkExtension

final class FeasibilityViewController: UIViewController {

    @IBOutlet private weak var idfaValueLabel: UILabel!
    @IBOutlet private weak var idAddressValueLabel: UILabel!
    @IBOutlet private weak var ssidValueLabel: UILabel!
    @IBOutlet private weak var bssidValueLabel: UILabel!

    @IBAction private func clickUpdateButton(_ sender: UIButton) {
        updateValue()
    }

    static func instantiate() -> FeasibilityViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! FeasibilityViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CLLocationManager().requestWhenInUseAuthorization()
        updateValue()
    }

    private func updateValue() {
        NEHotspotNetwork.fetchCurrent { [weak self] network in
            self?.ssidValueLabel.text = network?.ssid
            self?.bssidValueLabel.text = network?.bssid
        }
    }
}
