//
//  MapViewController.swift
//  HeroMap
//
//  Created by Nicolas on 28/09/22.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    @IBOutlet weak var contentPhoto: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    let viewModel = MapViewModel()
    private var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = hero?.name
        viewModel.onSuccess = onSucces
        viewModel.onError = onError(message:)
        viewModel.loadLocations(for: hero)
        if let image = hero?.photo {
            update(image: image)
        }
        showAnimation()
    }

    func set(model: Hero) {
        self.hero = model
    }
    
    private func update(image: URL){
        photo.layer.cornerRadius = (photo.bounds.height)/2
        contentPhoto.layer.cornerRadius = (contentPhoto.bounds.height)/2
        photo.setImage(url: image)
    }
    
    private func showAnimation() {
        contentPhoto.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0) {
            self.contentPhoto.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

}

extension MapViewController {
    func onSucces() {
        viewModel.places.forEach { place in
            let coordinateRegion = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.addAnnotation(place)
        }
    }
    
    func onError(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "", message: message)
        }
    }
}
