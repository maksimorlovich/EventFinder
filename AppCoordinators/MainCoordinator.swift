//
//  MainCoordinator.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 6/2/19.
//

import Foundation
import XCoordinator
import SeatGeekService

enum MainRoute: Route {
    case search
    case favorites
}

class MainCoordinator: TabBarCoordinator<MainRoute> {
    private let searchRouter: AnyRouter<SearchRoute>
    private let favoritesRouter: AnyRouter<FavoritesRoute>
    
    init(eventService: SeatGeekEventService, favoriteService: SeatGeekFavoriteService,
         imageManager: ImageManager, userId: UserID) {
        
        let searchCoordinator = SearchCoordinator(
            eventService: eventService, favoriteService: favoriteService,
            imageManager: imageManager, userId: userId)
        searchCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoritesCoordinator = FavoritesCoordinator(
            eventService: eventService, favoriteService: favoriteService,
            imageManager: imageManager, userId: userId)
        favoritesCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        self.searchRouter = searchCoordinator.anyRouter
        self.favoritesRouter = favoritesCoordinator.anyRouter
        
        super.init(tabs: [searchRouter, favoritesRouter], select: searchRouter)
    }
    
    override func prepareTransition(for route: MainRoute) -> TabBarTransition {
        switch route {
        case .search:
            return .select(self.searchRouter)
        case .favorites:
            return .select(self.favoritesRouter)
        }
    }
}
