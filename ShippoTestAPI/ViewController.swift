//
//  ViewController.swift
//  ShippoAPITest
//
//  Created by Mehdi Naghdi Tam on 11/19/17.
//  Copyright © 2017 Mehdi Naghdi Tam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class ViewController: UIViewController {
    
    var senderRef : DocumentReference!
    
    @IBOutlet weak var outletLabel: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        let myName = self.name.text!
        let myEmail = self.email.text!
        let info:[String: Any] = ["Name":myName,"Email": myEmail]
        senderRef.setData(info) { (error) in
            if let error = error {
                print("there has been an error \(error.localizedDescription)")
            } else{
                print("Data has been saved, No Problem")
            }
        }
    }
    @IBAction func fetchTapped(_ sender: UIButton) {
        senderRef.getDocument { (documentSnapshot, error) in
            guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {return}
                let myData = documentSnapshot.data()
                let firstTextName = myData["Name"] as? String ?? ""
                let emailTextEmail = myData["Email"] as? String ?? ""
                self.outletLabel.text = "\(firstTextName)+  + \(emailTextEmail)"
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderRef = Firestore.firestore().document("senders/senderPersonalData")
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func mainRequest(){
        
        var headers: HTTPHeaders = [
            "content-type": "application/json"
        ]
        
        let credentials = "shippo_test_ID"
        headers["Authorization"] = "ShippoToken \(credentials)"
        
        let addressTo = ["name": "Mr Hippo","street1": "965 Mission St #572","city": "San Francisco","state": "CA","zip": "94103","country": "US","phone": "4151234567","email": "mrhippo@goshippo.com"]
        let addressFrom = ["name": "Mrs Hippo","street1": "1092 Indian Summer Ct","city": "San Jose","state": "CA","zip": "95122","country": "US","phone": "4159876543","email": "mrshippo@goshippo.com"]
        let parcel = ["length": "10","width": "15","height": "10","distance_unit": "in","weight": "1","mass_unit": "lb"]
        let parameters:Parameters = ["address_to": addressTo,"address_from": addressFrom,"parcels": parcel,"async": false]

        let url = "https://api.goshippo.com/shipments/"
        print("Koochool")
        
        Alamofire.request(url, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let swiftyJson = JSON(value)
                    print ("return as JSON using swiftyJson is: \(swiftyJson)")
                case .failure(let error):
                    print ("error: \(error)")
                }
        }
    }
}



//        var parameters:Parameters = [String : Any]()
//
//        parameters["name"] = "Shawn Ippotle"
//        parameters["company"] = "Shippo"
//        parameters["street1"] = "215 Clayton St."
//        parameters["street2"] = ""
//        parameters["city"] = "San Francisco"
//        parameters["state"] = "CA"
//        parameters["zip"] = "94117"
//        parameters["phone"] = "+1 555 341 9393"
//        parameters["country"] = "US"
//        parameters["email"] = "shippotle@goshippo.com"
//        parameters["is_residential"] = "True"
//        parameters["metadata"] = "Customer ID 123456"

