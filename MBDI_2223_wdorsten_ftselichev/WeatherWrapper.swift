import Foundation

public class WeatherWrapper: Identifiable, Decodable {
    public var id: Int
    var weather: WeatherModel
    var isCustomImage: Bool
    var newCustomImage: String
    
    init(id: Int, weather: WeatherModel, isCustomImage: Bool, newCustomImage: String) {
        self.id = id
        self.weather = weather
        self.isCustomImage = isCustomImage
        self.newCustomImage = newCustomImage
    }

}


