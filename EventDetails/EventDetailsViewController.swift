//
//  EventDetailsViewController.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/6/19.
//

import Foundation
import UIKit
import SeatGeekService
import PromiseKit

class EventDetailsViewController: UIViewController {
    // UI elements
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var favoritesBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var fullTitleLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var priceRangeLabel: UILabel!
    @IBOutlet private weak var buyTicketsButton: UIButton!
    
    // Publically settable dependencies
    var imageManager: ImageManager!
    var favoriteService: SeatGeekFavoriteService!
    var userId: UserID!
    var event: SeatGeekEvent!
    var favorite: Bool = false
    
    // Private variables
    private var eventId: SeatGeekEventId = 0
    private var ticketUrl: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        // Refresh, in case the favorite status was changed elsewhere
        self.favoriteService
            .getFavoriteEvents(for: self.userId)
            .done {
                self.favorite = $0.contains(self.eventId)
                self.redrawFavorite()
            }
            .cauterize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1)
        let image = UIImage.image(with: color, size: CGSize(width: 1, height: 1))
        self.buyTicketsButton.setBackgroundImage(image, for: .normal)
        self.title = self.event.shortTitle
        self.fullTitleLabel.text = self.event.title
        self.dateTimeLabel.text = DateFormatter.searchEventsFormatter.string(from: event.datetimeUtc)
        self.venueNameLabel.text = self.event.venue.name
        self.cityLabel.text = self.event.venue.displayLocation
        self.priceRangeLabel.text = "$\(self.event.stats.lowestPrice ?? 0) - $\(self.event.stats.highestPrice ?? 999)"
        self.eventId = self.event.identifier
        self.redrawFavorite()
        self.ticketUrl = self.event.url
        if let imageUrl = self.event.performers.first?.image {
            self.imageManager.download(image: imageUrl)
                .done { [weak self] image in
                    self?.eventImageView.image = image
                }
                .cauterize()
        } else {
            self.eventImageView.image = #imageLiteral(resourceName: "camera")
        }
    }
    
    private func redrawFavorite() {
        if self.favorite {
            self.favoritesBarButtonItem.image = #imageLiteral(resourceName: "filledHeart")
        } else {
            self.favoritesBarButtonItem.image = #imageLiteral(resourceName: "hollowHeart")
        }
    }
    
    @IBAction private func toggleFavorites() {
        self.isNavigationBarUserInteractionEnabled = false
        self.isTabBarUserInteractionEnabled = false
        let newFavorite = !self.favorite
        self.favoriteService
            .mark(favorite: newFavorite, event: self.eventId, for: self.userId)
            .done {
                self.favorite = newFavorite
                self.redrawFavorite()
            }
            .ensure {
                self.isNavigationBarUserInteractionEnabled = true
                self.isTabBarUserInteractionEnabled = true
            }
            .cauterize()
    }
    
    @IBAction private func buyTickets() {
        guard let ticketUrl = self.ticketUrl else { return }
        UIApplication.shared.open(ticketUrl)
    }
}

extension EventDetailsViewController {
    class func instantiate() -> EventDetailsViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "EventDetails", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController")
        // swiftlint:disable:next force_cast
        return viewController as! EventDetailsViewController
    }
}
