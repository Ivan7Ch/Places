//
//  ListPlaces.swift
//  TestDesign
//
//  Created by Ivan Chernetskiy on 01.03.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class PlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
}


class ListPlacesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = PlacesViewModel()
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchPlaces {
            self.tableView.reloadData()
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapViewController = segue.destination as? MapViewController {
            mapViewController.annotations = viewModel.selectedPlaces()
        }
    }
}


extension ListPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceTableViewCell
        
        let index = indexPath.row
        
        cell.nameLabel.text = viewModel.title(for: index)
        cell.descriptionLabel.text = viewModel.description(for: index)
        cell.distanceLabel.text = viewModel.distance(for: indexPath.row)
        viewModel.loadImage(for: index, completion: { image in
            cell.thumbnailView.image = image
        })
        
        let imageName = viewModel.imageName(for: index)
        cell.checkMark.image = UIImage(named: imageName)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelected(for: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
        let imageName = viewModel.isSelected(for: indexPath.row) ? "check_ic_green" : "check_ic_grey"
        cell.checkMark.image = UIImage(named: imageName)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension ListPlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        viewModel.userLocation = location
        tableView.reloadData()
        locationManager.stopUpdatingLocation()
    }
}
