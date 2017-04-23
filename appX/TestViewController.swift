//
//  TestViewController.swift
//  appX
//
//  Created by user on 02.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test1" {
            let vc = segue.destination as! ViewController
            vc.str = "tests/ege/physics/physics_test_02-04-2017"//"physics_test_02-04-2017"
        }
    }
    
}
