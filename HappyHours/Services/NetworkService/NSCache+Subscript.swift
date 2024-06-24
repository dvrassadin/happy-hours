//
//  NSCache+Subscript.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/6/24.
//

import UIKit

extension NSCache where KeyType == NSString, ObjectType == CacheImageObject {
    
    subscript(_ url: URL) -> CacheImage? {
        get  {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.cacheImage
        }
        set {
            let key = url.absoluteString as NSString
            if let cacheImage = newValue {
                let value = CacheImageObject(cacheImage: cacheImage)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
    
}
