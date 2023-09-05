//
//  FeasibilityViewController.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/09/04.
//

import UIKit
import CoreLocation
import NetworkExtension
import AdSupport
import AppTrackingTransparency

final class FeasibilityViewController: UIViewController {

    @IBOutlet private weak var idfaValueLabel: UILabel!
    @IBOutlet private weak var globalIPAddressValueLabel: UILabel!
    @IBOutlet private weak var localIPAddressValueLabel: UILabel!
    @IBOutlet private weak var ssidValueLabel: UILabel!
    @IBOutlet private weak var bssidValueLabel: UILabel!

    @IBAction private func clickUpdateButton(_ sender: UIButton) {
        updateValue()
    }

    private var wifiLocalIPAdress: String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }

    static func instantiate() -> FeasibilityViewController {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! FeasibilityViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CLLocationManager().requestWhenInUseAuthorization()
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .restricted:
                print("restricted")
            case .notDetermined:
                print("notDetermined")
            @unknown default:
                fatalError()
            }
        }
        updateValue()
    }

    private func updateValue() {
        idfaValueLabel.text = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        Task {
            do {
                globalIPAddressValueLabel.text = try await fetchIPAddress()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        localIPAddressValueLabel.text = wifiLocalIPAdress
        NEHotspotNetwork.fetchCurrent { [weak self] network in
            self?.ssidValueLabel.text = network?.ssid
            self?.bssidValueLabel.text = network?.bssid
        }
    }
}

// MARK: API
extension FeasibilityViewController {
    func fetchIPAddress() async throws -> String? {
        let (data, response) = try await URLSession.shared.data(from: URL(string: "https://ipv4.icanhazip.com")!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unknownError
        }
        guard let result = String(data: data, encoding: .utf8) else {
            throw APIError.jsonParseError
        }
        return String(result.filter { !" \n\t\r".contains($0) })
    }
}

enum APIError: Error {
    case jsonParseError
    case unknownError
}
