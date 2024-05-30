//
//  FuelStationDataAPITest.swift
//  fuelPricesTests
//
//  Created by Robson Harrison on 29/05/2024.
//

@testable import fuelPrices
import XCTest

final class FuelStationDataAPITest: XCTestCase {
    var api: FuelStationDataAPI!
    var url: URL!

    override func setUp() {
        super.setUp()
        api = FuelStationDataAPI()
        url = URL(string: "https://example.com/fuelsupplierdata")
    }

    override func tearDown() {
        api = nil
        url = nil
        super.tearDown()
    }

    func testRequestFuelSupplierDataSuccess() {
        let expectation = self.expectation(description: "Success")

        let jsonData = """
        {
            "last_updated": "00/00/0000 00:00:00",
            "stations": [
                {
                    "site_id": "testString",
                    "brand": "testString",
                    "address": "testString",
                    "postcode": "testString",
                    "location": {
                        "latitude": 10,
                        "longitude": 10
                    },
                    "prices": {
                        "E5": 10,
                        "E10": 10,
                        "B7": 10,
                        "SDV": 10
                    }
                }
            ]
        }
        """.data(using: .utf8)!

        URLProtocolMock.testURLs = [url: jsonData]
        URLProtocolMock.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.error = nil

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        api = FuelStationDataAPI(session: URLSession(configuration: config))

        api.requestFuelSupplierData(from: url) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response.last_updated, "00/00/0000 00:00:00")
                XCTAssertEqual(response.stations.count, 1)
                XCTAssertEqual(response.stations.first?.site_id, "testString")
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Expected success, got \(error) instead")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    
    class URLProtocolMock: URLProtocol {
        static var testURLs = [URL?: Data]()
        static var response: HTTPURLResponse?
        static var error: Error?

        override class func canInit(with _: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let url = request.url, let data = URLProtocolMock.testURLs[url] {
                if let response = URLProtocolMock.response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                client?.urlProtocol(self, didLoad: data)
            } else if let error = URLProtocolMock.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
