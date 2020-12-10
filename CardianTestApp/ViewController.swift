//
//  ViewController.swift
//  CardianTestApp
//
//  Created by Mitchell Sweet on 9/19/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit
import Cardian

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CardianApp.promptForPermissions(presentationController: self) { (success) in
            print("Return from controller: \(success)")
        }
    }
    
    @IBAction func connectTapped() {
        CardianApp.sync()
    }
}

