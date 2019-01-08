//
//  SeatGeekEventTests.swift
//  SeatGeekServiceTests
//
//  Created by Maksim Orlovich on 1/2/19.
//

import XCTest
import Foundation
@testable import SeatGeekService

class SeatGeekEventTests: XCTestCase {
    func testBasicDecoding() {
        let eventJSON =
        """
        {
            "links": [],
            "event_promotion": null,
            "in_hand": {},
            "themes": [],
            "is_open": false,
            "id": 4614875,
            "stats": {
                "visible_listing_count": 59,
                "dq_bucket_counts": [
                    23,
                    48,
                    57,
                    46,
                    61,
                    56,
                    10,
                    0
                ],
                "average_price": 53,
                "lowest_price_good_deals": 18,
                "median_price": 55,
                "listing_count": 301,
                "lowest_price": 18,
                "highest_price": 100
            },
            "title": "Spring Training: Texas Rangers at Kansas City Royals",
            "announce_date": "2018-11-01T00:00:00",
            "score": 0.559,
            "access_method": null,
            "announcements": {},
            "taxonomies": [
                {
                    "name": "sports",
                    "parent_id": null,
                    "id": 1000000
                },
                {
                    "name": "baseball",
                    "parent_id": 1000000,
                    "id": 1010000
                },
                {
                    "name": "mlb",
                    "parent_id": 1010000,
                    "id": 1010100
                }
            ],
            "type": "mlb",
            "status": "normal",
            "domain_information": [],
            "description": "",
            "datetime_local": "2019-02-23T13:05:00",
            "visible_until_utc": "2019-02-24T00:05:00",
            "time_tbd": false,
            "date_tbd": false,
            "performers": [
                {
                    "image": "https://seatgeek.com/images/performers-landscape/kansas-city-royals-c3370e/5/huge.jpg",
                    "primary": true,
                    "colors": {
                        "all": [
                            "#004687",
                            "#C09A5B"
                        ],
                        "iconic": "#004687",
                        "primary": [
                            "#004687",
                            "#C09A5B"
                        ]
                    },
                    "images": {
                        "huge": "https://seatgeek.com/images/performers-landscape/kansas-city-royals-c3370e/5/huge.jpg"
                    },
                    "has_upcoming_events": true,
                    "id": 5,
                    "stats": {
                        "event_count": 194
                    },
                    "image_license": "https://creativecommons.org/licenses/by/2.0/",
                    "score": 0.71,
                    "location": {
                        "lat": 39.0509,
                        "lon": -94.4809
                    },
                    "taxonomies": [
                        {
                            "name": "sports",
                            "parent_id": null,
                            "id": 1000000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "baseball",
                            "parent_id": 1000000,
                            "id": 1010000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "mlb",
                            "parent_id": 1010000,
                            "id": 1010100,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        }
                    ],
                    "type": "mlb",
                    "num_upcoming_events": 194,
                    "short_name": "Royals",
                    "home_venue_id": 3714,
                    "slug": "kansas-city-royals",
                    "divisions": [
                        {
                            "display_name": "American League",
                            "short_name": null,
                            "division_level": 1,
                            "display_type": "League",
                            "taxonomy_id": 1010100,
                            "slug": null
                        },
                        {
                            "display_name": "American League Central",
                            "short_name": "AL Central",
                            "division_level": 2,
                            "display_type": "Division",
                            "taxonomy_id": 1010100,
                            "slug": "american-league-central"
                        }
                    ],
                    "home_team": true,
                    "name": "Kansas City Royals",
                    "url": "https://seatgeek.com/kansas-city-royals-tickets",
                    "popularity": 0,
                    "image_attribution": "https://www.flickr.com/photos/bryce_edwards/7828767764/in/photolist-cVNtUy-9MgjsL-9MhfQf-c3rLRs-c3sBbq-c3snfJ-c3sd19-c3scxf-c3s4tu-c3ryVs-c3syJj-c3s7KC-c3rYgh-c3rRsN-c3rZ8N-c3rXXC-c3sn1m-c3rBXC-c3rN27-c3rziC-c3rJmE-c3rvn7-c3rWs1-c3szjG-c3rJVd-c3sr2s-c3rWKh-c3sbFJ-c3sFSh-c3sgLd-c3s2UY-c3rG4d-c3ryAj-c3smHQ-c3s7sS-c3rX2Q-c3sCKq-c3rURY-c3rwo5-c3sfhN-c3si93-c3shP9-c3sfSN-c3sipm-c3sg9U-c3seXA-c3seEd-c3shhs-c3sfzb-9LHr46"
                },
                {
                    "image": "https://seatgeek.com/images/performers-landscape/texas-rangers-5ec03c/16/huge.jpg",
                    "colors": {
                        "all": [
                            "#C0111F",
                            "#003278"
                        ],
                        "iconic": "#C0111F",
                        "primary": [
                            "#C0111F",
                            "#003278"
                        ]
                    },
                    "images": {
                        "huge": "https://seatgeek.com/images/performers-landscape/texas-rangers-5ec03c/16/huge.jpg"
                    },
                    "has_upcoming_events": true,
                    "id": 16,
                    "away_team": true,
                    "stats": {
                        "event_count": 198
                    },
                    "image_license": "https://creativecommons.org/licenses/by-sa/2.0/",
                    "score": 0.74,
                    "location": {
                        "lat": 32.7506,
                        "lon": -97.0824
                    },
                    "taxonomies": [
                        {
                            "name": "sports",
                            "parent_id": null,
                            "id": 1000000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "baseball",
                            "parent_id": 1000000,
                            "id": 1010000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "mlb",
                            "parent_id": 1010000,
                            "id": 1010100,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        }
                    ],
                    "type": "mlb",
                    "num_upcoming_events": 198,
                    "short_name": "Rangers",
                    "home_venue_id": 16,
                    "slug": "texas-rangers",
                    "divisions": [
                        {
                            "display_name": "American League",
                            "short_name": null,
                            "division_level": 1,
                            "display_type": "League",
                            "taxonomy_id": 1010100,
                            "slug": null
                        },
                        {
                            "display_name": "American League West",
                            "short_name": "AL West",
                            "division_level": 2,
                            "display_type": "Division",
                            "taxonomy_id": 1010100,
                            "slug": "american-league-west"
                        }
                    ],
                    "name": "Texas Rangers",
                    "url": "https://seatgeek.com/texas-rangers-tickets",
                    "popularity": 0,
                    "image_attribution": "https://www.flickr.com/photos/a4gpa/4591377118/in/photolist-HG1Ar-6G8DGT-6rWf5N-4anGGm-4aiDfH-4anHc1-7ZJ1ss-aqx6nD-aqx3EV-aqzEFA-6G8FCc-aqwYWz-aqzFwq-4anGc7-4aiFUF-4anFM7-aqx2ev-aqzGLy-aqx1Ln-aqzJn7-aqzNg1-6G8EXn-aqx2Xr-8QpUwa-aqx5SK-aqzKS7-aqx53z-aqx1vB-79NEXJ-79JPMZ-aqzHxo-aqx3oH-aqx4wp-aqzGrG-9wjMuE-6LfAWV-6LkckC-6Lnoe1-6LfZbF-6LkiqL-5c1QZw-5c1SmU-5bWBXF-5c1TqQ-5c1VPq-6Lihat-HG1AF-79JQBi-6LhPC6-79JQ8r"
                },
                {
                    "image": null,
                    "colors": null,
                    "images": {},
                    "has_upcoming_events": true,
                    "id": 547768,
                    "stats": {
                        "event_count": 463
                    },
                    "image_license": null,
                    "score": 0.69,
                    "location": null,
                    "taxonomies": [
                        {
                            "name": "sports",
                            "parent_id": null,
                            "id": 1000000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "baseball",
                            "parent_id": 1000000,
                            "id": 1010000,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        },
                        {
                            "name": "mlb",
                            "parent_id": 1010000,
                            "id": 1010100,
                            "document_source": {
                                "source_type": "ELASTIC",
                                "generation_type": "FULL"
                            }
                        }
                    ],
                    "type": "mlb",
                    "num_upcoming_events": 463,
                    "short_name": "Spring Training",
                    "home_venue_id": null,
                    "slug": "spring-training",
                    "divisions": null,
                    "name": "Spring Training",
                    "url": "https://seatgeek.com/spring-training-tickets",
                    "popularity": 0,
                    "image_attribution": null
                }
            ],
            "url": "https://seatgeek.com/spring-training-rangers-at-royals-tickets/2-23-2019-surprise-arizona-surprise-stadium/mlb/4614875",
            "created_at": "2018-11-01T14:34:16",
            "popularity": 0.551,
            "venue": {
                "links": [],
                "metro_code": 753,
                "postal_code": "85374",
                "timezone": "America/Phoenix",
                "has_upcoming_events": true,
                "id": 3930,
                "city": "Surprise",
                "extended_address": "Surprise, AZ 85374",
                "display_location": "Surprise, AZ",
                "state": "AZ",
                "score": 0.5899753,
                "location": {
                    "lat": 33.6269,
                    "lon": -112.377
                },
                "access_method": null,
                "num_upcoming_events": 29,
                "address": "15754 North Bullard",
                "slug": "surprise-stadium",
                "name": "Surprise Stadium",
                "url": "https://seatgeek.com/venues/surprise-stadium/tickets",
                "country": "US",
                "popularity": 0,
                "name_v2": "Surprise Stadium"
            },
            "short_title": "Spring Training: Rangers at Royals",
            "datetime_utc": "2019-02-23T20:05:00",
            "datetime_tbd": false
        }
        """
        
        do {
            let event = try JSONDecoder.seatGeekDecoder.decode(SeatGeekEvent.self, from: Data(eventJSON.utf8))
            XCTAssertEqual(event.shortTitle, "Spring Training: Rangers at Royals")
            XCTAssertEqual(event.type, .mlb)
            XCTAssertEqual(event.title, "Spring Training: Texas Rangers at Kansas City Royals")
            XCTAssertEqual(event.id, 4614875)
            XCTAssertEqual(event.performers.count, 3)
            
            XCTAssertEqual(event.stats.averagePrice, 53)
            XCTAssertEqual(event.stats.lowestPrice, 18)
            XCTAssertEqual(event.stats.highestPrice, 100)
            
            if let texasRangers = event.performers.filter({ $0.id == 16 }).first {
                XCTAssertEqual(texasRangers.name, "Texas Rangers")
                XCTAssertEqual(texasRangers.shortName, "Rangers")
                XCTAssertEqual(texasRangers.homeVenueId, 16)
            } else {
                XCTFail("Texas Rangers not found in performers list")
            }
        } catch {
            XCTFail("Failed: \(error)")
        }
    }
}
