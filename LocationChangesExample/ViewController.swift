//
//  ViewController.swift
//  LocationChangesExample
//
//  Created by Manjula Jonnalagadda on 10/7/14.
//  Copyright (c) 2014 Manjula Jonnalagadda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UISearchBarDelegate {
    
    let locationManager:CLLocationManager=CLLocationManager()
    var mapView:MKMapView?
    let geoCoder:CLGeocoder=CLGeocoder()
    
    override func loadView() {
        super.loadView();
        
        
//        let locationManager:CLLocationManager=CLLocationManager()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        view.backgroundColor=UIColor(white: 0.99, alpha: 1.0)
        mapView=MKMapView()
        mapView!.showsUserLocation=true
        mapView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(mapView!)
    
        
        let searchBar:UISearchBar=UISearchBar()
        searchBar.delegate=self
        searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBar.showsCancelButton=true
        view.addSubview(searchBar)
        
        let hCons:NSArray=NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options:  NSLayoutFormatOptions(0), metrics: nil, views:["mapView":mapView!])
        let hSBCons:NSArray=NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options:  NSLayoutFormatOptions(0), metrics: nil, views:["searchBar":searchBar])
        let vCons:NSArray=NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[searchBar][mapView]|", options:  NSLayoutFormatOptions(0), metrics: nil, views:["mapView":mapView!,"searchBar":searchBar])
        
        view.addConstraints(hCons);
        view.addConstraints(hSBCons)
        view.addConstraints(vCons);
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //LocationDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location:CLLocation=locations.last as CLLocation
        
        manager.stopUpdatingLocation()
        
        mapView!.region=MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.2, 0.2))
        
        
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        geoCoder .geocodeAddressString(searchBar.text, completionHandler: {[unowned self] (placeMarks, error) -> Void in []
            if(error==nil){
                let placeMark:CLPlacemark=placeMarks[0] as CLPlacemark
                let annotation:MKPointAnnotation=MKPointAnnotation()
                annotation.coordinate=placeMark.location.coordinate
                annotation.title=searchBar.text
                self.mapView!.addAnnotation(annotation)
                self.mapView!.region=MKCoordinateRegionMake(placeMark.location.coordinate, MKCoordinateSpanMake(0.2, 0.2))
            }
        })
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    

}

