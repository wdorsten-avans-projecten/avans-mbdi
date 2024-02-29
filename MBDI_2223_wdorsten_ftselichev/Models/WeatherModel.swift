import Foundation

class WeatherModel: Decodable {
    var location: Location
    var current: Current
    
    struct Location: Decodable {
        var name: String
        var region: String
        var country: String
        var lat: Double
        var lon: Double
    }
    
    struct Current: Decodable {
        var temp_c: Double
        var temp_f: Double
        var feelslike_c: Double
        var feelslike_f: Double
        var humidity: Int
        var cloud: Int
        var condition: Condition
        
        struct Condition: Decodable {
            var text: String
            var icon: String
            
            
        }
    }
}
