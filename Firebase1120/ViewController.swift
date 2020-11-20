//
//  ViewController.swift
//  Firebase1120
//
//  Created by H.W. Hsiao on 2020/11/19.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
    }

    func asdf() {
        var ref: DocumentReference? = nil
        ref = db.collection(<#T##collectionPath: String##String#>).addDocument(data: <#T##[String : Any]#>)
    }

}

