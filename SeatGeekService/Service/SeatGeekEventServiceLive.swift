//
//  SeatGeekEventServiceLive.swift
//  SeatGeekService
//
//  Created by Maksim Orlovich on 1/2/19.
//

import Foundation
import PromiseKit

public class SeatGeekEventServiceLive: SeatGeekEventService {
    private let clientId: String
    private let baseUrl = URL(string: "https://api.seatgeek.com/2/events")!
    
    public init(clientId: String) {
        self.clientId = clientId
    }
    
    public func details(for eventId: SeatGeekEventId) -> Promise<SeatGeekEvent> {
        let url = self.baseUrl.appendingPathComponent("\(eventId)")
        let params: [String: Any] = ["client_id": self.clientId]
        return
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.queryString).responseData()
            .then { (data, _) -> Promise<SeatGeekEvent> in
                let event = try JSONDecoder.seatGeekDecoder.decode(SeatGeekEvent.self, from: data)
                return Promise.value(event)
            }
    }
    
    public func search(events query: String, perPage: Int = 10, page: Int = 1) -> Promise<SeatGeekEventSearchResult> {
        return self.search(by: .query(query), perPage: perPage, page: page)
    }
    
    public func search(by criteria: SeatGeekEventSearchCriteria,
                       perPage: Int,
                       page: Int) -> Promise<SeatGeekEventSearchResult> {
        var params: [String: Any] = [
            "client_id": self.clientId,
            "per_page": perPage,
            "page": page
        ]
        let emptyMeta = SeatGeekEventSearchResultMeta(geolocation: nil,
                                                      perPage: perPage,
                                                      total: 0,
                                                      page: 1)
        
        switch criteria {
        case .query(let query):
            params["q"] = query
            
        case .ids(let ids):
            guard ids.count > 0 else {
                return Promise.value(SeatGeekEventSearchResult(meta: emptyMeta, events: []))
            }
            params["id"] = ids.map { String(describing: $0) }.joined(separator: ",")
            
        case .location(let latitude, let longitude):
            params["lat"] = latitude
            params["lon"] = longitude
            
        case .venue(let identifier):
            params["venue.id"] = identifier
            
        case .performer(let identifier):
            params["performers.id"] = identifier
        }
        
        return
            Alamofire.request(self.baseUrl, method: .get, parameters: params,
                              encoding: URLEncoding.queryString).responseData()
                .then { (data, pmkresponse) -> Promise<SeatGeekEventSearchResult> in
                    if pmkresponse.response?.statusCode == 200 {
                        // Success - decode returned data
                        let result = try JSONDecoder.seatGeekDecoder.decode(SeatGeekEventSearchResult.self, from: data)
                        return Promise.value(result)
                    } else {
                        // Failure - decode SeatGeek API error
                        let error = try JSONDecoder.seatGeekDecoder.decode(SeatGeekApiError.self, from: data)
                        return Promise(error: error)
                    }
        }
    }
}
