//
//  SubjectTableViewController.swift
//  appX
//
//  Created by user on 09.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {

    let wayTest = "tests/ege/"
    var way = String()
    var arrayOfSubjects = [[#imageLiteral(resourceName: "physics"), "physics"], [#imageLiteral(resourceName: "social_science"), "social_science"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSubjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSubject", for: indexPath)
        cell.imageView?.image = arrayOfSubjects[indexPath.row][0] as? UIImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        way = arrayOfSubjects[indexPath.row][1] as! String
        self.performSegue(withIdentifier: "segueSubject", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let testsViewController = segue.destination as! TestsTableViewController
        testsViewController.way = wayTest + way//"tests/ege/physics"
    }
    

}
