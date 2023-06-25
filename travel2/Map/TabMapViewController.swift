//
//  TabMapViewController.swift
//  travel2
//
//  Created by 姜霽庭 on 2023/6/20.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TabMapViewController:  UIViewController, GMSMapViewDelegate,  CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {

    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    
    @IBAction func searchLocation(_ sender: UIButton) {
        goToSearch()
    }
    
    @IBOutlet weak var labelResultName: UILabel!
    
    
    // 使用者目前所在位置
    var myLocationMgr: CLLocationManager!
    // 搜尋之地點圖標
    var searchMarker: GMSMarker!

    var customName:String?
    var customAddress:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nav
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 123/255, green: 104/255, blue: 238/255, alpha: 1)

        // Nav title
        let titleLabel = UILabel()
        titleLabel.text = "景點搜尋"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        
        
        // 地圖右上方指南針(地圖方位在正北方時不會出現)
        mapView.settings.compassButton = true
        // 顯示使用者所在定位的小藍原點
        mapView.settings.myLocationButton = true
        // 室內樓層選擇器
        mapView.settings.indoorPicker = false
        // 控制縮放手勢是否啟用
        mapView.settings.zoomGestures = true
        // 是否顯示使用者所在定位
        mapView.isMyLocationEnabled = true
        
        
        

//        // 地圖畫面中心點座標(緯精度)及縮放比
//        let myCamera = GMSCameraPosition.camera(withLatitude: 24.91939, longitude: 121.183671, zoom: 15.0)
//        // 套用此視角
//        mapView.camera = myCamera

//        mapView.mapType = .satellite

//        // 我的圖標(標記，Marker)
//        let myMarker = GMSMarker()
//        // 圖標放置地點座標
//        myMarker.position = CLLocationCoordinate2D(latitude: 24.91939, longitude: 121.183671)
//
//        myMarker.map = mapView
//        // 圖標的標題及概述
//        myMarker.title = "我在這"
//        myMarker.snippet = "I'm Here!"
//
//        // 更換圖標的圖示(icon)
////        myMarker.icon = UIImage(named: "dome_1")
//        myMarker.icon = GMSMarker.markerImage(with: .cyan)
        
        // 設定ViewController類別實體是mapView的delegate屬性
        mapView.delegate = self
        
        // ===============以下使用者位置相關===============
        // 獲取使用者的位置資訊
        myLocationMgr = CLLocationManager()
        myLocationMgr.delegate = self
        
        // 取得使用者權限(request user authorize)
        myLocationMgr.requestWhenInUseAuthorization()
        myLocationMgr.startUpdatingLocation()
        
  
        // 每移動10公尺就更新資料(update data after move ten meters)
        myLocationMgr.distanceFilter = kCLLocationAccuracyNearestTenMeters
        // 設定定位的精確度
        myLocationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        /*
         kCLLocationAccuracyBestForNavigation：精確度最高，適用於導航的定位。
         kCLLocationAccuracyBest：精確度高。
         kCLLocationAccuracyNearestTenMeters：精確度 10 公尺以內。
         kCLLocationAccuracyHundredMeters：精確度 100 公尺以內。
         kCLLocationAccuracyKilometer：精確度 1 公里以內。
         kCLLocationAccuracyThreeKilometers：精確度 3 公里以內。
         */
        
        // ===============以上使用者位置相關===============

        
        
        
        
        
    }
    
    // 開啟搜尋視窗
    func goToSearch(){
        txtSearch.resignFirstResponder()
        let searchController = GMSAutocompleteViewController()
        searchController.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }

    // 點擊InfoWindow
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        performSegue(withIdentifier: "showPano", sender: nil)
//

//        let detailMapVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMapViewController") as! DetailMapViewController
//        
//        detailMapVC.detailController = self
//
//        self.show(detailMapVC, sender: nil)
        
        presentCustomScheduleSheet()
        
        
        
    }
    
    func presentCustomScheduleSheet() {
        let customScheduleController = storyboard?.instantiateViewController(withIdentifier: "CustomSheetViewController") as! CustomSheetViewController
        customScheduleController.tabMapVC = self
        let navigationController = UINavigationController(rootViewController: customScheduleController)
        let sheetPresentationController = navigationController.sheetPresentationController
        sheetPresentationController?.detents = [.medium()]
        sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.preferredCornerRadius = 25
        self.present(navigationController, animated: true)
        
      
//        customScheduleController.placeNameTxt.text = customName
//        customScheduleController.placeAddressTxt.text = customAddress
        
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
//
//
//
////      guard let placeMarker = marker as? PlaceMarker else {
////        return nil
////      }
//
//
//
//
//
//      guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
//        return nil
//      }
//
//      infoView.nameLabel.text = placeMarker.place.name
//      infoView.addressLabel.text = placeMarker.place.address
//
//      return infoView
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    // 利用CLLocationManagerDelegate更新定位地點
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // 使用者目前所在位置
//        let currentLocation: CLLocation = locations[0] as CLLocation
//        print(currentLocation)
//        if let location = locations.first {
//            mapView.animate(toLocation: location.coordinate)
//            mapView.animate(toZoom: 18)
//            myLocationMgr.stopUpdatingLocation()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          if let location = locations.last {
              // 使用者的目前位置
              let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
              
              // 在地圖上設置使用者位置標記
//              let marker = GMSMarker(position: userLocation)
//              marker.map = mapView
              
              // 移動地圖視圖到使用者位置
              mapView.camera = GMSCameraPosition.camera(withTarget: userLocation, zoom: 15)
              
          }
      }
      
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("Location manager error: \(error.localizedDescription)")
      }

    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//           print("locations = \(locValue.latitude) \(locValue.longitude)")
//        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
//    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
         print("Place name: \(String(describing: place.name))")
       dismiss(animated: true, completion: nil)
       
       mapView.clear()
//       self.txtSearch.text = place.name! + "\n按此重新輸入"

        labelResultName.text = "您搜尋的是：" + place.name!
       
       /*
       let placeGmap = GoogleMapObjects()
       placeGmap.lat = place.coordinate.latitude
       placeGmap.long = place.coordinate.longitude
       placeGmap.address = place.name*/
       
       //self.delegate?.getThePlaceAddress(vc: self, place: placeGmap, tag: self.FieldTag)
   
       let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
       
       searchMarker = GMSMarker()
        
       searchMarker.position =  cord2D
       searchMarker.title = "按此加入收藏"
       searchMarker.snippet = place.formattedAddress
        
       customName = place.name
       customAddress = place.formattedAddress
        
        
       
       let markerImage = UIImage(named: "icon_google_map")!
       let markerView = UIImageView(image: markerImage)
       searchMarker.iconView = markerView
       searchMarker.map = self.mapView
       
       self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
}


