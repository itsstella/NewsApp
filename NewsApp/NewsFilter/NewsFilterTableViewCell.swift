//
//  NewsFilterTableViewCell.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import UIKit

class NewsFilterTableViewCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(categoryLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        categoryLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
    }
    
}
