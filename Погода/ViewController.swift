//
//  ViewController.swift
//  Погода
//
//  Created by imran on 30.08.2023.
//

import UIKit
import SnapKit
import CoreLocation

class ViewController: UIViewController {
    
    static let view = ViewController()
    
    var taski: [String] = []
    
    let locationManager = CLLocationManager()
    let todayDate = Date()
    
    lazy var searchTF: UITextField = {
        let view = UITextField()
        view.placeholder = "Название города..."
        view.font = UIFont(name: "Comfortaa", size: 24)
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        view.layer.cornerRadius = 16
        view.alpha = 0.7
        return view
    }()
    
    lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "day")
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Comfortaa-Bold", size: 64)
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    
    lazy var celsiusLabel: UILabel = {
        let view = UILabel()
        view.text = "°"
        view.font = UIFont(name: "Comfortaa-Bold", size: 64)
        return view
    }()
    
    lazy var temperatureLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Comfortaa", size: 120)
        return view
    }()
    
    lazy var weatherIconImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var windLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Comfortaa", size: 36)
        return view
    }()
    
    lazy var weatherDesriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Comfortaa", size: 38)
        view.numberOfLines = 3
        view.textAlignment = .center
        return view
    }()
    
    lazy var dateValue: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Comfortaa", size: 38)
        view.numberOfLines = 3
        return view
    }()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setUpView()
        
        startLocationManager()
        
        searchTF.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openSignIn))
            }
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func updateWeatherInfo(latitude: Double, longtitude: Double) {
        ApiManager.shared.requestDataByLocation(latitude: latitude, longtitude: longtitude) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        var time = self.todayDate.hourValue
                        if time >= 6 && time <= 18 {
                            self.bgImage.image = UIImage(named: "day")
                            let pogoda: Weather = value.weather.first!
                            self.locationLabel.text = value.name
                            self.locationLabel.textColor = .black
                            self.temperatureLabel.text = String(Int(value.main.temp))
                            self.temperatureLabel.textColor = .black
                            self.celsiusLabel.textColor = .black
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .black
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .black
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .black
                            print(value)
                        } else {
                            self.bgImage.image = UIImage(named: "night")
                            let pogoda: Weather = value.weather.first!
                            self.locationLabel.text = value.name
                            self.locationLabel.textColor = .white
                            self.temperatureLabel.text = String(Int(value.main.temp))
                            self.temperatureLabel.textColor = .white
                            self.celsiusLabel.textColor = .white
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .white
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .white
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .white
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    
    @objc func openSignIn() {
        navigationController?.pushViewController(AuthViewController(), animated: true)
    }
 
    
    
    private func setUpView() {
        
        view.addSubview(bgImage)
        
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(searchTF)
        
        searchTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        view.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(30)
        }

        view.addSubview(weatherDesriptionLabel)
        
        weatherDesriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(-5)
            make.horizontalEdges.equalToSuperview().inset(30)
        }

        view.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherDesriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(weatherIconImage)
        
        weatherIconImage.snp.makeConstraints { make in
            make.bottom.equalTo(temperatureLabel.snp.bottom).offset(-10)
            make.leading.equalTo(temperatureLabel.snp.trailing).offset(-10)
            make.width.height.equalTo(80)
        }
        
        view.addSubview(celsiusLabel)
        
        celsiusLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.top)
            make.leading.equalTo(temperatureLabel.snp.trailing)
        }
        
        view.addSubview(dateValue)
        
        dateValue.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
                
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
//            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude,
                              longtitude: lastLocation.coordinate.longitude)
        }
    }
}

extension Date{

    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("EE dd MMM")
        return dateFormatter.string(from: self)
    }
    
    var hourValue: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 12
    }
    
    var timeValue: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.endEditing(true)
        print(searchTF.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Название города..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTF.text {
            ApiManager.shared.requestDataByCityName(city: city) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        var time = self.todayDate.hourValue
                        if time >= 6 && time <= 18 {
                            self.bgImage.image = UIImage(named: "day")
                            let pogoda: Weather = value.weather.first!
                            self.locationLabel.text = value.name
                            self.locationLabel.textColor = .black
                            self.temperatureLabel.text = String(Int(value.main.temp))
                            self.temperatureLabel.textColor = .black
                            self.celsiusLabel.textColor = .black
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .black
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .black
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .black
                            print(value)
                        } else {
                            self.bgImage.image = UIImage(named: "night")
                            let pogoda: Weather = value.weather.first!
                            self.locationLabel.text = value.name
                            self.locationLabel.textColor = .white
                            self.temperatureLabel.text = String(Int(value.main.temp))
                            self.temperatureLabel.textColor = .white
                            self.celsiusLabel.textColor = .white
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .white
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .white
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .white
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        
        searchTF.text = ""
    }
}


