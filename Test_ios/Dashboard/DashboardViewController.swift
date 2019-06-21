//
//  DashboardViewController.swift
//  Test_ios
//
//  Created udom on 20/6/2562 BE.
//  Copyright © 2562 udom Neakaew. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SwiftyJSON
import Alamofire
import Mapper

class DashboardViewController: UIViewController, DashboardViewProtocol {

    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var buyLabel: UILabel!
    @IBOutlet var sellLabel: UILabel!
    @IBOutlet var spotPriceLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet var viewTable: UIView!
    
    var presenter: DashboardPresenterProtocol?
    var viewController: UIViewController?
    var refreshControl: UIRefreshControl?
    var titleArray:[String] = Array()
    var textEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSpotPrice()
        addRefreshControl()
        setUpView()
    }
    
    func setUpView() {
        emailLabel.text = textEmail
        viewTable.setLayerView()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tblList.addSubview(refreshControl!)
    }
    
    @objc func refreshList() {
        fetchSpotPrice()
        refreshControl?.endRefreshing()
        tblList.reloadData()
    }
    
    @IBAction func backToRegister(_ sender: Any) {
        let myViewController = RegistersViewController(nibName: "RegistersViewController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
    }
    
    func fetchSpotPrice(){
        let url: String = "https://cws.hellogold.com/api/v2/spot_price.json"

        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    if let responseError = response.result.error {
                        print(responseError)
                    }
                    return
                }
                
                guard let json = response.result.value as? [String: Any] else {
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                if let dataJson = json["data"] as? [String: Any]  {
                    if let buy = dataJson["buy"],
                       let sell = dataJson["sell"],
                       let spot_price = dataJson["spot_price"],
                       let timestamp = dataJson["timestamp"] {
                        print("Buy is: \(buy)")
                        print("Sell is: \(sell)")
                        print("SpotPrice is: \(spot_price)")
                        print("Timestamp is: \(timestamp)")
                        
                        // Set Label to viewController
                        let buyNumber = buy as! NSNumber
                        let buyString : String = buyNumber.stringValue
                        self.buyLabel.text = buyString
                        
                        let sellNumber = sell as! NSNumber
                        let sellString : String = sellNumber.stringValue
                        self.sellLabel.text = sellString
                        
                        let spotPriceNumber = spot_price as! NSNumber
                        let spotPriceString : String = spotPriceNumber.stringValue
                        self.spotPriceLabel.text = spotPriceString
                        
                        self.timestampLabel.text = timestamp as? String ?? "Not Data!"
                        
                        self.titleArray.append(timestamp as! String)
                        self.tblList.tableFooterView = UIView.init(frame: .zero)
                        self.tblList.dataSource = self
                        self.tblList.reloadData()
                    }
                    return
                }
        }
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
        fetchSpotPrice()
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "listcell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "listcell")
        }
        cell?.textLabel?.text = titleArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name:"Courier New", size:15)
        return cell!
    }
}
