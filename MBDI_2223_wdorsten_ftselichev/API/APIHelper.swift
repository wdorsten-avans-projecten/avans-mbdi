//
//  APIHelper.swift
//  MBDI_2223_wdorsten_ftselichev
//
//  Created by Wessel van Dorsten on 29/03/2023.
//

import Foundation

let api_key: String = "f0b85a7246fd49daaa5135916232003"
let url: String = "https://api.weatherapi.com/v1/current.json"

func createURLString() -> String {
    var url_string: String = url + "?key=" + api_key
    
    if let lang = UserDefaults().string(forKey: "language") {
        if lang != "en" {
            url_string.append("&lang=" + lang)
        }
    }
    
    return url_string
}
