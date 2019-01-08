//
//  SearchEventsCell.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/5/19.
//

import Foundation
import UIKit
import PromiseKit

class SearchEventsCell: UITableViewCell {
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var eventCityLabel: UILabel!
    @IBOutlet private weak var eventDateTimeLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    var eventName: String = "" {
        didSet {
            self.eventNameLabel.text = self.eventName
        }
    }
    
    var eventCity: String = "" {
        didSet {
            self.eventCityLabel.text = self.eventCity
        }
    }
    
    var eventDateTime: String = "" {
        didSet {
            self.eventDateTimeLabel.text = self.eventDateTime
        }
    }
    
    var favorite: Bool = false {
        didSet {
            self.favoriteImageView.isHidden = !self.favorite
        }
    }
    
    private var reuseNumber = 0
    
    func setImage(promise: Promise<UIImage>) {
        let currentReuseNum = self.reuseNumber
        promise
            .done { [weak self] image in
                // Since cells are recycled, self never really becomes nil until
                // the tableview is destroyed; however, we need to make sure not to overwrite
                // a newer image from recycled cell with an older image.
                guard currentReuseNum == self?.reuseNumber else { return }
                guard let self = self else { return }
                self.eventImageView.image = image
                self.activityIndicatorView.stopAnimating()
            }
            .recover { [weak self] _ in
                guard currentReuseNum == self?.reuseNumber else { return }
                guard let self = self else { return }
                self.eventImageView.image = #imageLiteral(resourceName: "camera")
                self.activityIndicatorView.stopAnimating()
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reuseNumber = self.reuseNumber + 1
        self.eventImageView.image = nil
        self.activityIndicatorView.startAnimating()
    }
}
