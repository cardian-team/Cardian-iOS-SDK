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
            .whereMulti(fields: [.value, .value], values: [60.0, 100.0], ops: [.greaterThanEqual, .lessThan], appends: [.and, .and], finalAppend: .and)
        
        CardianApp.executeQuery(query: query) {
            result in
            switch result {
                case .success(let records):
                    print(records)
                    break
                case .failure(let error):
                    print("in failure of cb \(error)")
                    break
            }
        }
    }
}

