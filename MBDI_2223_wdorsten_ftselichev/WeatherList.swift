import SwiftUI
import CoreLocation

struct WeatherList: View {
    
    @State var WeatherSourceList: [WeatherWrapper] = []
    @State var SearchText: String = ""
    @State var fetchCount: Int = 0
    @State var showFetchAlert: Bool = false
    @State var curLan: String = UserDefaults.standard.string(forKey: "language") ?? ""
    
    let locationManager = CLLocationManager()
    
    let cityNames: [String] = [
        "Amsterdam",
        "Brussels",
        "Paris",
        "Berlin",
        "Moscow",
        "Madrid",
        "Seattle",
        "New York",
    ]
    
    public func deleteItem(weatherWrapper: WeatherWrapper)
    {
        WeatherSourceList.remove(at: weatherWrapper.id)
    }
    
    private func FetchWeather(location: String, id: Int) -> Void {
        if let final_url = URL(string: createURLString() + "&q=" + location.replacingOccurrences(of: " ", with: "%20")) {
            var NewWeatherData: WeatherModel?
            let task = URLSession.shared.dataTask(with: final_url) { data, _, error in
                
                if let error = error {
                    print("ERROR: Failed to fetch from API. Aborting... \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("ERROR: Failed to get data from URLSession, aborting...")
                    return
                }
                
                do {
                    NewWeatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                } catch let error as NSError {
                    print("ERROR: Failed to decode JSONObject to WeatherModel: \(error.localizedDescription)")
                }
                
                if NewWeatherData == nil {
                    print("ERROR: Failed to read data. Aborting...")
                    return
                } else {
                    if let NewWeatherData {
                        DispatchQueue.main.async {
                            self.WeatherSourceList.append(WeatherWrapper(id: id, weather: NewWeatherData, isCustomImage: false, newCustomImage: ""))
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    private func FillWeatherSourceList() -> Void {
        let storedWeatherSourceList = UserDefaults.standard.array(forKey: "weatherSourceList") as? [WeatherWrapper]
        
        
        
        if (WeatherSourceList.count == 0) {
            for name in cityNames {
                FetchWeather(location: name, id: self.fetchCount)
                self.fetchCount = fetchCount + 1
            }
        }
        
        
        
    }
    
    private func FetchCurrentLocation() -> Void {
        
        locationManager.requestWhenInUseAuthorization()
        
        if let curLoc = locationManager.location {
            let latLon: String = String(curLoc.coordinate.latitude) + "," + String(curLoc.coordinate.longitude)
            FetchWeather(location: latLon, id: self.fetchCount)
        }
        
    }
    
    var body: some View {
        VStack {
            TextField("Search for a location", text: $SearchText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    FetchWeather(location: self.SearchText, id: self.fetchCount)
                    self.fetchCount += 1
                    self.showFetchAlert = true;
                }
                .alert(isPresented: $showFetchAlert, content: { Alert(title: Text("Added item to the list.")) })
            Button("Fetch current location", action: FetchCurrentLocation)
        }
        NavigationView {
            VStack {
                NavigationLink("Settings", destination: SettingsView())
                List(WeatherSourceList)
                {
                    weather in NavigationLink(destination: WeatherEdit(wrapper: weather, weatherList: self))
                    {
                        WeatherListItem(wrapper: weather)
                    }
                }
            }
        }
        .onAppear(perform: {
            FillWeatherSourceList()
            
            UserDefaults.standard.set(WeatherSourceList, forKey: "weatherSourceList")
        })
    }
}
