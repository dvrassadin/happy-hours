//
//  CacheImageObject.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/6/24.
//

import UIKit

final class CacheImageObject {
    
    let cacheImage: CacheImage
    
    init(cacheImage: CacheImage) {
        self.cacheImage = cacheImage
    }
    
}

enum CacheImage {
    
    case inProgress(Task<UIImage?, Error>)
    case ready(UIImage)
    
}
