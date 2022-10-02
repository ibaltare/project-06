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
    var onSuccessLoad: (()->Void)?
    private(set) var content: [Hero] = []
    private var networkService: NetworkProtocol
    
    init(keyChain: KeychainSwift = KeychainSwift(),
         onError: ((String)->Void)? = nil,
         onSuccessLoaded: (()->Void)? = nil,
         networkService: NetworkProtocol = NetworkService.shared) {
        self.keyChain = keyChain
        self.onError = onError
        self.onSuccessLoad = onSuccessLoaded
        self.networkService = networkService
    }
    
    func signOut(){
        do {
            keyChain.delete(KeyChain.token.rawValue)
            try CoreDataManager.shared.deleteAll()
            //print("heroes exist.. \(try CoreDataManager.shared.getLocalHeroes().count)")
            //print("locations exist.. \(try CoreDataManager.shared.getLocalHeroesLocations().count)")
        } catch {
            self.onError?("Error al leer los datos")
        }
    }
    
    func loadHeroes() {
        do {
            let heroes = try CoreDataManager.shared.getLocalHeroes()
            if heroes.count == 0 {
                downloadHeroes()
            } else {
                load(heroes: heroes)
            }
        } catch {
            self.onError?("Error al leer los datos")
        }
    }
    
    func searchHero(by name: String) {
        do {
            var eHeroes: [EntityHero] = []
            if name.isEmpty {
                eHeroes = try CoreDataManager.shared.getLocalHeroes()
            }else {
                eHeroes = try CoreDataManager.shared.fetchHeroes(by: "name CONTAINS[c] %@", with: name)
            }
            self.load(heroes: eHeroes)
        } catch { self.onError?("Error al leer los datos") }
    }
}

private extension HomeViewModel {
    func load(heroes: [EntityHero]){
        self.content = heroes.map { $0.hero }.sorted { $0.name < $1.name }
        self.onSuccessLoad?()
    }
    
    func downloadHeroes() {
        struct Body: Encodable {
          let name: String
        }
        guard let token = keyChain.get(KeyChain.token.rawValue) else {
            self.onError?("Error al leer los datos")
            return
        }
        networkService.networkRequest(url: ApiURL.HEROS_ALL, credentials: token, httpMethod: HTTPMethod.post, httpBody: Body(name: "")) { [weak self] (result: Result<[Hero], NetworkError>) in
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
            let eHeroes = try CoreDataManager.shared.getLocalHeroes()
            let group = DispatchGroup()
            eHeroes.forEach { hero in
                group.enter()
                networkService.networkRequest(url: ApiURL.HEROS_LOCATIONS, credentials: token, httpMethod: HTTPMethod.post, httpBody: Body(id: hero.id)) { [weak self, hero] (result: Result<[HeroLocation], NetworkError>) in
                    group.leave()
                    switch result {
                    case .success(let success):
                        self?.downloadSuccess(from: success, for: hero)
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
    
    func downloadSuccess(from locations: [HeroLocation], for eHero: EntityHero) {
        do {
            try CoreDataManager.shared.save(locations: locations, eHero: eHero)
        } catch {
            self.onError?("Error al guardar los datos")
        }
    }
   
}
