# EventFinder
EventFinder is an iOS Application for searching sporting events, concerts, etc using Seatgeek API.

- [Requirements](#requirements)
- [Build Instructions](#build-instructions)
- [Features](#features)
- [Third Party Libraries](#third-party-libraries)
- [Screenshots](#screenshots)

## Requirements
- iOS 11.0+
- Xcode 10.1+
- Swift 4.2+

## Build Instructions
- Clone this repo
- Run `pod install` in repo root
- Open EventFinder.xcworkspace, build, and run
- To run on device, open EventFinder project General settings and set Team under Signing section

## Features
- [x] Search Seatgeek events by name, venue, city
- [x] Favorite/unfavorite events with swipe gesture on Search screen
- [x] Details screen shows all relevant details about the event
- [x] Easy to search and buy tickets - app redirects to mobile browser for selected event

## Third Party Libraries
- PromiseKit: abstracting asynchronous operations
- Alamofire: networking
- SQLite.swift: storing favorites for persistence
- XCoordinator: navigation framework based on the Coordinator pattern

## Screenshots
![Search](https://raw.githubusercontent.com/maksimorlovich/EventFinder/master/search.png)
![Details](https://raw.githubusercontent.com/maksimorlovich/EventFinder/master/details.png)
![Favorites](https://raw.githubusercontent.com/maksimorlovich/EventFinder/master/favorites.png)
![No Favorites](https://raw.githubusercontent.com/maksimorlovich/EventFinder/master/nofavorites.png)
