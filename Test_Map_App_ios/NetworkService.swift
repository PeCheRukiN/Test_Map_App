//
//  NetworkService.swift
//  Test_Map_App_ios
//
//  Created by PeCheRukiN on 26.08.17.
//  Copyright © 2017 PeCheRukiN. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    func getSingleAdress(for longitude: Double, latitude: Double, completion: @escaping (String) -> ()) {
        Alamofire.request("https://api-dev.supermenu.kz/address/clientGeocode?longitude=\(longitude)&latitude=\(latitude)").responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
            } else if let data = response.data {
                let json = JSON(data: data)
                if let adress = json["data"]["name"].string {
                    completion(adress)
                }
            }
        }
    }
    
    func getAdressesBundle(for string: String, completion: @escaping ([AdressData]) -> ()) {
        let stringURL = "https://api-dev.supermenu.kz/address/clientSearch?query=\(string.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: string)) ?? " ")"
        Alamofire.request(stringURL).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
            } else if let data = response.data {
                let json = JSON(data: data)
                if let adresses = json["data"].array {
                    var stringAdresses: [AdressData] = []
                    for adress in adresses {
                        guard
                            let adressName = adress["name"].string,
                            let latitude = adress["latitude"].double,
                            let longitude = adress["longitude"].double
                            else {return}
                        let adressData = AdressData(name: adressName, longitude: longitude, latitude: latitude)
                        stringAdresses.append(adressData)
                    }
                    completion(stringAdresses)
                }
            }
        }
    }
    
    func getNearestAddresses(for longitude: Double, latitude: Double, completion: @escaping ([AdressData]) -> ()) {
        Alamofire.request("https://api-dev.supermenu.kz/address/clientSearch?longitude=\(longitude)&latitude=\(latitude)").responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
            } else if let data = response.data {
                let json = JSON(data: data)
                if let adresses = json["data"].array {
                    var stringAdresses: [AdressData] = []
                    for adress in adresses {
                        guard
                            let adressName = adress["name"].string,
                            let latitude = adress["latitude"].double,
                            let longitude = adress["longitude"].double
                            else {return}
                        let adressData = AdressData(name: adressName, longitude: longitude, latitude: latitude)
                        stringAdresses.append(adressData)
                    }
                    completion(stringAdresses)
                }
            }
        }
    }
}
