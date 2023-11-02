//
//  Array+Addition.swift
//  SampleUIKit
//
//  Created by yusaku maki on 2023/11/02.
//

import Foundation

extension Array where Element: Equatable {
    func allContains(_ values: [Element]) -> Bool {
        values
            .compactMap({ self.contains($0) })
            .filter({ $0 })
            .count == values.count
    }
}
