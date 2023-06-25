//
//  TabMapViewController.swift
//  travel2
//
//  Created by 姜霽庭 on 2023/6/20.
//

import UIKit
import GoogleMaps

class DetailMapViewController: UIViewController, GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    weak var detailController:DetailViewController!
    
    weak var collectionTableViewController:CollectionTableViewController!
    
    let geocoder = CLGeocoder()
    
    var mySpotNames:[String] = []
    var myHotelNames:[String] = []
    var myRestaurantNames:[String] = []
    var myCustomNames:[String] = []
    
    var mySpotAddresses:[String] = []
    var myHotelAddresses:[String] = []
    var myRestaurantAddresses:[String] = []
    var myCustomAddresses:[String] = []
    
    var userSavedPlaces:[allData] = [
        allData(
            touristSpots: [TainanPlaces](),
            hotels: [TainanPlaces](),
            restaurants: [TainanPlaces](),
            customPlaces: [TainanPlaces]()
        )
    ]
    
    var thisAddress:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 地圖右上方指南針(地圖方位在正北方時不會出現)
        mapView.settings.compassButton = true
        // 室內樓層選擇器
        mapView.settings.indoorPicker = false
        // 控制縮放手勢是否啟用
        mapView.settings.zoomGestures = true
        
        mapView.delegate = self

        
