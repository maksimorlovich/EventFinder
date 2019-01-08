//
//  ImageManager.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/5/19.
//

import Foundation
import PromiseKit
import UIKit

// Promise-based image cache class (uses LRU purge strategy)
class ImageManager {
    private var imageCache: [URL: Promise<UIImage>] = [:]
    private var lastAccess: [URL: Date] = [:]
    private let purgeThreshold = 100
    
    func download(image url: URL) -> Promise<UIImage> {
        if let promise = self.imageCache[url] {
            self.lastAccess[url] = Date()
            return promise
        }
        
        let promise = Alamofire.request(url, method: .get).responseData()
            .then { data, _ -> Promise<UIImage> in
                guard let image = UIImage(data: data) else {
                    throw AppError.badImageData
                }
                
                return Promise.value(image)
            }
        
        self.lastAccess[url] = Date()
        self.imageCache[url] = promise
        self.purgeIfNeeded()
        return promise
    }
    
    private func purgeIfNeeded() {
        guard self.imageCache.count == self.purgeThreshold else { return }
        
        // Sort by least recently accessed timestamp, and purge half the cached images
        let sorted = self.lastAccess.sorted(by: { $0.value < $1.value })
        sorted[0..<self.purgeThreshold/2].forEach {
            self.lastAccess.removeValue(forKey: $0.key)
            self.imageCache.removeValue(forKey: $0.key)
        }
    }
}

extension ImageManager {
    static var cameraImage = Promise.value(#imageLiteral(resourceName: "camera"))
}
