//
//  FavoritesViewController.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/7/19.
//

import UIKit
import PromiseKit
import SeatGeekService

protocol FavoritesViewControllerDelegate: class {
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
    weak var delegate: FavoritesViewControllerDelegate?
    
    // Private variables
    private var events: [SeatGeekEvent] = [] {
        didSet {
            self.tableView.allowsSelection = self.events.count > 0
            self.tableView.separatorStyle = self.events.count > 0 ? .singleLine : .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SearchEventsCell", bundle: nil),
                                forCellReuseIdentifier: "SearchEventsCell")
        self.tableView.register(UINib(nibName: "FavoritesNoFavesCell", bundle: nil),
                                forCellReuseIdentifier: "FavoritesNoFavesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.favoriteService.getFavoriteEvents(for: self.userId)
            .then { faves -> Promise<(events: [SeatGeekEvent], reload: Bool)> in
                // Optimize for bandwidth and time by only downloading the favorite deltas
                let newFavorites = Set(faves)
                let currentFavorites = Set(self.events.map { $0.identifier })
                let commonFavorites = newFavorites.intersection(currentFavorites)
                let downloadFavorites = newFavorites.subtracting(commonFavorites).map { $0 }
                
                // Filter current events and check if anything needs to be downloaded
                let filtered = self.events.filter { commonFavorites.contains($0.identifier) }
                guard downloadFavorites.count > 0 else {
                    let reload = filtered.count != self.events.count
                    return Promise.value((events: filtered, reload: reload))
                }
                
                // Download new ones, and merge with filtered events
                self.loadingIndicatorView.startAnimating()
                return self.eventService.search(by: .ids(downloadFavorites),
                                                perPage: downloadFavorites.count,
                                                page: 1)
                    .then { meta -> Promise<(events: [SeatGeekEvent], reload: Bool)> in
                        Promise.value((events: meta.events + filtered, reload: true))
                    }
            }
            .done { [weak self] in
                guard let self = self, $0.reload else { return }
                let currentEventCount = self.events.count
                let newEvents = $0.events.sorted(by: { $0.datetimeUtc < $1.datetimeUtc })
                
                // When going from no favorites to some favorites, or favorites
                // to no favorites, fade out tableview, then reload while it's invisible,
                // then fade in
                if  (currentEventCount == 0 && newEvents.count != 0) ||
                    (currentEventCount != 0 && newEvents.count == 0) {
                    UIView.animate(.promise, duration: 0.25, options: .curveLinear,
                                   animations: { self.tableView.alpha = 0 })
                        .then { _ -> Guarantee<Bool> in
                            self.events = newEvents
                            self.tableView.reloadData()
                            return UIView.animate(.promise, duration: 0.25, options: .curveLinear,
                                                  animations: { self.tableView.alpha = 1 })
                        }
                } else {
                    self.events = newEvents
                    self.tableView.reloadSections([0], with: .fade)
                }
            }
            .ensure { [weak self] in
                self?.loadingIndicatorView.stopAnimating()
            }
            .cauterize()
    }
}

extension FavoritesViewController {
    class func instantiate() -> FavoritesViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Favorites", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController")
        // swiftlint:disable:next force_cast
        return viewController as! FavoritesViewController
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
            return tableView.dequeueReusableCell(FavoritesNoFavesCell.self)
        } else {
            // Configure event cell
            let eventCell = tableView.dequeueReusableCell(SearchEventsCell.self)
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
