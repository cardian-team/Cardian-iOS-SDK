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
        let bundle = Bundle(for: MetricDescriptionController.self)
        super.init(nibName: MetricDescriptionController.nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
