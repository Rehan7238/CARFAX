//
//  ViewController.swift
//  Carfax_Assignment
//
//  Created by Rehan Chaudhry on 7/14/21.
//

import UIKit
import Alamofire

struct Car {
    var formattedData: [String: Any?]
    
    init(formattedData: [String: Any?]) {
        self.formattedData = formattedData
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var carsTableView: UITableView!
    
    var carData: [Car] = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carsTableView.delegate = self
        carsTableView.dataSource = self
        
        loadCarData()
    }
    
    func loadCarData() {
        AF.request("https://carfax-for-consumers.firebaseio.com/assignment.json").responseJSON { response in
            do {
                self.carData = []
                
                let responseResult = try response.result.get() as? [String: Any]
                let carListings = responseResult?["listings"] as! [Any]
                
                for carListing in carListings {
                    let carData = carListing as? [String: Any]
                    var formattedData = [String: Any?]()
                    
                    formattedData.updateValue(carData?["currentPrice"], forKey: "price")
                    formattedData.updateValue(carData?["mileage"], forKey: "mileage")
                    formattedData.updateValue(carData?["year"], forKey: "year")
                    formattedData.updateValue(carData?["make"], forKey: "make")
                    formattedData.updateValue(carData?["model"], forKey: "model")
                    formattedData.updateValue(carData?["trim"], forKey: "trim")
                    formattedData.updateValue(carData?["dealer"], forKey: "dealer")
                    formattedData.updateValue(carData?["images"], forKey: "images")

                    self.carData.append(Car(formattedData: formattedData))
                }
            } catch {
            }

            self.carsTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell")! as? CarsTableViewCell {
            cell.setup(car: carData[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}

