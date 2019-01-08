//
//  UIViewController+Extensions.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/6/19.
//

import Foundation
import UIKit

extension UIViewController {
    var isNavigationBarUserInteractionEnabled: Bool {
        get { return self.navigationController?.navigationBar.isUserInteractionEnabled ?? false}
        set { self.navigationController?.navigationBar.isUserInteractionEnabled = newValue }
    }
    
    var isTabBarUserInteractionEnabled: Bool {
        get { return self.tabBarController?.tabBar.isUserInteractionEnabled ?? false}
        set { self.tabBarController?.tabBar.isUserInteractionEnabled = newValue }
    }
}
