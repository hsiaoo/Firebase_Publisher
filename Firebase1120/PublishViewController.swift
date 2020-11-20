//
//  PublishViewController.swift
//  Firebase1120
//
//  Created by H.W. Hsiao on 2020/11/19.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class PublishViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var authorIdTextTield: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    let categoryPicker = UIPickerView()
    let category = ["Beauty", "School Life", "Gossiping", "IU"]
    var db: Firestore!
    var data: [String:Any]!
    var authorId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        categoryTextField.inputView = categoryPicker
        categoryPicker.delegate = self
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backBtn))
        
        
    }
    

    
    @IBAction func doneBtn(_ sender: Any) {
        checkAuthor()
        
    }
    
    
    @objc func backBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func checkAuthor() {
        if authorIdTextTield.text == "" {
            authorId = "waynechen323"
        } else {
            authorId = authorIdTextTield.text
        }
        db.collection("author").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var currentId = ""
                    currentId = (document.data()["id"] as? String)!
                    if self.authorId != currentId {
                        self.showAlert(title: "Oops...", message: "No such author")
                    } else {
                        self.processData()
                        print("\(document.documentID) => \(document.data())")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    func processData() {
        if titleTextField.text != "" && contentTextView.text != "" && categoryTextField.text != "" {
            if let title = titleTextField.text, let content = contentTextView.text, let category = categoryTextField.text {
                data = [
                    "author": "AKA小安老師",
                    "email": "wayne@school.appworks.tw",
                    "authorId": "\(authorId ?? "waynechen323")",
                    "title": "\(title)",
                    "content": "\(content)",
                    "createdTime": NSDate().timeIntervalSince1970,
                    "id": "",
                    "category": "\(category)"
                ]
            }
            addDoc(data: data)
        } else {
            showAlert(title: "Oops..", message: "There are some empty field.")
        }
    }
    
    
    func addDoc(data: [String:Any]) {
        var ref: DocumentReference? = nil
        ref = db.collection("articles").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref?.documentID ?? "000000")")
            }
        }
        guard let id = ref?.documentID else { return }
        updateIdTime(docId: id)
    }
    
    
    func updateIdTime(docId: String) {
        db.collection("articles").document(docId).updateData([
            "id": "\(docId)",
            "createdTime": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    

} //end of class ViewController

extension PublishViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = category[row]
    }
    
    
}
