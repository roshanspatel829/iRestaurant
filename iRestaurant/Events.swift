import UIKit
import CloudKit


class Events: UIViewController {

    /* Views */
    @IBOutlet var eventsTableView: UITableView!
    
    
    /* Variables */
    var eventsArray = NSMutableArray()
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    queryEvents()
}


// MARK: - QUERY EVENTS
func queryEvents() {
    showHUD()
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: EVENTS_CLASS_NAME, predicate: predicate)
    let sort = NSSortDescriptor(key: "creationDate", ascending: false)
    query.sortDescriptors = [sort]
    
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error == nil { dispatch_async(dispatch_get_main_queue()) {
            self.eventsArray = NSMutableArray(array: results!)
            self.eventsTableView.reloadData()
            self.hideHUD()
        // Error
        }} else { dispatch_async(dispatch_get_main_queue()) {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    } } }

}
    
    
    
    
// MARK: - TABLEVIEW DELEGATES
func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
}
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventsArray.count
}
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
    
    let eventsClass = eventsArray[indexPath.row] as! CKRecord
    
    // Get image
    let imageFile = eventsClass[EVENTS_IMAGE] as? CKAsset
    if imageFile != nil { cell.eventImage.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
    
    
    cell.eventNameLabel.text = "\(eventsClass[EVENTS_TITLE]!)"
    cell.dateLabel.text = "\(eventsClass[EVENTS_DATE]!)"
    
    
return cell
}

func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 136
}

    
// MARK: - CELL HAS BEEN TAPPED -> SHOW EVENT DETAILS
func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let eventsClass = eventsArray[indexPath.row] as! CKRecord
    
    let edVC = storyboard?.instantiateViewControllerWithIdentifier("EventDetails") as! EventDetails
    edVC.eventObj = eventsClass
    navigationController?.pushViewController(edVC, animated: true)
}

    
    
// MRK: - REFRESH BUTTON
@IBAction func refreshButt(sender: AnyObject) {
    queryEvents()
}
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
