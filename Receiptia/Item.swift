//
//  Item.swift
//  Receiptia
//
//  Created by Nicola on 22/01/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
