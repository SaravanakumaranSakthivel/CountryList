//
//  CountryListTableViewCell.swift
//  CountryList
//
//  Created by Saravanakumaran Sakthivel on 3/18/24.
//

import UIKit

// Protocol to update ui with the provided country
protocol CountryListTableViewCellProtocol {
    func updateCountryDetails(country: Country)
}

class CountryListTableViewCell: UITableViewCell {
    
    // Cell reusable identifier
    static let reusuableIdentifier = "CellID"
    
    // Lazy Vertical stack intialization
    lazy var verticalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()

    // Lazy Horizontal stack intialization
    /// This stackview contains Country Name, Region and Code label
    lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // Lazy countrylabel declartion
    lazy var countryNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Lazy regionName label declartion
    lazy var regionNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Lazy codeNamelabel declartion
    lazy var codeNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Lazy Captial label declartion
    lazy var capitalNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.font = .italicSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Setup cell with all defined UI elements
    private func setupCell() {
        
        self.contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(capitalNameLabel)
        
        horizontalStackView.addArrangedSubview(countryNameLabel)
        horizontalStackView.addArrangedSubview(regionNameLabel)
        horizontalStackView.addArrangedSubview(codeNameLabel)
        
        setupContraints()
    }
    
    // Adjust UIelement constaints
    private func setupContraints() {
        verticalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15.0).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
       
        regionNameLabel.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        codeNameLabel.widthAnchor.constraint(equalToConstant: 40.0).isActive = true

    }
}

// Protocol extension helps to update cell ui elements with the givien country object.
extension CountryListTableViewCell: CountryListTableViewCellProtocol {
    func updateCountryDetails(country: Country) {
        countryNameLabel.text = (country.name.isEmpty) ? "N/A" : country.name
        regionNameLabel.text = (country.region.isEmpty)  ? "N/A" : country.region
        codeNameLabel.text = (country.code.isEmpty) ? "N/A" : country.code
        capitalNameLabel.text = (country.capital.isEmpty) ? "N/A" : country.capital
    }
}
