//
//  CityTableViewCell.swift
//  Погода
//
//  Created by imran on 27.09.2023.
//

import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(countryLabel)
        countryLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20 ),
             nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            
             countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20 ),
             countryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            ]
                )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(name: String, country: String){
        nameLabel.text = name
        countryLabel.text = country
    }
}
