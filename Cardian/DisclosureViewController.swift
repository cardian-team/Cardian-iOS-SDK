//
//  DisclosureViewController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/12/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

class DisclosureViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var mainActionButton: UIButton!
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: Constants
    public static let nibName = "DisclosureViewController"
    
    // MARK: Variables
    var dataSource: ConnectUIConfiguration
    
    // MARK: Functions
    init(dataSource: ConnectUIConfiguration, showDismissButton: Bool = true) {
        self.dataSource = dataSource
        let bundle = Bundle(for: DisclosureViewController.self)
        super.init(nibName: DisclosureViewController.nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mainActionTapped() {
        // TODO: This is temporary and should probably be in the API class
        let breakdownDataSource = BreakdownDataSource(title: "Understand How Your Data is Used",
                                                      description: "Below is a breakdown of the data being gathered by this app and a description of how it is used.",
                                                      actionTitle: "Continue",
                                                      authMetrics: dataSource.authMetrics,
                                                      MetricCollections: dataSource.metricCollections)
        let breakdownController = DataBreakdownController(dataSource: breakdownDataSource)
        breakdownController.modalPresentationStyle = .fullScreen
        breakdownController.modalTransitionStyle = .crossDissolve
        if #available(iOS 13.0, *) { breakdownController.isModalInPresentation = true }
        self.navigationController?.pushViewController(breakdownController, animated: true)
    }
    
    func linkTapped() {
        guard let url = URL(string: dataSource.cardianUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewSetup() {
        super.viewSetup()
        headingLabel.text = dataSource.introductionHeader
        titleLabel1.text = dataSource.introductionTitle1
        descriptionLabel1.text = dataSource.introductionBody1
        titleLabel2.text = dataSource.introductionTitle2
        descriptionLabel2.text = dataSource.introductionBody2
        mainActionButton.setTitle(dataSource.introductionButtonLabel, for: .normal)
        CardianStyler.styleRoundedButton(button: mainActionButton)
    }
    
    // MARK: IBActions
    @IBAction func mainActionButtonTapped() { self.mainActionTapped() }
    @IBAction func linkButtonTapped() { self.linkTapped() }
}
