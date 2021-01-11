//
//  Connect.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/17/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import UIKit

@objc (CRDConnect) public class Connect: NSObject {
    
    @objc public class func connect(presentationController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let configuration = CardianApp.getConfiguration() else {
            // TODO callback failure here
            completion(false)
            return
        }
        let disclosureView = DisclosureViewController(currentConfiguration: configuration)
        if #available(iOS 13.0, *) { disclosureView.isModalInPresentation = true }
        let navController = UINavigationController(rootViewController: disclosureView)
        navController.setNavigationBarHidden(true, animated: false)
        navController.navigationBar.tintColor = .systemGray
        presentationController.present(navController, animated: true) {
            completion(true)
            print("CardianConnect successfully presented.")
        }
    }
    
    @objc public class func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let authMetrics = CardianApp.getAuthMetrics()
        AuthManager.authorize(authMetrics: authMetrics) { (bool, error) in
            guard error == nil else {
                print("HEALTH KIT ERROR: Unable to requrest authorization: \(error.debugDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