//        print(detailController.addressTxt.text!)
        
        if let data = UserDefaults.standard.data(forKey: "touristSpots") {
            userSavedPlaces[0].touristSpots = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        
        if let data = UserDefaults.standard.data(forKey: "hotels") {
            userSavedPlaces[0].hotels = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "restaurants") {
            userSavedPlaces[0].restaurants = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        if let data = UserDefaults.standard.data(forKey: "customPlaces") {
            userSavedPlaces[0].customPlaces = try! JSONDecoder().decode([TainanPlaces].self, from: data)
        }
        
        for i in 0 ..< userSavedPlaces[0].touristSpots.count{
            mySpotNames.append(userSavedPlaces[0].touristSpots[i].name)
            mySpotAddresses.append(userSavedPlaces[0].touristSpots[i].address)
//            print(userSavedPlaces[0].touristSpots[i].address)
        }
        
        for i in 0 ..< userSavedPlaces[0].hotels.count{
            myHotelNames.append(userSavedPlaces[0].hotels[i].name)
            myHotelAddresses.append(userSavedPlaces[0].hotels[i].address)
        }
     
        for i in 0 ..< userSavedPlaces[0].restaurants.count{
            myRestaurantNames.append(userSavedPlaces[0].restaurants[i].name)
            myRestaurantAddresses.append(userSavedPlaces[0].restaurants[i].address)
        }
        
        for i in 0 ..< userSavedPlaces[0].customPlaces.count{
            myCustomNames.append(userSavedPlaces[0].customPlaces[i].name)
            myCustomAddresses.append(userSavedPlaces[0].customPlaces[i].address)
        }
        
        print(mySpotAddresses)
        print("PPPPPPPPPPPPPPPPP")
        
        

        thisAddress = detailController.addressTxt.text!
        geocoder.geocodeAddressString(thisAddress) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                print("無法取得緯度與經度")
                return
            }
            
            if let thisPlacemark = placemarks?.first {
                let thisLocation = thisPlacemark.location
                let thisLatitude = thisLocation?.coordinate.latitude
                let thisLongitude = thisLocation?.coordinate.longitude
                print("Latitude: \(thisLatitude ?? 0), Longitude: \(thisLongitude ?? 0)")
                print("AAAAAAAAA")
                self.addThisMarker(thisLocation:thisLocation)
            }
        }
        
        addCollectionMarkers(tag:"0",manyNames: mySpotNames,manyAddresses: mySpotAddresses)
        addCollectionMarkers(tag:"1",manyNames: myHotelNames,manyAddresses: myHotelAddresses)
        addCollectionMarkers(tag:"2",manyNames: myRestaurantNames,manyAddresses: myRestaurantAddresses)
        addCollectionMarkers(tag:"3",manyNames: myCustomNames,manyAddresses: myCustomAddresses)
        
    }
    
    func addThisMarker(thisLocation:CLLocation!){
        
        // 地圖畫面中心點座標(緯精度)及縮放比
        let thisCamera = GMSCameraPosition.camera(withLatitude: thisLocation!.coordinate.latitude, longitude: thisLocation!.coordinate.longitude, zoom: 15.0)
        // 套用此視角
        mapView.camera = thisCamera
        
        // 我的圖標(標記，Marker)
        let myMarker = GMSMarker()
        // 圖標放置地點座標
        myMarker.position = CLLocationCoordinate2D(latitude: thisLocation!.coordinate.latitude, longitude: thisLocation!.coordinate.longitude)
        
        myMarker.map = mapView
        // 圖標的標題及概述
        myMarker.title = detailController.placeNameLbl.text!
        myMarker.snippet = detailController.addressTxt.text!
        
        // 更換圖標的圖示(icon)
//        myMarker.icon = UIImage(named: "XXXX")
        myMarker.icon = GMSMarker.markerImage(with: .cyan)
        
//        addCollectionMarkers(tag:"0",manyLocations: mySpotAddresses)
//        addCollectionMarkers(tag:"1",manyLocations: myHotelAddresses)
//        addCollectionMarkers(tag:"2",manyLocations: myRestaurantAddresses)
//        addCollectionMarkers(tag:"3",manyLocations: myCustomAddresses)
    }
    
    func addCollectionMarkers(tag:String!, manyNames:[String],manyAddresses:[String]){
        switch tag{
        case "0":
            print("SSSSS00000SSSSS")
            for i in 0 ..< manyAddresses.count{
                print(String(i) + "YYYYY")
                print(manyAddresses[i] + "uuuuuuuuuu")
                
                getLocation(locationName: manyNames[i],locationAddress: manyAddresses[i],icon: "icon_spot")
//                    let collectionMarker = GMSMarker()
//                collectionMarker.position = CLLocationCoordinate2D(latitude: location.0! , longitude: location.1!)
//
//                    collectionMarker.map = mapView
//                    // 圖標的標題及概述
//                    collectionMarker.title = manyLocations[i]
//
//                    // 更換圖標的圖示(icon)
//                    collectionMarker.icon = UIImage(named: "icon_spot")
                
               
             
            }
            
        case "1":
            print("SSSSS11111SSSSS")
            for i in 0 ..< manyAddresses.count{
//                if let location = getLocation(locationName: manyLocations[i]){
//                    let collectionMarker = GMSMarker()
//                    collectionMarker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//                    collectionMarker.map = mapView
//                    // 圖標的標題及概述
//                    collectionMarker.title = manyLocations[i]
//
//                    // 更換圖標的圖示(icon)
//                    collectionMarker.icon = UIImage(named: "icon_hotel")
//                }
//
//
                getLocation(locationName: manyNames[i],locationAddress: manyAddresses[i],icon: "icon_hotel")
                
            }
            
        case "2":
            print("SSSSS22222SSSSS")
            for i in 0 ..< manyAddresses.count{
//                if let location = getLocation(locationName: manyLocations[i]){
//                    let collectionMarker = GMSMarker()
//                    collectionMarker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//                    collectionMarker.map = mapView
//                    // 圖標的標題及概述
//                    collectionMarker.title = manyLocations[i]
//
//                    // 更換圖標的圖示(icon)
//                    collectionMarker.icon = UIImage(named: "icon_restaurant")
//                }
//
//
                getLocation(locationName: manyNames[i],locationAddress: manyAddresses[i],icon: "icon_restaurant")
            }
            
        case "3":
            print("SSSSS33333SSSSS")
            for i in 0 ..< manyAddresses.count{
//                if let location = getLocation(locationName: manyLocations[i]){
//                    let collectionMarker = GMSMarker()
//                    collectionMarker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//                    collectionMarker.map = mapView
//                    // 圖標的標題及概述
//                    collectionMarker.title = manyLocations[i]
//
//                    // 更換圖標的圖示(icon)
//                    collectionMarker.icon = UIImage(named: "icon_restaurant")
//                }
//
//
                getLocation(locationName: manyNames[i],locationAddress: manyAddresses[i],icon: "icon_custom")
            }
        default:
            print("XXXXXX")
            break
        }
    }
    
    
    func getLocation(locationName:String, locationAddress:String, icon:String){
        
        if locationAddress == thisAddress{
            return
        }
        print(locationName + "QQQQQQQQQ")
//        var location:CLLocation!
        let myGeocoder = CLGeocoder()
//        var latitude: CLLocationDegrees? = nil
//        var longitude: CLLocationDegrees? = nil
    
        myGeocoder.geocodeAddressString(locationAddress) {
            (placemarks, error)
            in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                print("無法取得緯度與經度!!!!!")
                return
            }
            
            if let placemark = placemarks?.first {
                if let location = placemark.location {
                    // 成功獲取位置資訊
                    print("成功獲取位置資訊")
                    let coordinate = location.coordinate
//                    latitude = coordinate.latitude
//                    longitude = coordinate.longitude

                    
                    
                    let collectionMarker = GMSMarker()
                    collectionMarker.position = CLLocationCoordinate2D(latitude: coordinate.latitude , longitude: coordinate.longitude)
                    
                    collectionMarker.map = self.mapView
                    // 圖標的標題及概述
                    collectionMarker.title = locationName
                    collectionMarker.snippet = locationAddress
                    
                    // 更換圖標的圖示(icon)
                    collectionMarker.icon = UIImage(named: icon)
      
                    
                } else {
                    // 位置資訊為 nil
                    print("無法獲取有效的位置資訊")
                }
            } else {
                // 找不到解析結果
                print("找不到對應的解析結果")
            }

            
        }
        
        print("BBBBBBB")
//        print(location.coordinate.latitude)
//        print(location.coordinate.longitude)
//        return (latitude, longitude)
    }
    
    
    
    
    
    // 點擊InfoWindow
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        performSegue(withIdentifier: "showPano", sender: nil)
        
        print(marker.title!)
      
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
