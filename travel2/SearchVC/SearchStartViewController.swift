//
//  SearchStartViewController.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/13.
//

import UIKit

class SearchStartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtDistrict: UITextField!
    @IBOutlet weak var txtKeyWord: UITextField!

    // 滾輪資料
    var pkvDistrict: UIPickerView!
    let region = ["台南"]
    let districtsTainan = [
        "新營","鹽水","白河","柳營","後壁","東山","麻豆","下營","六甲","官田","大內","佳里","學甲","西港","七股","將軍","北門","新化","新市","善化","安定","山上","玉井","楠西","南化","左鎮","仁德","歸仁","關廟","龍崎","永康","東區","南區","中西區","北區","安南","安平"
    ]
    // Data
    var allDataTainan:[allData] = [allData(touristSpots: [TainanPlaces](), hotels: [TainanPlaces](), restaurants: [TainanPlaces](), customPlaces: [TainanPlaces]())]
    
    //MARK: - Target Action
    @IBAction func viewClick(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        // 按下 Return 或 Done 時發生
        // 只要拉好事件，不需執行任何程式、不用引入代理就可收起鍵盤
    }
    
    @IBAction func districtSearch(_ sender: UIButton) {
        if txtDistrict.text != "" {
            let controller = storyboard?.instantiateViewController(withIdentifier: "SearchResultTableViewController") as! SearchResultTableViewController

            controller.userSearchResults[0].touristSpots = allDataTainan[0].touristSpots.filter { $0.district!.contains(txtDistrict.text!)
            }
            controller.userSearchResults[0].hotels = allDataTainan[0].hotels.filter { $0.address.contains(txtDistrict.text!)
            }
            controller.userSearchResults[0].restaurants = allDataTainan[0].restaurants.filter { $0.district!.contains(txtDistrict.text!)
            }

            show(controller, sender: nil)
        }
    }
    

    @IBAction func keyWordSearchButton(_ sender: UIButton) {
        if txtKeyWord.text != "" {
            let controller = storyboard?.instantiateViewController(withIdentifier: "SearchResultTableViewController") as! SearchResultTableViewController
            
            let touristSpotsRes = allDataTainan[0].touristSpots.filter { $0.name.contains(txtKeyWord.text!) || $0.address.contains(txtKeyWord.text!) }
            let hotelsRes = allDataTainan[0].hotels.filter { $0.name.contains(txtKeyWord.text!) || $0.address.contains(txtKeyWord.text!) }
            let restaurantsRes = allDataTainan[0].restaurants.filter { $0.name.contains(txtKeyWord.text!) || $0.address.contains(txtKeyWord.text!) }
            
            if touristSpotsRes.count + hotelsRes.count + restaurantsRes.count == 0 {
                let alert = UIAlertController(title: "查無結果", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            } else {
                controller.userSearchResults[0].touristSpots = touristSpotsRes
                controller.userSearchResults[0].hotels = hotelsRes
                controller.userSearchResults[0].restaurants = restaurantsRes
                
                show(controller, sender: nil)
            } 
        }
    }
    
    
    @IBAction func viewAllButton(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchResultTableViewController") as! SearchResultTableViewController
        controller.userSearchResults = allDataTainan
        show(controller, sender: nil)
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        if sender.tag == 0 {
            txtDistrict.text = ""
        } else {
            txtKeyWord.text = ""
        }
    }
    
    //MARK: - 自訂函式
    func fetchTouristSpots(urlRawJson: String) {
        if let url = URL(string: urlRawJson) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodeData = try decoder.decode([TainanPlaces].self, from: data)
                        DispatchQueue.main.async { [self] in
                            allDataTainan[0].touristSpots = decodeData
                            print("tourist spots:",allDataTainan[0].touristSpots.count)
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }

    func fetchHotels(urlRawJson: String) {
        if let url = URL(string: urlRawJson) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodeData = try decoder.decode([TainanPlaces].self, from: data)
                        DispatchQueue.main.async { [self] in
                            allDataTainan[0].hotels = decodeData
                            print("hotels:",allDataTainan[0].hotels.count)
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func fetchRestaurants(urlRawJson: String) {
        if let url = URL(string: urlRawJson) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    let decoder = JSONDecoder()
                    do {
                        let decodeData = try decoder.decode([TainanPlaces].self, from: data)
                        DispatchQueue.main.async { [self] in
                            allDataTainan[0].restaurants = decodeData
                            print("restaurants:",allDataTainan[0].restaurants.count)
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 87/255, green: 111/255, blue: 114/255, alpha: 1)
        navigationItem.title = "搜尋"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        
        fetchTouristSpots(urlRawJson: "https://raw.githubusercontent.com/shang-jungwu/json/main/tainan")
        fetchHotels(urlRawJson: "https://raw.githubusercontent.com/shang-jungwu/json/main/tainan_hotels")
        fetchRestaurants(urlRawJson: "https://raw.githubusercontent.com/shang-jungwu/json/main/tainan_dining")
        
        txtDistrict.delegate = self
        
        pkvDistrict = UIPickerView()
        pkvDistrict.delegate = self
        pkvDistrict.dataSource = self
        txtDistrict.inputView = pkvDistrict
        
        let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.default
                toolBar.isTranslucent = true
                toolBar.tintColor = .systemBlue
                toolBar.sizeToFit()
        
        //加入 toolbar 按鈕跟中間的空白
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(submit))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        //設定 toolBar 可以使用
        toolBar.isUserInteractionEnabled = true
        txtDistrict.inputAccessoryView = toolBar
    }
    
    @objc func submit() {
        let selectedRow = pkvDistrict.selectedRow(inComponent: 1)
        txtDistrict.text = districtsTainan[selectedRow]
        
        self.txtDistrict.resignFirstResponder()
    }

    @objc func cancel() {
        self.txtDistrict.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

} // class ending

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SearchStartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return region.count
        case 1:
            return districtsTainan.count
        default:
            return 0
        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return region[0]
        case 1:
            return districtsTainan[row]
        default:
            return ""
        }
    }


}

