//
//  MapViewController.swift
//  HeroMap
//
//  Created by Nicolas on 28/09/22.
//

import UIKit

final class MapViewController: UIViewController {

    let viewModel = MapViewModel()
    private var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func set(model: Hero) {
        self.hero = model
    }

}
