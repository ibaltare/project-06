//
//  MapViewModel.swift
//  HeroMap
//
//  Created by Nicolas on 28/09/22.
//

import Foundation

final class MapViewModel {
    var onError: ((String)->Void)?
    var onSuccess: (()->Void)?
    
    init( onError: ((String)->Void)? = nil,
          onSucces: (()->Void)? = nil){
        self.onError = onError
        self.onSuccess = onSucces
    }
    
    func viewDidLoad() {
        
    }
}
