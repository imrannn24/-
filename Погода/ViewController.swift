//
//  ViewController.swift
//  Погода
//
//  Created by imran on 30.08.2023.
//

import UIKit
import SnapKit
import CoreLocation

protocol SendText {
    func setData(ttext: String)
}

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
        view.textColor = .black
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
        
        view.insetsLayoutMarginsFromSafeArea = true
        
        view.safeAreaInsetsDidChange()
        
        setUpView()
        
        startLocationManager()
        
        searchTF.delegate = self
        
        navigationItem.title = "Погода"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(openSignIn))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Find", style: .plain, target: self, action: #selector(onenFinder))
        
    }
    
    func startLocationManager() {
            locationManager.requestWhenInUseAuthorization()
            
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.startUpdatingLocation()
            }
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
                            self.celsiusLabel.text = "°"
                            self.celsiusLabel.textColor = .black
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .black
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .black
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .black
                            self.locationManager.stopUpdatingLocation()
                        } else {
                            self.bgImage.image = UIImage(named: "night")
                            let pogoda: Weather = value.weather.first!
                            self.locationLabel.text = value.name
                            self.locationLabel.textColor = .white
                            self.temperatureLabel.text = String(Int(value.main.temp))
                            self.temperatureLabel.textColor = .white
                            self.celsiusLabel.text = "°"
                            self.celsiusLabel.textColor = .white
                            self.windLabel.text = String(value.wind.speed)
                            self.windLabel.textColor = .white
                            self.weatherDesriptionLabel.text = pogoda.description
                            self.weatherDesriptionLabel.textColor = .white
                            self.weatherIconImage.image = UIImage(named: "\(pogoda.icon)")
                            self.dateValue.text = self.todayDate.stringDate
                            self.dateValue.textColor = .white
                            self.locationManager.stopUpdatingLocation()
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
    
    @objc func onenFinder() {
        let vc = FindCityViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
 
    
    
    private func setUpView() {
        
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(bgImage)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchTF)
        searchTF.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(weatherDesriptionLabel)
        weatherDesriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(temperatureLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(weatherIconImage)
        weatherIconImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(celsiusLabel)
        celsiusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([bgImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     bgImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     bgImage.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     bgImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                                    
                                     searchTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     searchTF.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor , multiplier: 1),
                                     searchTF.heightAnchor.constraint(equalToConstant: 45),
                                     searchTF.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     searchTF.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                    
                                     locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     locationLabel.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 20),
                                     locationLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     locationLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                    
                                     weatherDesriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     weatherDesriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
                                     weatherDesriptionLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     weatherDesriptionLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                    
                                     temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     temperatureLabel.topAnchor.constraint(equalTo: weatherDesriptionLabel.bottomAnchor,
                                                                                                        constant: 20),
                                    
                                     weatherIconImage.bottomAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
                                     weatherIconImage.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor,
                                                                                                        constant: -8),
                                     weatherIconImage.widthAnchor.constraint(equalToConstant: 80),
                                     weatherIconImage.heightAnchor.constraint(equalToConstant: 80),
                                    
                                     celsiusLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor),
                                     celsiusLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor,
                                                                                                        constant: -8)])

    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
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
                            self.celsiusLabel.text = "°"
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
                            self.celsiusLabel.text = "°"
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

extension ViewController: SendText {
    func setData(ttext: String) {
        searchTF.text = ttext
    }
}
