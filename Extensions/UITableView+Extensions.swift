//
//  UITableView+Extensions.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 5/31/19.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withIdentifier: T.self.identifier()) as! T
    }
}

extension UITableViewCell {
    class func identifier() -> String {
        let classpath = NSStringFromClass(self)
        return classpath.components(separatedBy: ".").last ?? ""
    }
}
