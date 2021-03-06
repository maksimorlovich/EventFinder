//
//  SearchEventsViewController.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/5/19.
//

import UIKit
import SeatGeekService

protocol SearchEventsViewControllerDelegate: class {
    func searchEvents(_ viewController: SearchEventsViewController,
                      didSelectEvent event: SeatGeekEvent,
                      favorite: Bool)
}

class SearchEventsViewController: UIViewController {
    // Constants
    private static let searchDelayThreshold: TimeInterval = 0.25
    private static let searchResultsPerPage = 25
    
    // UI elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // Publically settable dependencies
    var imageManager: ImageManager!
    var eventService: SeatGeekEventService!
    var favoriteService: SeatGeekFavoriteService!
    var userId: UserID!
    weak var delegate: SearchEventsViewControllerDelegate?
    
    // Private variables
    private var meta: SeatGeekEventSearchResultMeta!
    private var events: [SeatGeekEvent] = []
    private var lastIssuedSearchIndex = 0
    private var displayedSearchIndex = 0
    private var favorites: Set<SeatGeekEventId> = Set()
    private var searchKickoffTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SearchEventsCell", bundle: nil),
                                forCellReuseIdentifier: "SearchEventsCell")
        self.tableView.register(UINib(nibName: "SearchLoadingCell", bundle: nil),
                                forCellReuseIdentifier: "SearchLoadingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        // Refresh, in case the favorite status was changed elsewhere
        self.favoriteService
            .getFavoriteEvents(for: self.userId)
            .done { [weak self] in
                guard let self = self else { return }
                self.favorites = Set($0)

                self.tableView.visibleCells.forEach { cell in
                    guard let eventCell = cell as? SearchEventsCell,
                        let indexPath = self.tableView.indexPath(for: eventCell) else { return }

                    eventCell.favorite = self.favorites.contains(self.events[indexPath.row].identifier)
                }
            }
            .cauterize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tableView.isEditing = false
    }
}

extension SearchEventsViewController {
    private var haveMoreResults: Bool {
        return self.events.count < (self.meta?.total ?? 0)
    }
}

extension SearchEventsViewController {
    class func instantiate() -> SearchEventsViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchEventsViewController")
        // swiftlint:disable:next force_cast
        return viewController as! SearchEventsViewController
    }
}

extension SearchEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Handle the loading cell
        guard indexPath.row < self.events.count,
            let cell = self.tableView.cellForRow(at: indexPath) as? SearchEventsCell else {
            return UISwipeActionsConfiguration(actions: [])
        }

        let event = self.events[indexPath.row]
        let isFavorite = self.favorites.contains(event.identifier)
        let action = UIContextualAction(style: .normal,
                                        title: isFavorite ? "Unfavorite" : "Favorite") { (_, _, completionHandler ) in
                self.favoriteService
                    // Mark as (un)favorite
                    .mark(favorite: !isFavorite, event: event.identifier, for: self.userId)
                    // Refresh UI to reflect new favorite
                    .done {
                        if isFavorite {
                            self.favorites.remove(event.identifier)
                        } else {
                            self.favorites.insert(event.identifier)
                        }

                        cell.favorite = !isFavorite

                        completionHandler(true)
                    }
                    // Do nothing in case of an error
                    .catch { _ in
                        completionHandler(false)
                    }
            }
        
        action.image = #imageLiteral(resourceName: "filledHeart")
        action.backgroundColor = isFavorite ? .red : .gray
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // When the last row (loading cell) is about to be displayed, start downloading next page of results
        guard indexPath.row == self.events.count else { return }
        self.eventService.search(events: self.searchBar.text!,
                                         perPage: SearchEventsViewController.searchResultsPerPage,
                                         page: self.meta.page + 1)
            .done { [weak self] result in
                // Make sure the view controller is still alive
                guard let self = self else { return }
                // Ignore additional loaded results if there's a newer pending search
                guard self.displayedSearchIndex == self.lastIssuedSearchIndex else { return }
                // Search bar cleared by the user, ignore additional results
                guard self.meta != nil else { return }
                
                self.meta = result.meta
                self.events.append(contentsOf: result.events)
                self.tableView.reloadData()
            }
            .catch {
                print($0)
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle user tapping loading cell
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < self.events.count else { return }
        self.view.endEditing(true)
        let event = self.events[indexPath.row]
        self.delegate?.searchEvents(self,
                                    didSelectEvent: event,
                                    favorite: self.favorites.contains(event.identifier))
    }
}

extension SearchEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Event cells + one more loading cell when there are more results available
        return self.events.count + (self.haveMoreResults ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.events.count {
            // This is a loading spinner cell
            return tableView.dequeueReusableCell(SearchLoadingCell.self)
        } else {
            // This is an event cell, configure it
            let eventCell = tableView.dequeueReusableCell(SearchEventsCell.self)
            let event = self.events[indexPath.row]
            eventCell.favorite = self.favorites.contains(event.identifier)
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

extension SearchEventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchIndex = self.lastIssuedSearchIndex + 1
        self.lastIssuedSearchIndex = searchIndex
        
        // On empty string search, clear out the table view
        guard !searchText.isEmpty else {
            self.displayedSearchIndex = searchIndex
            self.searchKickoffTimer?.invalidate()
            self.meta = nil
            self.events = []
            self.loadingIndicatorView.stopAnimating()
            self.tableView.reloadData()
            return
        }

        self.searchKickoffTimer?.invalidate()
        self.searchKickoffTimer = Timer.scheduledTimer(withTimeInterval: SearchEventsViewController.searchDelayThreshold,
                                                       repeats: false) { [weak self] _ in
            guard let self = self, searchIndex >= self.lastIssuedSearchIndex else { return }
            self.loadingIndicatorView.startAnimating()
            self.eventService.search(events: searchText,
                                             perPage: SearchEventsViewController.searchResultsPerPage,
                                             page: 1)
                .done { [weak self] result in
                    // Make sure the view controller is still alive
                    guard let self = self else { return }
                    // Since search events may come back out of order, ignore older events
                    guard searchIndex > self.displayedSearchIndex else { return }

                    self.displayedSearchIndex = searchIndex
                    self.meta = result.meta
                    self.events = result.events

                    // Refresh the table
                    self.tableView.reloadData()

                    // Loading is complete when last issued search index matches displayed search index
                    if self.lastIssuedSearchIndex == self.displayedSearchIndex {
                        self.loadingIndicatorView.stopAnimating()
                    }
                }
                .catch { [weak self] _ in
                    self?.loadingIndicatorView.stopAnimating()
                }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
