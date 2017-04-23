//
//  ViewControllerrrr.swift
//  appX
//
//  Created by user on 02.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewControllerrrr: UIViewController {

    
    @IBOutlet weak var imaage: UIImageView!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference()
        print("123")
        DispatchQueue.main.async {
            //self.ref.setValue(["test3" : 3])
            //self.ref.child("1").setValue(["test3" : 3])
           // self.ref.setValue(["test4" : 4])
            //self.ref.setValue(["test5" : 5])
            //let userID = FIRAuth.auth()?.currentUser?.uid
        /*    self.ref.child("1").observe(FIRDataEventType.value, with: { (snapshot) in
                // Get user value
                print(snapshot)
                let value = snapshot.value as? NS	Dictionary
                let username = value?["test3"] as? Int ?? 0
                print(username)
            }) { (error) in
                print(error.localizedDescription)
            }
            self.ref.updateChildValues(["test4" : 4])
            self.ref.updateChildValues(["test5" : 5])*/
          /*  let islandRef = storageRef.child("physics_test_02-04-2017/task1.png")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    self.imaage.image = UIImage(data: data!)
                    print("ed")
                }
            }
        }*/
        //ref.parent.
        // Do any additional setup after loading the view.
        }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test1" {
            print("gthtitk")
        }
        print("qqqqqqqqk")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    }
}
