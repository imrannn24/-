//
//  FindCityViewController.swift
//  Погода
//
//  Created by imran on 27.09.2023.
//

import UIKit

class FindCityViewController: UIViewController {
    
    private var citiesList: [Datum] = []
    private var filteredList: [Datum] = []
    private var isFiltering: Bool = false
    
    var delegate: SendText?
    
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.clipsToBounds = true
        searchBar.placeholder = "Search..."
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cell")
        
        setUpView()
        
        netWorking()
        
    }
    
    private func setUpView(){
        
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 5),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
            searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)])
        
    }
    
    private func netWorking(){
        
        ApiManager.shared.requestCitiesName { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.citiesList = value.data
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }

}

extension FindCityViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        isFiltering ? filteredList.count : citiesList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        
        let model = citiesList[indexPath.row]
        
        cell.setData(name: isFiltering ?
                     filteredList[indexPath.row].city : model.city,
                     country: isFiltering ?
                     filteredList[indexPath.row].country : model.country)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
        delegate?.setData(ttext: selectCell.nameLabel.text ?? "Bishkek")
        print("tapped")
        dismiss(animated: true)
    }
    
}

extension FindCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isFiltering = false
        }else{
            isFiltering = true
            filteredList = citiesList.filter({$0.city.lowercased().contains(searchText.lowercased()) || $0.country.lowercased().contains(searchText.lowercased())})
        }

        tableView.reloadData()
    }
}
