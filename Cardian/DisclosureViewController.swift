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
    var currentConfiguration: CardianConfiguration
    
    // MARK: Functions
    init(currentConfiguration: CardianConfiguration, showDismissButton: Bool = true) {
        self.currentConfiguration = currentConfiguration
        
        let podBundle = Bundle(path: Bundle(for: DisclosureViewController.self).path(forResource: "Cardian", ofType: "bundle")!)
        
        //let bundle = Bundle(for: DisclosureViewController.self)
        super.init(nibName: DisclosureViewController.nibName, bundle: podBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mainActionTapped() {
        // TODO make this group by the proper things
        var readMetrics: [Metric] = []
        var writeMetrics: [Metric] = []
        for (currentMetric) in currentConfiguration.metrics {
            if (currentMetric.mode > 0) {
                readMetrics.append(currentMetric)
            }
            
            if (currentMetric.mode == 2) {
                writeMetrics.append(currentMetric)
            }
        }
        let readMetricsCollection = MetricCollection(name: "Readable Metrics", metrics: readMetrics)
        let writeMetricColleciton = MetricCollection(name: "Writeable", metrics: writeMetrics)
        let authMetrics = AuthMetrics(read: readMetrics, write: writeMetrics)
        
        // TODO: This is temporary and should probably be in the API class
        let breakdownCurrentConfiguration = BreakdownDataSource(title: "Understand How Your Data is Used",
                                                      description: "Below is a breakdown of the data being gathered by this app and a description of how it is used.",
                                                      actionTitle: "Continue",
                                                      authMetrics: authMetrics,
                                                      MetricCollections: [readMetricsCollection, writeMetricColleciton])
        let breakdownController = DataBreakdownController(dataSource: breakdownCurrentConfiguration)
        breakdownController.modalPresentationStyle = .fullScreen
        breakdownController.modalTransitionStyle = .crossDissolve
        if #available(iOS 13.0, *) { breakdownController.isModalInPresentation = true }
        self.navigationController?.pushViewController(breakdownController, animated: true)
    }
    
    func linkTapped() {
        guard let url = URL(string: currentConfiguration.connectUi.cardianUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageLoader = ImageLoader()
        guard let config = CardianApp.getConfiguration() else {
            print("TODO HANDLE THIS ERROR")
            return
            
        }
        
        imageLoader.loadImage(url: URL(string: config.connectUi.iconUrl)!) { (image, error) in
            guard error == nil else {
                print("ERROR: Problem getting icon url")
                return
            }
            guard let image = image else {
                return
            }
            self.iconImage.image = image
        }
        
    }
    
    override func viewSetup() {
        super.viewSetup()
        headingLabel.text = "\(currentConfiguration.connectUi.appName) uses Cardian to connect to Apple Health"
        titleLabel1.text = currentConfiguration.connectUi.views.introduction.title1
        descriptionLabel1.text = currentConfiguration.connectUi.views.introduction.body1
        titleLabel2.text = currentConfiguration.connectUi.views.introduction.title2
        descriptionLabel2.text = currentConfiguration.connectUi.views.introduction.body2
        iconImage.layer.cornerRadius = 10
        iconImage.clipsToBounds = true
        mainActionButton.setTitle(currentConfiguration.connectUi.views.introduction.buttonLabel, for: .normal)
        CardianStyler.styleRoundedButton(button: mainActionButton)
    }
    
    // MARK: IBActions
    @IBAction func mainActionButtonTapped() { self.mainActionTapped() }
    @IBAction func linkButtonTapped() { self.linkTapped() }
}
