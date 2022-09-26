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
        keyChain.delete(KeyChain.token.rawValue)
    }
}
