//
//  NewsFilterTableViewController.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NewsFilterViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var sourcesData : SourcesModel?
    var categoryArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Filter Category"
        
        self.navigationController?.navigationBar.topItem?.title = "Back"
        
        let url = "https://newsapi.org/v2/sources?apiKey=036ecdaf86f943509529d6ec6a40c8b1"
        
        Alamofire.request(url).responseObject { (response: DataResponse<SourcesModel>) in
            let respon = response.result.value
            self.sourcesData = respon

            for item in self.sourcesData?.sources ?? [] {
                self.categoryArray.append(item.category ?? "")
            }
            
            self.categoryArray = self.uniq(source: self.categoryArray)
            
            self.tableview.reloadData()
        }
    }

    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func setupTableView() {
        
        tableview.register(NewsFilterTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        tableview.delegate = self
        tableview.dataSource = self
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NewsFilterTableViewCell
        cell.backgroundColor = UIColor.white
        cell.categoryLabel.text = categoryArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(categoryArray[indexPath.row], forKey: "filter")
        UserDefaults.standard.set(true, forKey: "source")
        navigationController?.popToRootViewController(animated: true)

    }
}

