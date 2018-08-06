

import Foundation

struct WeatherSummary {
    let summary:String
//    let icon:String
//    let temperature:Double
//    let windSpeed:Double
    
 //   let time:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
//        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
//
//        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temp is missing")}
//        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("temp is missing")}
        
 //       guard let time = json["time"] as? Double else {throw SerializationError.missing("time is missing")}
//
        self.summary = summary
//        self.icon = icon
//        self.temperature = temperature
//        self.windSpeed = windSpeed
        
//        self.time = time
        
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/efd21cf614c4f0429e807683bbe7b1e4/"
    
    
    
    static func forecast (withLocation location:String, completion: @escaping ([WeatherSummary]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[WeatherSummary] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            
                            
                            let weatherObject = try? WeatherSummary(json: dailyForecasts)
                            forecastArray.append(weatherObject!)
                            
                            
                            
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
        
        
    }
    
    
}
