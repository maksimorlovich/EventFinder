//
//  FavoritesCoordinator.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 6/2/19.
//

import Foundation
import XCoordinator
import SeatGeekService

enum FavoritesRoute: Route {
    case favorites
    case details(SeatGeekEvent)
}

class FavoritesCoordinator: NavigationCoordinator<FavoritesRoute> {
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
        super.init(initialRoute: .favorites)
    }
    
    override func prepareTransition(for route: FavoritesRoute) -> NavigationTransition {
        switch route {
        case .favorites:
            let favoritesViewController = FavoritesViewController.instantiate()
            favoritesViewController.eventService = self.eventService
            favoritesViewController.imageManager = self.imageManager
            favoritesViewController.favoriteService = self.favoriteService
            favoritesViewController.userId = self.userId
            favoritesViewController.delegate = self
            return .push(favoritesViewController)
            
        case .details(let event):
            let detailsViewController = EventDetailsViewController.instantiate()
            detailsViewController.imageManager = self.imageManager
            detailsViewController.favoriteService = self.favoriteService
            detailsViewController.userId = self.userId
            detailsViewController.event = event
            detailsViewController.favorite = true
            return .push(detailsViewController)
        }
    }
}

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func favorites(_ viewController: FavoritesViewController,
                   didSelectEvent event: SeatGeekEvent) {
        self.anyRouter.trigger(.details(event))
    }
}
