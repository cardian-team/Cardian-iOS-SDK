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
//        CardianApp.sync()
        
        let query = CardianQuery(scope: .individual, metric: .stepCount)
            .select(fields: [.value, .startTime]).limitedBy(limit: 10)
            .whereSingle(recordValue: 70, op: .lessThan, append: .and)
            .whereSingle(startTime: 1609810560, op: .greaterThan, append: .or)
        CardianApp.executeQuery(query: query) {
            result in
            switch result {
                case .success(let records):
                    print(records)
                case .failure(let error):
                    print(error)
            }
        }
    }
}

