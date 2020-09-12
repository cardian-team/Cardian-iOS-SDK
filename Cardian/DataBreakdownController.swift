//
//  DataBreakdownController.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import UIKit

struct BreakdownDataSource {
    let title: String
    let description: String
    let actionTitle: String
    let MetricCollections: [MetricCollection]
}

class DataBreakdownController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainActionButton: UIButton!
    
    // MARK: Constants
    public static let nibName = "DataBreakdownController"
//    private static let defaultImage = UIImage(named: "HeartBubble", in: Bundle.main, compatibleWith: nil)!
    private let cellReuseIdentifier = "BreakdownCell"
    
    // MARK: Variables
    var dataSource: BreakdownDataSource

    // MARK: Functions
    init(dataSource: BreakdownDataSource, showDismissButton: Bool = true) {
        self.dataSource = dataSource
        super.init(nibName: DataBreakdownController.nibName, bundle: nil)
        
//        self.iconImage.image = icon
//        self.dismissButton.isHidden = !showDismissButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }
    
    override func viewSetup() {
        super.viewSetup()
        headingLabel.text = dataSource.title
        descriptionLabel.text = dataSource.description
        mainActionButton.setTitle(dataSource.actionTitle, for: .normal)
        CardianStyler.styleRoundedButton(button: mainActionButton)
    }
    
    func mainActionTapped() {
        // TODO: To be implemented
    }
    
    // MARK: TableView
    
    func tableViewSetup() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.MetricCollections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.MetricCollections[section].metrics.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.MetricCollections[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if dataSource.MetricCollections[indexPath.section].metrics[indexPath.row].description != nil {
            cell.accessoryType = .disclosureIndicator
        }
        
        let metricTitle = dataSource.MetricCollections[indexPath.section].metrics[indexPath.row].displayName
        cell.textLabel?.text = metricTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let metricDescription = dataSource.MetricCollections[indexPath.section].metrics[indexPath.row].description else { return }
        // TODO: Description view should be presented here...
        print("Selected metric description: \(metricDescription)")
    }
    
    // MARK: IBActions
    @IBAction func mainActionButtonTapped() { self.mainActionTapped() }
}
