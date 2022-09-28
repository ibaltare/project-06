//
//  Constants.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
    case notAuthenticated
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ApiURL {
    static let LOGIN = "https://dragonball.keepcoding.education/api/auth/login"
    static let HEROS_ALL = "https://dragonball.keepcoding.education/api/heros/all"
    static let HEROS_LOCATIONS = "https://dragonball.keepcoding.education/api/heros/locations"
}

enum KeyChain: String {
    case token = "KCToken"
}
