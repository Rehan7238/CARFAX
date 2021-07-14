//
//  CarsTableViewCell.swift
//  Carfax_Assignment
//
//  Created by Rehan Chaudhry on 7/14/21.
//

import Foundation
import UIKit

class CarsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carPictureImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carInfoLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var callDealershipButton: UIButton!
    
    var phoneNumber: String?
    
    func setup(car: Car) {
        let formattedData: [String: Any?] = car.formattedData
        if let price = formattedData["price"] as? Int {
            let cost = NumberFormatter.localizedString(from: NSNumber(value: price), number: .currency)
            priceLabel.text = cost
        }
        if let images = formattedData["images"] as? [String: Any], let firstPhoto = images["firstPhoto"] as? [String: String], let largeImage = firstPhoto["large"], let url = URL(string: largeImage) {
            carPictureImage.downloadImage(from: url)
        }
        
        var carInfo = ""
        if let year = formattedData["year"] as? Int { carInfo += "\(year) " }
        if let make = formattedData["make"] as? String { carInfo += make + " " }
        if let model = formattedData["model"] as? String { carInfo += model + " " }
        if let trim = formattedData["trim"] as? String { carInfo += trim }
        carInfoLabel.text = carInfo
        
        if let mileage = formattedData["mileage"] as? Int {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let formattedNumber = numberFormatter.string(from: NSNumber(value:mileage)) {
                mileageLabel.text = "\(formattedNumber) Mi"
            } else {
                mileageLabel.text = "N/A Mi"
            }
        }
        
        var location = ""
        if let dealer = formattedData["dealer"] as? [String: Any] {
            if let city = dealer["city"] as? String, let state = dealer["state"] as? String {
                location += city + ", " + state
            }
            
            if let phoneNumber = dealer["phone"] as? String {
                self.phoneNumber = phoneNumber
            } else {
                callDealershipButton.isHidden = true
            }
        }
        locationLabel.text = location
        
    }
    
    @IBAction func callDealershipButtonPressed(_ sender: Any) {
        if let phoneNumber = self.phoneNumber, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
