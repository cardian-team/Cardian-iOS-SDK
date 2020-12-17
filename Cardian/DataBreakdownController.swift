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
    let authMetrics: AuthMetrics
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
        let bundle = Bundle(for: DataBreakdownController.self)
        super.init(nibName: DataBreakdownController.nibName, bundle: bundle)
        
//        self.iconImage.image = icon
//        self.dismissButton.isHidden = !showDismissButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        tableView.reloadData()
    }
    
    override func viewSetup() {
        super.viewSetup()
        headingLabel.text = dataSource.title
        descriptionLabel.text = dataSource.description
        mainActionButton.setTitle(dataSource.actionTitle, for: .normal)
        CardianStyler.styleRoundedButton(button: mainActionButton)
    }
    
    func mainActionTapped() {
        AuthManager.authorize(authMetrics: dataSource.authMetrics) { (success, error) in
            guard error == nil else {
                print("ERROR: could not authorize with HealthKit: \(error!.localizedDescription)")
                return
            }
            print("Successfully authorized with HealthKit")
            CardianApp.updateVersionsConnected()
            DispatchQueue.main.async {
                let confirmationController = ConfirmationController()
                confirmationController.modalPresentationStyle = .fullScreen
                confirmationController.modalTransitionStyle = .crossDissolve
                if #available(iOS 13.0, *) { confirmationController.isModalInPresentation = true }
                self.navigationController?.pushViewController(confirmationController, animated: true)
            }
        }
    }
    
    // MARK: TableView
    func tableViewSetup() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self

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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50 // TODO: No random numbers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        if dataSource.MetricCollections[indexPath.section].metrics[indexPath.row].usage_description != nil {
            cell.accessoryType = .disclosureIndicator
        }
        
        let metricTitle = dataSource.MetricCollections[indexPath.section].metrics[indexPath.row].label
        cell.textLabel?.text = metricTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let metric = dataSource.MetricCollections[indexPath.section].metrics[indexPath.row]
        guard let metricDescription = metric.usage_description else { return }
        let dataSource = MetricDescriptionDataSource(title: metric.label, description: metricDescription, privacyLink: "https://cardian.io") // TODO: This is temporary obviously
        let descriptionController = MetricDescriptionController(dataSource: dataSource)
        self.navigationController?.pushViewController(descriptionController, animated: true)
        print("Selected metric description: \(metricDescription)")
    }
    
    // MARK: IBActions
    @IBAction func mainActionButtonTapped() { self.mainActionTapped() }
}
