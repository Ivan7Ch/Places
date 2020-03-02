//
//  PlacesViewModel.swift
//  TestDesign
//
//  Created by Ivan Chernetskiy on 02.03.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class PlacesViewModel {
    
    private var places = [PlaceModel]()
    
    var userLocation: CLLocation?
    
    
    func fetchPlaces(completion: @escaping () -> ()) {
        NetworkHelper().fetchPlaces(completion: { fetchedPlaces in
            self.places = fetchedPlaces
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    
    func numberOfItems() -> Int {
        return places.count
    }
    
    
    func description(for index: Int) -> String {
        return places[index].description
    }
    
    
    func title(for index: Int) -> String {
        return places[index].name
    }
    
    
    func distance(for index: Int) -> String {
        
        guard let myLocation = userLocation else { return "" }
        
        let latitude = places[index].coordinates.0
        let longitude = places[index].coordinates.1
        let targetLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        var distance = myLocation.distance(from: targetLocation) / 1000
        distance = round(distance * 10) / 10
        
        return "\(distance) km"
    }
    
    
    func loadImage(for index: Int, completion: @escaping (UIImage) -> ()) {
        NetworkHelper().loadImage(with: places[index].image, completion: { image in
            DispatchQueue.main.async {
                completion(image)
            }
        })
    }
    
    
    func setSelected(for index: Int) {
        places[index].isSelected.toggle()
    }
    
    
    func isSelected(for index: Int) -> Bool {
        return places[index].isSelected
    }
    
    
    func imageName(for index: Int) -> String {
        return places[index].isSelected ? "check_ic_green" : "check_ic_grey"
    }
    
    
    func selectedPlaces() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        let selectedPlaces = places.filter { return $0.isSelected ? true : false }
        
        for i in selectedPlaces {
            let annotation = MKPointAnnotation()
            annotation.title = i.name
            
            let latitude = i.coordinates.0
            let longitude = i.coordinates.1
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(annotation)
        }
        
        return annotations
    }
}
