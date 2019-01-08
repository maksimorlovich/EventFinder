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
    
    // Private variables
    private var eventId: SeatGeekEventId = 0
    private var ticketUrl: URL? = nil
    private var favorite: Bool = false {
        didSet {
            if self.favorite {
                self.favoritesBarButtonItem.image = #imageLiteral(resourceName: "filledHeart")
            } else {
                self.favoritesBarButtonItem.image = #imageLiteral(resourceName: "hollowHeart")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1)
        let image = UIImage.image(with: color, size: CGSize(width: 1, height: 1))
        self.buyTicketsButton.setBackgroundImage(image, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        // Refresh, in case the favorite status was changed elsewhere
        let _ = self.favoriteService
            .getFavoriteEvents(for: self.userId)
            .done {
                self.favorite = $0.contains(self.eventId)
            }
    }
    
    func configure(with event: SeatGeekEvent, favorite: Bool) {
        self.title = event.shortTitle
        self.fullTitleLabel.text = event.title
        self.dateTimeLabel.text = DateFormatter.searchEventsFormatter.string(from: event.datetimeUtc)
        self.venueNameLabel.text = event.venue.name
        self.cityLabel.text = event.venue.displayLocation
        self.priceRangeLabel.text = "$\(event.stats.lowestPrice ?? 0) - $\(event.stats.highestPrice ?? 999)"
        self.eventId = event.id
        self.favorite = favorite
        self.ticketUrl = event.url
        if let imageUrl = event.performers.first?.image {
            let _ = self.imageManager.download(image: imageUrl)
                .done { [weak self] image in
                    self?.eventImageView.image = image
                }
        } else {
            self.eventImageView.image = #imageLiteral(resourceName: "camera")
        }
    }
    
    @IBAction private func toggleFavorites() {
        self.isNavigationBarUserInteractionEnabled = false
        self.isTabBarUserInteractionEnabled = false
        let newFavorite = !self.favorite
        let _ = self.favoriteService
            .mark(favorite: newFavorite, event: self.eventId, for: self.userId)
            .done {
                self.favorite = newFavorite
            }
            .ensure {
                self.isNavigationBarUserInteractionEnabled = true
                self.isTabBarUserInteractionEnabled = true
            }
    }
    
    @IBAction private func buyTickets() {
        guard let ticketUrl = self.ticketUrl else { return }
        UIApplication.shared.open(ticketUrl)
    }
}

extension EventDetailsViewController {
    class func instantiate() -> EventDetailsViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "EventDetails", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
    }
}
