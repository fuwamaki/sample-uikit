//
//  APIClient.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/10/12.
//

import Foundation

final class APIClient {
    func fetchQiitaItem(query: String) async throws -> [QiitaItem] {
        let url = URL(string: "https://qiita.com/api/v2/items?query=\(query)&page=1&per_page=50")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "unknown", code: 0)
        }
        return try JSONDecoder().decode([QiitaItem].self, from: data)
    }
}
