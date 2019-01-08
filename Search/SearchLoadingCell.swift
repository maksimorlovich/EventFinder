//
//  SearchLoadingCell.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/5/19.
//

import Foundation
import UIKit

class SearchLoadingCell: UITableViewCell {
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicatorView.startAnimating()
    }
}
