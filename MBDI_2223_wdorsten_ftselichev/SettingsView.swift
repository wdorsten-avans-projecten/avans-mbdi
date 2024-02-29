//
//  SettingsView.swift
//  MBDI_2223_wdorsten_ftselichev
//
//  Created by Wessel van Dorsten on 29/03/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("tempDisplay") private var tempDisplay = false
    @AppStorage("language") private var language = "en"
    
    var body: some View {
        Form {
            Section(header: Text("Weather Data Display")) {
                Toggle("Display temp. in Fahrenheit", isOn: $tempDisplay).onSubmit {
                    UserDefaults.standard.set($tempDisplay, forKey: "tempDisplay")
                }
                Picker("Language", selection: $language) {
                    Text("English").tag("en")
                    Text("French").tag("fr")
                    Text("Korean").tag("ko")
                    Text("Dutch").tag("nl")
                    Text("Russian").tag("ru")
                }.onChange(of: language) {
                    tag in UserDefaults.standard.set(tag, forKey: "language")
                }
            }
        }
        .padding(20)
    }
}
