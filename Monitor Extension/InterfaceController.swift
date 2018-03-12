//
//  InterfaceController.swift
//  Monitor Extension
//
//  Created by Joss Manger on 3/11/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit
import Foundation

let polling:[CryptoTicker] = [.btc,.ltc,.eth]




class InterfaceController: WKInterfaceController {
    @IBOutlet var total: WKInterfaceLabel!
    
    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var ago: WKInterfaceTimer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        ago.setDate(Date.init())
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        table.setNumberOfRows(polling.count, withRowType: "Main")
        
        var count = 0;
        for item in polling {
            let row = self.table.rowController(at: count) as! TableItem
            row.currencyLabel.setText(item.stringValue())
            row.valueLabel.setText(item.stringValue())
            count+=1;
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

class TableItem : NSObject {
    
    @IBOutlet var currencyLabel: WKInterfaceLabel!
    @IBOutlet var valueLabel: WKInterfaceLabel!
    
    
}
