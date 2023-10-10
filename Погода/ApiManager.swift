//
//  ApiManager.swift
//  Погода
//
//  Created by imran on 01.09.2023.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    let apiKey: String = "5d36f3e7f67e4f99ca11f66918ff1ff9"
    
    private init(){
        
    }
    
    func requestDataByLocation(latitude: Double, longtitude: Double, completition: @escaping (Result<Welcome,Error>) -> Void) {
        
        guard let url = URL(
            string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&appid=\(apiKey)")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        print(url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
//                print(data.prettyPrintedJSONString)
                
                let value = try JSONDecoder().decode(Welcome.self, from: data)
//                print(value.main.temp)
                completition(.success(value))
            } catch {
                print(error)
                completition(.failure(error))
            }
        }
        task.resume()
    }
    
    func requestDataByCityName(city: String, completition: @escaping (Result<Welcome,Error>) -> Void) {
        
        guard let url = URL(
            string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&lang=ru&appid=\(apiKey)")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
                
                let value = try JSONDecoder().decode(Welcome.self, from: data)
                completition(.success(value))
            } catch {
                print(error)
                completition(.failure(error))
            }
        }
        task.resume()
    }
    
    func requestCitiesName(completition: @escaping (Result<City,Error>) -> Void) {
        
        guard let url = URL(
            string:"https://countriesnow.space/api/v0.1/countries/population/cities")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {return}
            
            do {
                
                let value = try JSONDecoder().decode(City.self, from: data)
                completition(.success(value))
            } catch {
                print(error)
                completition(.failure(error))
            }
        }
        task.resume()
    }

    
}
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
