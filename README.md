# Cryptarch - Bitcoin Investment Monitor

iOS App for tracking individual bitcoin/crypto investments.

Swift

# Features
* Add/Remove and track investments vs. the current bitcoin price
* Edit Screen using `commit editingStyle`, passing CD Object to 'new' VC.
* Spring animated Pie views that show how much money you've lost.
* Allows other cryptocurrency buys to be tracked. e.g BCH, LTC, ETH. Rates from Coinbase
* UITableView sections
* Pull to refresh
* Alert view on price fetch fail
* Persistent local storage with CoreData
* Managed Persistant datastore + tableview.
* `CoreGraphics` drawing arrows indicating changes in price
* WatchKit App showing current value of holdings
* Landscape layout.

## TODO
* Work on Cell view.
* System currency 
* Over double to result in a blue circle in PieView
* Size classes for iPad layout
* `heightForRowAtIndexPath:`  or `isExpanded` - tap for detail instead of full view. 
* Refactor model to use `struct`. 
* Timeout and other error handling for Pull To Refresh
* Streamline processes. DRY.
* Refactor returned JSON code using `Codeable` class.
* Refactor add screen. Less lame.
* Clear out all old code - partially complete

## Nice to have
* Complication placeholder for AW.
* Better AW Interface.
* more `UITableView` methods. Reorder
* Comparitive rates
### Techniques Used
* Parsing JSON with Swift
* NSURLSession to get current prices
* Async fetching of crypto prices using `DispatchGroup` with callback on complete
* Persistent storange with `NSFetchedResultsController` integration adapted from Apple boilerplate code.
* UITableView + UITableVIewCell Subclasses

#### Frameworks Used
`UIKit`
`CoreData`
`NSURLSession`
`CoreGraphics`
