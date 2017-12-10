//
//  TableViewController.swift
//  BitcoinInvestmentMonitor
//
//  Created by Joss Manger on 12/7/17.
//  Copyright © 2017 Joss Manger. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,BTCPriceDelegate,BTCManagerDelegate {

    let btcPriceMonitor:BTCPriceModel = BTCPriceModel()
    let btcManager:CDBTCManager = CDBTCManager()
    var refresh:UIRefreshControl?
    
    var currentItems:[Buy] = []
    var formerItems:[Buy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btcPriceMonitor.delegate = self
        btcManager.delegate = self
        btcPriceMonitor.getUpdateBitcoinPrice()
        btcManager.initEntity()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.title = "My Bitcoin"
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let point = CGPoint(x: tableView.frame.origin.x, y: tableView.frame.origin.y)
        refresh = UIRefreshControl(frame: CGRect(origin: point, size: CGSize(width: tableView.frame.width, height: 32.0)))
        
        refresh!.addTarget(self, action: #selector(handlePullToRefresh), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refresh
    }

    @objc func handlePullToRefresh(_ sender:UIRefreshControl){
        sender.beginRefreshing()
        btcPriceMonitor.getUpdateBitcoinPrice()
    }
    
    
    
    func updatedPrice() {
        print("notified price update")
        print(btcPriceMonitor.btcRate)
         DispatchQueue.main.async {
            
            //reload data is fine, not adding or removing in this transaction
            self.tableView.reloadData()
            if let refresh = self.refresh {
                refresh.endRefreshing()
            }
        }
    }
    
    func updateTableItems(){
        formerItems = currentItems
        currentItems = btcManager.fetchedBuys
        var indexPaths:[IndexPath] = []
        
        if(currentItems.count>formerItems.count){
            tableView.beginUpdates()
            for value in formerItems.count..<currentItems.count{
                let indexpath = IndexPath(row: value, section: 0)
                indexPaths.append(indexpath)
            }
 tableView.insertRows(at: indexPaths, with: .right)
             tableView.endUpdates()
        }
         //else if (currentItems.count<formerItems.count) {
//
//            for value in (currentItems.count..<formerItems.count).reversed(){
//                let indexpath = IndexPath(row: value, section: 0)
//                indexPaths.append(indexpath)
//            }
//            tableView.deleteRows(at: indexPaths, with: .automatic)
//        }
        
        
       
    }
    
    func displayError() {
        let error = UIAlertController(title: "Error refreshing price", message: "Please try again later...", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        error.addAction(action)
        self.present(error, animated: true, completion: {() in
            self.refresh?.endRefreshing()
        })
    }
    
    func updatedCore() {
        
        //old set vs new, bulk update
        updateTableItems()
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "addSegue":
            let vc = segue.destination as! ViewController
            vc.tableViewParent = self
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return btcManager.fetchedBuys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "btcbuy", for: indexPath) as! BTCBuyTableCell
        
        let labelDict = btcPriceMonitor.processInfo(buy: currentItems[indexPath.row])
    
         cell.btcAmountLabel.text = labelDict["buy"]
         cell.dateLabel.text = labelDict["date"]
         cell.btcRateAtBuyLabel.text = labelDict["rateAtBuy"]
         cell.usdAtBuyLabel.text = "$"+(labelDict["priceAtBuy"] ?? "missing")
         cell.currentRateLabel.text = labelDict["currentRate"]
         
        cell.currentPriceLabel.text = "$"+(labelDict["currentPrice"] ?? "missing")
        cell.appreciationLabel.text = (labelDict["direction"] == "up") ? "+"+labelDict["appreciation"]! : "-"+labelDict["appreciation"]!
        cell.appreciationLabel.textColor = (labelDict["direction"] == "up") ? UIColor.green : UIColor.red
         
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218.0
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return [.insert
//    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            btcManager.clearCore(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            btcManager.commitToCore(buyInfo: ViewController.defaultSettings())
            
        }    
    }
 

    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
