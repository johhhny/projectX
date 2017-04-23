//
//  TestsTableViewController.swift
//  appX
//
//  Created by user on 09.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class TestsTableViewController: UITableViewController {

    @IBOutlet var testsTableView: UITableView!
    
    var way = String()
    var wayTest = String()
    var quantityTest = Int()
    var arrayVsego = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hud = PKHUD()
        hud.contentView = PKHUDProgressView(title: "", subtitle: "")
        hud.show()
        FIRDatabase.database().reference().child(way).observe(FIRDataEventType.value, with: { (snapshot) in
            guard let quantityTests = snapshot.value as? NSDictionary else { print("quantityTests"); return }
            self.quantityTest = quantityTests.count
            var array = [String]()
            for key in quantityTests.allKeys {
                let test = quantityTests[key] as! NSDictionary
                if let id = test["id"] as? Int, let name = test["name"] as? String, let keyTest = key as? String {
                    array.append(String(id))
                    array.append(name)
                    array.append(keyTest)
                    self.arrayVsego.append(array)
                    array = []
                }
            }
            for i in 1..<self.arrayVsego.count {
                let a = self.arrayVsego[i][0]
                var j = i - 1
                while j >= 0 && self.arrayVsego[j][0] < a {
                    swap(&self.arrayVsego[j + 1], &self.arrayVsego[j])
                    j -= 1
                }
            }
            DispatchQueue.main.async {
                self.testsTableView.reloadData()
                hud.hide(true)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quantityTest
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTests", for: indexPath) as! TestsCell
        cell.textLabel?.text = arrayVsego[indexPath.row][1]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        wayTest = way + "/" + arrayVsego[indexPath.row][2]
        self.performSegue(withIdentifier: "test1", sender: nil)
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let testsViewController = segue.destination as! ViewController
        testsViewController.str = wayTest
    }
}
