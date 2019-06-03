//
//  SearchCoordinator.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 6/2/19.
//

import XCoordinator
import SeatGeekService

enum SearchRoute: Route {
    case search
    case details(SeatGeekEvent, Bool)
}

class SearchCoordinator: NavigationCoordinator<SearchRoute> {
    private let eventService: SeatGeekEventService
    private let favoriteService: SeatGeekFavoriteService
    private let imageManager: ImageManager
    private let userId: UserID
    
    init(eventService: SeatGeekEventService,
         favoriteService: SeatGeekFavoriteService,
         imageManager: ImageManager,
         userId: UserID) {
        
        self.eventService = eventService
        self.favoriteService = favoriteService
        self.imageManager = imageManager
        self.userId = userId
        super.init(initialRoute: .search)
    }
    
    override func prepareTransition(for route: SearchRoute) -> NavigationTransition {
        switch route {
        case .search:
            let searchViewController = SearchEventsViewController.instantiate()
            searchViewController.eventService = self.eventService
            searchViewController.imageManager = self.imageManager
            searchViewController.favoriteService = self.favoriteService
            searchViewController.userId = self.userId
            searchViewController.delegate = self
            return .push(searchViewController)
            
        case .details(let event, let favorite):
            let detailsViewController = EventDetailsViewController.instantiate()
            detailsViewController.imageManager = self.imageManager
            detailsViewController.favoriteService = self.favoriteService
            detailsViewController.userId = self.userId
            detailsViewController.event = event
            detailsViewController.favorite = favorite
            return .push(detailsViewController)
        }
    }
}

extension SearchCoordinator: SearchEventsViewControllerDelegate {
    func searchEvents(_ viewController: SearchEventsViewController,
                      didSelectEvent event: SeatGeekEvent,
                      favorite: Bool) {
        self.anyRouter.trigger(.details(event, favorite))
    }
}
