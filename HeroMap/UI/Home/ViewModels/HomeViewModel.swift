//
//  HomeViewModel.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import Foundation
import KeychainSwift

final class HomeViewModel {
    private var keyChain: KeychainSwift
    var onError: ((String)->Void)?
    var onSuccess: (()->Void)?
    
    init(keyChain: KeychainSwift = KeychainSwift(),
         onError: ((String)->Void)? = nil,
         onSucces: (()->Void)? = nil ) {
        self.keyChain = keyChain
        self.onError = onError
        self.onSuccess = onSucces
    }
    
    func signOut(){
        do {
            keyChain.delete(KeyChain.token.rawValue)
            try CoreDataManager.shared.deleteAll()
            try CoreDataManager.shared.deleteAllLocations()
            print("heroes exist.. \(try CoreDataManager.shared.getLocalHeroes().count)")
            print("locations exist.. \(try CoreDataManager.shared.getLocalHeroesLocations().count)")
        } catch {
            self.onError?("Error al leer los datos")
        }
    }
    
    func loadHeroes() {
        do {
            let heroes = try CoreDataManager.shared.getLocalHeroes()
            if heroes.count == 0 {
                print("download")
                downloadHeroes()
            } else {
                print("load core data")
                load(heroes: heroes)
            }
        } catch {
            self.onError?("Error al leer los datos")
        }
    }
    
    
}

private extension HomeViewModel {
    func load(heroes: [EntityHero]){
        print("load table \(heroes.count)")
    }
    
    func downloadHeroes() {
        struct Body: Encodable {
          let name: String
        }
        guard let token = keyChain.get(KeyChain.token.rawValue) else {
            self.onError?("Error al leer los datos")
            return
        }
        NetworkService.shared.networkRequest(url: ApiURL.HEROS_ALL, credentials: token, httpMethod: HTTPMethod.post, httpBody: Body(name: "")) { [weak self] (result: Result<[Hero], NetworkError>) in
            switch result {
                case .success(let success): self?.downloadSuccess(heroes: success)
                case .failure(_): self?.onError?("Error al descargar los datos")
            }
        }
    }
    
    func downloadSuccess(heroes: [Hero]) {
        do {
            try CoreDataManager.shared.save(heroes: heroes)
            struct Body: Encodable {
              let id: String
            }
            guard let token = keyChain.get(KeyChain.token.rawValue) else {
                self.onError?("Error al leer los datos")
                return
            }
            let group = DispatchGroup()
            heroes.forEach { hero in
                group.enter()
                NetworkService.shared.networkRequest(url: ApiURL.HEROS_LOCATIONS, credentials: token, httpMethod: HTTPMethod.post, httpBody: Body(id: hero.id)) { [weak self, hero] (result: Result<[HeroLocation], NetworkError>) in
                    group.leave()
                    switch result {
                    case .success(let success):
                        self?.downloadSuccess(from: success, for: hero.id)
                    case .failure(let failure):
                        self?.onError?(failure.localizedDescription)
                    }
                }
            }
            group.notify(queue: DispatchQueue.global()) {
                self.loadHeroes()
            }
        } catch {
            self.onError?("Error al guardar los datos")
        }
    }
    
    func downloadSuccess(from locations: [HeroLocation], for heroId: String) {
        do {
            try CoreDataManager.shared.save(locations: locations, heroId: heroId)
        } catch {
            self.onError?("Error al guardar los datos")
        }
    }
   
}
