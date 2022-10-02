//
//  NetworkServiceMock.swift
//  HeroMapTests
//
//  Created by Nicolas on 01/10/22.
//

import Foundation
@testable import HeroMap

final class NetworkServiceMock: NetworkProtocol {
    var simpleResult: Result<String, NetworkError>?
    var heroData: Data?
    var locationData: Data?
    var customError: NetworkError?
    
    init(simpleResult: Result<String, NetworkError>? = nil, heroData: Data? = nil, locationData: Data? = nil, customError: NetworkError? = nil) {
        self.simpleResult = simpleResult
        self.heroData = heroData
        self.locationData = locationData
        self.customError = customError
    }
    
    func networkRequest(url: String, credentials: String, httpMethod: HeroMap.HTTPMethod, completion: @escaping (Result<String, HeroMap.NetworkError>) -> Void) {
        completion(simpleResult ?? .failure(.other))
    }
    
    func networkRequest<R:Decodable, B: Encodable>(url: String, credentials: String, httpMethod: HeroMap.HTTPMethod, httpBody: B?, completion: @escaping (Result<R, HeroMap.NetworkError>) -> Void) {
        var data: Data?
        if let error = customError {
            completion(.failure(error))
            return
        }
        
        if url == ApiURL.HEROS_ALL {
            data = heroData
        } else if url == ApiURL.HEROS_LOCATIONS {
            data = locationData
        }
        
        guard let data = data, let response = try? JSONDecoder().decode(R.self, from: data) else {
            completion(.failure(.decoding))
            return
        }
        completion(.success(response))
    }
}

extension NetworkServiceMock {
    static var locationData: Data {
        """
[
    {
        "id": "6982D037-A9E0-4EE1-8BFA-FF17874D6DD5",
        "dateShow": "2022-02-20T00:00:00Z",
        "latitud": "40.437149142667955",
        "longitud": "-3.700824111001255",
        "hero": {
            "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
        }
    }
]
""".data(using: .utf8)!
    }
    
    static var heroData: Data {
        """
[
    {
        "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
        "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
        "description": "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
        "favorite": false,
        "name": "Goku"
    }
]
""".data(using: .utf8)!
    }
    
}
