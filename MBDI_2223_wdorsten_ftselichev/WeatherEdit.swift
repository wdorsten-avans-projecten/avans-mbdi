import SwiftUI

struct WeatherEdit: View {
    var wrapper: WeatherWrapper
    var weatherList: WeatherList
    @State var weatherImage: UIImage?
    @State private var imageName = "myimage"
    

    func updateImage(imageString: String) {
        self.imageName = imageString
        wrapper.isCustomImage = true
        wrapper.newCustomImage = imageName
       
        


    }
    
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
        
        VStack{
            
            
            Text("the city of " + wrapper.weather.location.name + "is:")
            if (wrapper.isCustomImage)
            {
                Image(wrapper.newCustomImage).resizable().frame(width: 100, height: 100)
            }
            else{
                if let weatherImage {
                    Image(uiImage: weatherImage).resizable().frame(width: 100, height: 100)
                }
            }
            Text("availible Images:")
            Button(action: {
                updateImage(imageString: "joy")
                   
            }) {
                Image("joy").resizable().frame(width: 100, height: 100)
            }
            Button(action: {
                updateImage(imageString: "sad")
            }) {
                Image("sad").resizable().frame(width: 100, height: 100)
            }
            Button(action: {
                updateImage(imageString: "contempt")
            }) {
                Image("contempt").resizable().frame(width: 100, height: 100)
            }
            Button(action: {
                updateImage(imageString: "disgust")
            }) {
                Image("disgust").resizable().frame(width: 100, height: 100)
            }
            
            
            Button("Delete this item") {
                debugPrint("deleting item")
                weatherList.deleteItem(weatherWrapper: wrapper)
            }

        }.onAppear(perform: {
            fetchWeatherImage()
        })
        
        
        
    }
}
