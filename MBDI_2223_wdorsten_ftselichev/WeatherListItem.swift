import SwiftUI

struct WeatherListItem: View {
    
    @State var wrapper: WeatherWrapper
    @State var weatherImage: UIImage?
    @State var displayTemp: String?
    
    func fetchWeatherImage() -> Void {
        if let finalURL = URL(string: "https:" + wrapper.weather.current.condition.icon) {
            let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
                var tempImage: UIImage?
                
                if let error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                if let data {
                    tempImage = UIImage(data: data)
                }
                
                if let tempImage {
                    DispatchQueue.main.async {
                        self.weatherImage = tempImage
                    }
                }
                
            }
            task.resume()
        }
    }
    
    var body: some View {
        HStack{
            if (wrapper.isCustomImage)
            {
                Image(wrapper.newCustomImage).resizable().frame(width: 50, height: 50)
            }
            else{
                if let weatherImage {
                    Image(uiImage: weatherImage).resizable().frame(width: 50, height: 50)
                }
            }
            
            Text(wrapper.weather.location.name)
            if let displayTemp {
                Text(displayTemp + " - " + wrapper.weather.current.condition.text)
            }
        }.onAppear(perform: {
            fetchWeatherImage()
            if UserDefaults.standard.bool(forKey: "tempDisplay") {
                self.displayTemp = String(wrapper.weather.current.temp_f) + "° F"
            } else {
                self.displayTemp = String(wrapper.weather.current.temp_c) + "° C"
            }
        })
    }
}
