//
//  ConfirmationController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/16/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

class ConfirmationController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButon: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: Constants
    public static let nibName = "ConfirmationController"
    private let descriptionLabelText = "Your Apple Health data was successfully synced"
    
    // MARK: Variables
    var appName: String?
    var actionButtonTitle: String
    
    // MARK: Functions
    init(appName: String? = nil, actionButtonTitle: String = "Continue") {
        self.appName = appName
        self.actionButtonTitle = actionButtonTitle
        var bundle : Bundle? = nil
        let path = Bundle(for: ConfirmationController.self).path(forResource: "Cardian", ofType: "bundle")
        
        if (path == nil) {
            bundle = Bundle(for: ConfirmationController.self)
        } else {
            bundle = Bundle(path: path!)
        }
        super.init(nibName: ConfirmationController.nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewSetup() {
        actionButon.setTitle(self.actionButtonTitle, for: .normal)
        CardianStyler.styleRoundedButton(button: actionButon, backgroundColor: UIColor.primaryColor)
        
        var descriptionText = descriptionLabelText
        if let name = appName { descriptionText += " with \(name)"}
        descriptionLabel.text = descriptionText
    }
}
