//
//  StreetViewController.swift
//  travel2
//
//  Created by 姜霽庭 on 2023/6/20.
//

import UIKit
import GoogleMaps


class StreetViewController: UIViewController {
    
    weak var detailController:DetailViewController!
    
    var thisAddress:String = ""
//    var thisLatitude:CLLocationDegrees! = nil
//    var thisLongitude:CLLocationDegrees! = nil
    

    @IBOutlet weak var streetView: GMSPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        thisAddress = detailController.addressTxt.text!
        
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(thisAddress) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                print("無法取得緯度與經度")
                return
            }
            
            if let thisPlacemark = placemarks?.first {
                let thisLocation = thisPlacemark.location
//                self.thisLatitude = thisLocation?.coordinate.latitude
//                self.thisLongitude = thisLocation?.coordinate.longitude
                
                let thisLatitude = thisLocation?.coordinate.latitude
                let thisLongitude = thisLocation?.coordinate.longitude
               
                GMSPanoramaService().requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: thisLatitude!, longitude: thisLongitude!)){
                    (pano, error)
                    in
                    if error != nil{
                        print(error!.localizedDescription)
                        print("無法使用街景")
                        return
                    }
                    self.streetView.panorama = pano
                    print("可以使用街景")
                    self.loadView()
            }
        }

     
        }
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView

        thisAddress = detailController.addressTxt.text!

        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(thisAddress) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                print("無法取得緯度與經度")
                return
            }

            if let thisPlacemark = placemarks?.first {
                let thisLocation = thisPlacemark.location
//                self.thisLatitude = thisLocation?.coordinate.latitude
//                self.thisLongitude = thisLocation?.coordinate.longitude

                let thisLatitude = thisLocation?.coordinate.latitude
                let thisLongitude = thisLocation?.coordinate.longitude

                panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: thisLatitude!, longitude: thisLongitude!))
            }
        }

       
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
