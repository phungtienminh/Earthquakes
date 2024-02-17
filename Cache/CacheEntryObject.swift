//
//  CacheEntryObject.swift
//  Earthquakes-iOS
//
//  Created by Swiftaholic on 11/02/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}

final class CacheEntryObject {
    public let cacheEntry: CacheEntry
    
    init(cacheEntry: CacheEntry) {
        self.cacheEntry = cacheEntry
    }
}
