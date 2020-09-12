//
//  BaseViewController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: Variables
    var isLoading = false

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup() {
        if let spinner = loadingSpinner {
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
        }
    }
    
    func startLoading() {
        isLoading = true
        loadingSpinner.startAnimating()
    }
    
    func stopLoading() {
        isLoading = false
        loadingSpinner.stopAnimating()
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func dismissViewTapped(sender: UIButton) {
        dismissView()
    }
}
