//
//  DisclosureViewController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/12/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

struct DisclosureDataSource {
    let heading: String
    let title1: String
    let description1: String
    let title2: String
    let description2: String
    let actionTitle: String
    let agreementLink: String
}

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
    var dataSource: DisclosureDataSource
    
    // MARK: Functions
    init(dataSource: DisclosureDataSource, showDismissButton: Bool = true) {
        self.dataSource = dataSource
        super.init(nibName: DisclosureViewController.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mainActionTapped() {
        // TODO: Get Data Breakdown Controller data, the following data source is temporary
        
        let heightMetric = Metric(name: "height", displayName: "Height", type: "quantity", description: "This is your height.")
        let weightMetric = Metric(name: "weight", displayName: "Weight", type: "quantity", description: "This is your weignt.")
        let heartRateMetric = Metric(name: "heartrate", displayName: "Heart Rate", type: "quantity", description: "This is your heart rate.")
        let bodyTemperatureMetric = Metric(name: "bodytemp", displayName: "Body Temperature", type: "quantity", description: "This is your body temperature.")
        let sleepCountMetric = Metric(name: "sleepcount", displayName: "Sleep Count", type: "quantity", description: "This is your sleep count.")
        let stepCountMetric = Metric(name: "stepcount", displayName: "Step Count", type: "quantity", description: "This is your step count.")

        let metricCollection = MetricCollection(name: "Body Measurements", metrics: [heightMetric, weightMetric, heartRateMetric, bodyTemperatureMetric])
        let metricCollection2 = MetricCollection(name: "Advanced Measurements", metrics: [sleepCountMetric, stepCountMetric])
        let tempDataSource = BreakdownDataSource(title: "Understand How Your Data is Used", description: "Below is the breakdown of the data being used by this app and a description of how it's being used.", actionTitle: "Continue", MetricCollections: [metricCollection, metricCollection2])
        
        let breakdownController = DataBreakdownController(dataSource: tempDataSource)
        self.present(breakdownController, animated: true, completion: nil)
    }
    
    func linkTapped() {
        guard let url = URL(string: dataSource.agreementLink) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewSetup() {
        super.viewSetup()
        headingLabel.text = dataSource.heading
        titleLabel1.text = dataSource.title1
        descriptionLabel1.text = dataSource.description1
        titleLabel2.text = dataSource.title2
        descriptionLabel2.text = dataSource.description2
        mainActionButton.setTitle(dataSource.actionTitle, for: .normal)
        CardianStyler.styleRoundedButton(button: mainActionButton)
    }
    
    // MARK: IBActions
    @IBAction func mainActionButtonTapped() { self.mainActionTapped() }
    @IBAction func linkButtonTapped() { self.linkTapped() }
}
