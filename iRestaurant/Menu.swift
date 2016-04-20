import UIKit
import CloudKit


class Menu: UIViewController,
UITableViewDataSource,
UITableViewDelegate
{

    /* Views */
    @IBOutlet var menuTableView: UITableView!
    
    
    
    /* Variables */
    var menuArray = NSMutableArray()
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    queryMenu()
}

    
// MARK: - QUERY MENU FROM PARSE DATABASE
func queryMenu() {
    showHUD()
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: MENU_CLASS_NAME, predicate: predicate)
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error == nil { dispatch_async(dispatch_get_main_queue()) {
            self.menuArray = NSMutableArray(array: results!)
            self.menuTableView.reloadData()
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
    return menuArray.count
}
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
   
    let menuClass = menuArray[indexPath.row] as! CKRecord
    
    cell.nameLabel.text = "\(menuClass[MENU_NAME]!)"
    cell.descrLabel.text = "\(menuClass[MENU_DESCRIPTION]!)"
    cell.priceLabel.text = "\(menuClass[MENU_PRICE]!)"
    
    // Get image
    let imageFile = menuClass[MENU_IMAGE] as? CKAsset
    if imageFile != nil { cell.menuImage.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
    cell.menuImage.layer.cornerRadius = 12
    
    
return cell
}
func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 136
}

// CELL HAS BEEN TAPPED
func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
}


    
    
// MARK: - REFRESH MENU BUTTON
@IBAction func refreshButt(sender: AnyObject) {
    queryMenu()
}
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}