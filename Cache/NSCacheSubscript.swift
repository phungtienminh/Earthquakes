//
//  NSCacheSubscript.swift
//  Earthquakes-iOS
//
//  Created by Swiftaholic on 11/02/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ url: URL) -> CacheEntry? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.cacheEntry
        }
        set {
            let key = url.absoluteString as NSString
            if let value = newValue {
                let newEntry = CacheEntryObject(cacheEntry: value)
                setObject(newEntry, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
