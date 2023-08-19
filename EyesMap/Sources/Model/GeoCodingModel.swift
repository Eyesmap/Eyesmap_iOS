//
//  GeoCodingModel.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/19.
//

import Foundation



// MARK: - Welcome
struct GeoCodingModel: Codable {
    let status: Status
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
}

// MARK: - Code
struct Code: Codable {
    let id, type, mappingId: String
}

// MARK: - Land
struct Land: Codable {
    let type, number1, number2: String
    let addition0, addition1, addition2, addition3: Addition
    let addition4: Addition
    let coords: Coords
}

// MARK: - Addition
struct Addition: Codable {
    let type, value: String
}

// MARK: - Coords
struct Coords: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let crs: String
    let x, y: Double
}

// MARK: - Region
struct Region: Codable {
    let area0: Area
    let area1: Area1
    let area2, area3, area4: Area
}

// MARK: - Area
struct Area: Codable {
    let name: String
    let coords: Coords
}

// MARK: - Area1
struct Area1: Codable {
    let name: String
    let coords: Coords
    let alias: String
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let name: String
    let message: String
}
