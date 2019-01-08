//
//  SearchFlowManager.swift
//  EventFinder
//
//  Created by Maksim Orlovich on 1/6/19.
//

import Foundation
import UIKit
import SeatGeekService
import PromiseKit

class SearchFlowManager: FlowManager {
    private(set) lazy var mainViewController: UIViewController = UINavigationController(rootViewController: self.searchViewController)
    
    private lazy var searchViewController = { () -> SearchEventsViewController in
        let viewController = SearchEventsViewController.instantiate()
        viewController.loadViewIfNeeded()
        viewController.eventService = self.eventService
        viewController.imageManager = self.imageManager
        viewController.favoriteService = self.favoriteService
        viewController.userId = self.userId
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var eventDetailsViewController = { () -> EventDetailsViewController in
        let viewController = EventDetailsViewController.instantiate()
        viewController.loadViewIfNeeded()
        viewController.imageManager = self.imageManager
        viewController.favoriteService = self.favoriteService
        viewController.userId = self.userId
        return viewController
    }()
    
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
    }
}

extension SearchFlowManager: SearchEventsViewControllerDelegate {
    func searchEvents(_ viewController: SearchEventsViewController,
                      didSelectEvent event: SeatGeekEvent,
                      favorite: Bool) {
        let navigationController = self.mainViewController as! UINavigationController
        self.eventDetailsViewController.configure(with: event, favorite: favorite)
        navigationController.pushViewController(self.eventDetailsViewController, animated: true)
    }
}
