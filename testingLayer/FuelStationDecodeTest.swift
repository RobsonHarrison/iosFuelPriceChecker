// FuelStationDecodeTest.swift
// fuelPricesTests
//
// Created by Robson Harrison on 24/05/2024.

@testable import fuelPrices
import XCTest

final class FuelStationDecodeTest: XCTestCase {
    let validSupplierResponse = """
    {
        "last_updated": "yyyy-mm-dd",
        "stations": [
            {
                "site_id": "xxxx",
                "brand": "Brand X",
                "address": "xxx Street",
                "postcode": "xxxxx",
                "location": {
                    "latitude": 10.1,
                    "longitude": -10.1
                },
                "prices": {
                    "E10": 99.99,
                    "B7": 99.99,
                    "E5": 99.99,
                    "SDV": 99.99
                }
            }
        ]
    }
    """

    let supplierResponseOptionals = """
    {
        "last_updated": "yyyy-mm-dd",
        "stations": [
            {
                "site_id": null,
                "brand": null,
                "address": "xxx Street",
                "postcode": "xxxxx",
                "location": {
                    "latitude": 10.1,
                    "longitude": -10.1
                },
                "prices": {
                    "E10": 99.99,
                    "B7": 99.99,
                    "E5": 99.99,
                    "SDV": 99.99
                }
            }
        ]
    }
    """

    // Test decoding of FuelSupplierResponse with all data available
    func testFuelSupplierResponseDecoding() {
        let jsonData = validSupplierResponse.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(FuelSupplierResponse.self, from: jsonData)
            XCTAssertEqual(response.last_updated, "yyyy-mm-dd")
            XCTAssertEqual(response.stations.count, 1)

            let station = response.stations[0]
            XCTAssertEqual(station.site_id, "xxxx")
            XCTAssertEqual(station.brand, "Brand X")
            XCTAssertEqual(station.address, "xxx Street")
            XCTAssertEqual(station.postcode, "xxxxx")
            XCTAssertEqual(station.location.latitude, 10.1)
            XCTAssertEqual(station.location.longitude, -10.1)
            XCTAssertEqual(station.prices.E10, 99.99)
            XCTAssertEqual(station.prices.B7, 99.99)
            XCTAssertEqual(station.prices.E5, 99.99)
            XCTAssertEqual(station.prices.SDV, 99.99)
        } catch {
            XCTFail("Decoding FuelSupplierResponse failed with error: \(error)")
        }
    }

    // Tests decoding of FuelSupplierResponse with missing data
    func testInvalidJSONDecoding() {
        let jsonData = supplierResponseOptionals.data(using: .utf8)!
        let decoder = JSONDecoder()

        XCTAssertThrowsError(try decoder.decode(FuelSupplierResponse.self, from: jsonData)) { error in
            print("Decoding failed as expected with error: \(error)")
        }
    }

    // Test decoding of FuelSupplierResponseDecoding
    func testFuelSupplierResponseDecodingOptionals() {
        let jsonData = supplierResponseOptionals.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(FuelSupplierResponseDeocding.self, from: jsonData)
            XCTAssertEqual(response.last_updated, "yyyy-mm-dd")
            XCTAssertEqual(response.stations.count, 1)

            let station = response.stations[0]
            XCTAssertNil(station.site_id)
            XCTAssertNil(station.brand)
            XCTAssertEqual(station.address, "xxx Street")
            XCTAssertEqual(station.postcode, "xxxxx")
            XCTAssertEqual(station.location?.latitude, 10.1)
            XCTAssertEqual(station.location?.longitude, -10.1)
            XCTAssertEqual(station.prices?.E10, 99.99)
            XCTAssertEqual(station.prices?.B7, 99.99)
            XCTAssertEqual(station.prices?.E5, 99.99)
            XCTAssertEqual(station.prices?.SDV, 99.99)
        } catch {
            XCTFail("Decoding FuelSupplierResponse failed with error: \(error)")
        }
    }
}
