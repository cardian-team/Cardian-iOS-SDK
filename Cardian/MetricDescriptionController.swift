//
//  MetricDescriptionController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/16/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

struct MetricDescriptionDataSource {
    let title: String
    let description: String
    let privacyLink: String
}

class MetricDescriptionController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    // MARK: Constants
    public static let nibName = "MetricDescriptionController"
    
    // MARK: Variables
    var dataSource: MetricDescriptionDataSource
    
    // MARK: Functions
    init(dataSource: MetricDescriptionDataSource) {
        self.dataSource = dataSource
        super.init(nibName: MetricDescriptionController.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewSetup() {
        titleLabel.text = dataSource.title
        // TODO: set icon
        descriptionLabel.text = dataSource.description
        descriptionLabel.sizeToFit()
    }
    
    func linkTapped() {
        guard let url = URL(string: dataSource.privacyLink) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: IBActions
    @IBAction func linkButtonTapped() { self.linkTapped() }
    


}
