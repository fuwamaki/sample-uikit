//
//  QiitaItem.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/10/12.
//

import Foundation

struct QiitaItem: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let url: String
    let user: QiitaItemUser

    var profileImageUrl: URL {
        URL(string: user.profileImageUrl)!
    }
}

struct QiitaItemUser: Codable, Hashable {
    let profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profile_image_url"
    }
}
