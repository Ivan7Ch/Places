//
//  ViewController.swift
//  TestDesign
//
//  Created by Ivan Chernetskiy on 29.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addBlurEffect()
        setupMap()
    }
    
    
    func setupMap() {
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.delegate = self
        
        
        for i in annotations {
            map.addAnnotation(i)
        }
        map.showAnnotations(annotations, animated: true)
    }
    
    
    @IBAction func hideViewController() {
        navigationController?.popViewController(animated: true)
    }
}


extension UIButton
{
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        
        annotationView.image = #imageLiteral(resourceName: "marker")
        annotationView.canShowCallout = true
        
        return annotationView
    }
}
