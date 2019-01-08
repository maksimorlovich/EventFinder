//
//  UIImage+Extensions.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/7/19.
//

import Foundation
import UIKit

extension UIImage {
    static func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
