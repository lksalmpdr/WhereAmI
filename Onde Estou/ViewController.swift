//
//  ViewController.swift
//  Onde Estou
//
//  Created by Pedro Lucas de Almeida on 25/10/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager  = CLLocationManager()

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        let speed = userLocation!.speed.binade
        let longitude = userLocation!.coordinate.longitude.binade
        let latitude = userLocation!.coordinate.latitude.binade

        longitudeLabel!.text = String(longitude)
        latitudeLabel!.text = String(latitude)
        speedLabel!.text = String(speed)
        
        CLGeocoder().reverseGeocodeLocation(userLocation!) { (locationDetails, error) in
            if error == nil{
                let localData = locationDetails?.first
                var thoroughfare = ""
                var subThoroughfare = ""
                var locality = ""
                var subLocality = ""
                var postalCode = ""
                var country = ""
                var administrativeArea = ""
                var subAdministrativeArea = ""
                
                if localData?.thoroughfare != nil
                {
                    thoroughfare = (localData?.thoroughfare)!
                }
                if localData?.subThoroughfare != nil
                {
                    subThoroughfare = (localData?.subThoroughfare)!
                }
                if localData?.locality != nil
                {
                    locality = (localData?.locality)!
                }
                if localData?.subLocality != nil
                {
                    subLocality = (localData?.subLocality)!
                }
                if localData?.postalCode != nil
                {
                    postalCode = (localData?.postalCode)!
                }
                if localData?.country != nil
                {
                    country = (localData?.country)!
                }
                if localData?.administrativeArea != nil
                {
                    administrativeArea = (localData?.administrativeArea)!
                }
                if localData?.subAdministrativeArea != nil
                {
                    subAdministrativeArea = (localData?.subAdministrativeArea)!
                }
                
            }else{
                print(error)
            }
        }
        
        let deltaLat:CLLocationDegrees = 0.01
        let deltaLon:CLLocationDegrees = 0.01
        
        let localization: CLLocationCoordinate2D = CLLocationCoordinate2DMake((userLocation?.coordinate.latitude)!, (userLocation?.coordinate.longitude)!)
        let exibitArea = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: localization, span: exibitArea)
        
        mapa.setRegion(region, animated: true)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .authorizedWhenInUse{
            let alertController = UIAlertController(title: "Permissão de Localização", message: "Precisamos da sua localização", preferredStyle: .alert)
            
            let configurationsAction = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (configurationsAction) in
                if let configs = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configs as URL)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertController.addAction(configurationsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }


}

