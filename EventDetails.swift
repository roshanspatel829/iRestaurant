


import UIKit
import CloudKit

class EventDetails: UIViewController {

    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var eventTxt: UITextView!
    @IBOutlet var eventDateLabel: UILabel!
    
    
    /* Variables */
    var eventObj = CKRecord(recordType: EVENTS_CLASS_NAME)
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    self.title = "Event Details"
    
    
    // Get Event details
    let imageFile = eventObj[EVENTS_IMAGE] as? CKAsset
    if imageFile != nil { eventImage.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
    
    eventNameLabel.text = "  \(eventObj[EVENTS_TITLE]!)"
    eventDateLabel.text = "  \(eventObj[EVENTS_DATE]!)"
    eventTxt.text = "\(eventObj[EVENTS_DESCRIPTION]!)"
    
    resetScrollView()
    
}

func resetScrollView() {
    eventTxt.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
    eventTxt.textColor = UIColor.whiteColor()
    eventTxt.sizeToFit()
        
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, eventTxt.frame.origin.y + eventTxt.frame.size.height + 50)
}
    
    
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
