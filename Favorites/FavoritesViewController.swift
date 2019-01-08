//
//  FavoritesViewController.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/7/19.
//

import UIKit
import PromiseKit
import SeatGeekService

protocol FavoritesViewControllerDelegate {
    func favorites(_ viewController: FavoritesViewController,
                   didSelectEvent event: SeatGeekEvent)
}

class FavoritesViewController: UIViewController {
    // UI elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // Publically settable dependencies
    var imageManager: ImageManager!
    var eventService: SeatGeekEventService!
    var favoriteService: SeatGeekFavoriteService!
    var userId: UserID!
    var delegate: FavoritesViewControllerDelegate?
    
    // Private variables
    private var events: [SeatGeekEvent] = [] {
        didSet {
            self.tableView.allowsSelection = self.events.count > 0
            self.tableView.separatorStyle = self.events.count > 0 ? .singleLine : .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SearchEventsCell", bundle: nil),
                                forCellReuseIdentifier: "SearchEventsCell")
        self.tableView.register(UINib(nibName: "FavoritesNoFavesCell", bundle: nil),
                                forCellReuseIdentifier: "FavoritesNoFavesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.loadingIndicatorView.startAnimating()
        let _ = self.favoriteService.getFavoriteEvents(for: self.userId)
            .then { faves -> Promise<[SeatGeekEvent]> in
                // Optimize for bandwidth and time by only downloading the favorite deltas
                let newFavorites = Set(faves)
                let currentFavorites = Set(self.events.map { $0.id })
                let commonFavorites = newFavorites.intersection(currentFavorites)
                let downloadFavorites = newFavorites.subtracting(commonFavorites).map { $0 }
                
                // Filter current events and check if anything needs to be downloaded
                let filtered = self.events.filter { commonFavorites.contains($0.id) }
                guard downloadFavorites.count > 0 else {
                    return Promise.value(filtered)
                }
                
                // Download new ones, and merge with filtered events
                return self.eventService.search(by: .ids(downloadFavorites),
                                                perPage: downloadFavorites.count,
                                                page: 1)
                    .then { meta -> Promise<[SeatGeekEvent]> in
                        Promise.value(meta.events + filtered)
                    }
            }
            .done { [weak self] in
                guard let self = self else { return }
                let currentEventCount = self.events.count
                self.events = $0.sorted(by: { $0.datetimeUtc < $1.datetimeUtc })
                
                // When going from no favorites to some favorites, or favorites
                // to no favorites, fade out tableview, then reload while it's invisible,
                // then fade in
                if  (currentEventCount == 0 && self.events.count != 0) ||
                    (currentEventCount != 0 && self.events.count == 0) {
                    UIView.animate(.promise, duration: 0.25, options: .curveLinear,
                                   animations: { self.tableView.alpha = 0 })
                        .then { _ -> Guarantee<Bool> in
                            self.tableView.reloadData()
                            return UIView.animate(.promise, duration: 0.25, options: .curveLinear,
                                                  animations: { self.tableView.alpha = 1 })
                        }
                } else {
                    self.tableView.reloadSections([0], with: .fade)
                }
            }
            .ensure { [weak self] in
                self?.loadingIndicatorView.stopAnimating()
            }
    }
}

extension FavoritesViewController {
    class func instantiate() -> FavoritesViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Favorites", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.events.count > 0 ? "Favorite Events" : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle user tapping loading cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        let event = self.events[indexPath.row]
        self.delegate?.favorites(self,
                                 didSelectEvent: event)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count == 0 ? 1 : self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.events.count == 0 {
            // No favorites
            let noFavoritesCell = tableView.dequeueReusableCell(withIdentifier: "FavoritesNoFavesCell") as! FavoritesNoFavesCell
            return noFavoritesCell
        } else {
            // Configure event cell
            let eventCell = tableView.dequeueReusableCell(withIdentifier: "SearchEventsCell") as! SearchEventsCell
            let event = self.events[indexPath.row]
            eventCell.favorite = false
            eventCell.eventName = event.title
            eventCell.eventCity = event.venue.displayLocation
            eventCell.eventDateTime = DateFormatter.searchEventsFormatter.string(from: event.datetimeUtc)
            if let imageUrl = event.performers.first?.image {
                eventCell.setImage(promise: self.imageManager.download(image: imageUrl))
            } else {
                eventCell.setImage(promise: ImageManager.cameraImage)
            }
            return eventCell
        }
    }
}
