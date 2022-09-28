//
//  LoginViewModel.swift
//  HeroMap
//
//  Created by Nicolas on 25/09/22.
//

import Foundation
import KeychainSwift

final class LoginViewModel {
    
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
    
    func login(with user:String, password: String) {
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            onError?("Error al crear credenciales")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        NetworkService.shared.networkRequest(url: ApiURL.LOGIN, credentials: base64LoginString, httpMethod: HTTPMethod.post) {[weak self] (result: Result<String, NetworkError>) in
            switch result {
            case .success(let success): self?.loginSuccess(with: success)
            case .failure(_): self?.onError?("Error de Autenticación")
            }
        }
    }
    
    private func loginSuccess(with token: String) {
        self.keyChain.set(token, forKey: KeyChain.token.rawValue)
        self.onSuccess?()
    }
}
