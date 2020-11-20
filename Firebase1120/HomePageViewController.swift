//
//  HomePageViewController.swift
//  Firebase1120
//
//  Created by H.W. Hsiao on 2020/11/20.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase.FIRDataSnapshot


struct Data {
    let author: String
    let email: String
    let authorId: String
    let title: String
    let content: String
    let createdTime: Date
    let id: String
    let category: String
}

class HomePageViewController: UIViewController {
    
    var db = Firestore.firestore()
    var databaseRef: DatabaseReference!
    var refreshControl = UIRefreshControl()
    var downloadedData = [String:Any]()
    var articles = [Data]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        articles = [Data]()
        getAllDoc()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        articles = [Data]()
        getAllDoc()
    }
    
    func getAllDoc() {
        db.collection("articles").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        let author = data["author"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let authorId = data["authorId"] as? String ?? ""
                        let title = data["title"] as? String ?? ""
                        let content = data["content"] as? String ?? ""
                        let createdTime = data["createdTime"] as? Date ?? Date()
                        let id = data["id"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        let newSource = Data(author: author, email: email, authorId: authorId, title: title, content: content, createdTime: createdTime, id: id, category: category)
                        self.articles.append(newSource)
                    }
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! HomePageTableViewCell
        
        articleCell.title.text = articles[indexPath.row].title
        articleCell.author.text = articles[indexPath.row].author
        articleCell.category.text = articles[indexPath.row].category
        articleCell.createdTime.text = articles[indexPath.row].createdTime.description
        articleCell.content.text = articles[indexPath.row].content
        return articleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
