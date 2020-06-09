//
//  ViewController.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var indexOfPageToRequest = 1
    var dataNews: NewsModel? = nil
    var sourceArray: [String] = []
    var totalData = 0
    var oneTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        
        UserDefaults.standard.set(false, forKey: "source")
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "NEWS"
        
        indexOfPageToRequest = 1

    }

    override func viewWillAppear(_ animated: Bool) {
        
        indexOfPageToRequest=1
        
        let filter = UserDefaults.standard.string(forKey: "filter")
        hitAPI(url: "https://newsapi.org/v2/everything?q="+(filter ?? "business")+"&apiKey=036ecdaf86f943509529d6ec6a40c8b1&pageSize=10&page=1")
        
        oneTime = true
        Alamofire.request("https://newsapi.org/v2/everything?q="+(filter ?? "business")+"&apiKey=036ecdaf86f943509529d6ec6a40c8b1").responseObject { (response: DataResponse<NewsModel>) in
            let newsResponse = response.result.value
            self.dataNews = newsResponse
            
            self.totalData = newsResponse?.articles?.count ?? 0
        }
    }
    
    func hitAPI(url: String) {
        self.dataNews = nil
        let URL = url
        Alamofire.request(URL).responseObject { (response: DataResponse<NewsModel>) in
            let newsResponse = response.result.value
            self.dataNews = newsResponse
            
            
            for item in self.self.dataNews?.articles ?? [] {
                self.sourceArray.append(item.source?.name ?? "")
            }
            
            self.sourceArray = self.uniq(source: self.sourceArray)
            
            self.tableView.reloadData()
        }
        
        if (UserDefaults.standard.bool(forKey: "source")) {
            btnSource.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)
            btnCategory.backgroundColor = UIColor.gray
            tableView.estimatedRowHeight = 50.0
            tableView.rowHeight = UITableView.automaticDimension
        } else {
            btnCategory.backgroundColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)
            btnSource.backgroundColor = UIColor.gray
            tableView.estimatedRowHeight = 120.0
            tableView.rowHeight = UITableView.automaticDimension
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
    
    @IBAction func btnEnterClicked(_ sender: Any) {
        let vc = NewsFilterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchSourceClicked(_ sender: Any) {
        if searchTextField.text != "" {
            UserDefaults.standard.set(true, forKey: "source")
            let sources = searchTextField.text ?? "bbc-news"
            hitAPI(url: "https://newsapi.org/v2/everything?domains="+sources+",%20news&apiKey=036ecdaf86f943509529d6ec6a40c8b1")
        }
    }
    
    @IBAction func searchArticelsClicked(_ sender: Any) {
        if searchTextField.text != "" {
            UserDefaults.standard.set(false, forKey: "source")
            let search = searchTextField.text ?? ""
            hitAPI(url: "https://newsapi.org/v2/everything?q="+search+"&apiKey=036ecdaf86f943509529d6ec6a40c8b1")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserDefaults.standard.bool(forKey: "source")){
            return sourceArray.count
        } else {
            return self.dataNews?.articles?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (UserDefaults.standard.bool(forKey: "source")){
            
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "sourceCell")

               if (cell == nil) {
                   cell = SourceTableViewCell()
               }

            (cell as! SourceTableViewCell).sourceName.text = self.sourceArray[indexPath.row]

            
            return cell ?? UITableViewCell()
        } else {
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ArticleCell")

               if (cell == nil) {
                   cell = ArticleTableViewCell()
               }

            (cell as! ArticleTableViewCell).lblTitle.text = self.dataNews?.articles?[indexPath.row].title
            (cell as! ArticleTableViewCell).lblDesc.text = self.dataNews?.articles?[indexPath.row].description
            
            (cell as! ArticleTableViewCell).imgArticle.kf.setImage(with: URL(string: self.dataNews?.articles?[indexPath.row].urlToImage ?? ""))
            
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UserDefaults.standard.bool(forKey: "source")){
            return 50
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (UserDefaults.standard.bool(forKey: "source")){
            
            UserDefaults.standard.set(false, forKey: "source")
            let sources = dataNews?.articles?[indexPath.row].source?.id ?? "bbc-news"
            hitAPI(url: "https://newsapi.org/v2/everything?q="+sources+"&apiKey=036ecdaf86f943509529d6ec6a40c8b1")
            
        } else {
            let vc = NewsDetailWebView()
            vc.stringUrl = dataNews?.articles?[indexPath.row].url ?? ""
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spinner = UIActivityIndicatorView(style: .gray)
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")

            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false

            indexOfPageToRequest+=1
            if (10*indexOfPageToRequest<=totalData) {
                let temp = 10*indexOfPageToRequest
                let filter = UserDefaults.standard.string(forKey: "filter")

                let url1 = "https://newsapi.org/v2/everything?q="+(filter ?? "business")+"&apiKey=036ecdaf86f943509529d6ec6a40c8b1&pageSize="
                let url2 = String(temp)+"&page=1"
                hitAPI(url: url1+url2)

                    spinner.isHidden = true
            } else if oneTime {
                var temp = 10*indexOfPageToRequest
                temp = indexOfPageToRequest*10 + (indexOfPageToRequest-totalData)
                spinner.isHidden = true
                oneTime = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            spinner.isHidden = true
            }
        }
    }
}
