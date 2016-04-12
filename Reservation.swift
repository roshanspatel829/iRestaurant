
import UIKit
import CloudKit
import MessageUI


class Reservation: UIViewController,
UITextFieldDelegate,
MFMailComposeViewControllerDelegate
{

    /* Views */
    @IBOutlet var bkgImage: UIImageView!
    @IBOutlet var containerScrollView: UIScrollView!
    
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var peopleNrTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    @IBOutlet var dateOutlet: UIButton!
    
    @IBOutlet var reservationOutlet: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    
    /* Variables */
    var restArray = NSMutableArray()
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Setup views
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 780)
    reservationOutlet.layer.cornerRadius = 6
    
    // Round views corners
    nameTxt.layer.cornerRadius = 5
    peopleNrTxt.layer.cornerRadius = 5
    phoneTxt.layer.cornerRadius = 5
    dateOutlet.layer.cornerRadius = 5
    
    
    // Setup datePicker
    datePicker.frame.origin.y = view.frame.size.height
    datePicker.addTarget(self, action: #selector(dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    datePicker.backgroundColor = brownLight
    
    // Query to get the Restaurant cover image
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: RESTAURANT_CLASS_NAME, predicate: predicate)
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error == nil { dispatch_async(dispatch_get_main_queue()) {
            self.restArray = NSMutableArray(array: results!)
            self.showBkgImage()
        // Error
        }} else { dispatch_async(dispatch_get_main_queue()) {
            self.simpleAlert("\(error!.localizedDescription)")
    } } }

}

func showBkgImage() {
    let restClass = restArray[0] as! CKRecord
        
    // Get image
    let imageFile = restClass[RESTAURANT_COVER_IMAGE] as? CKAsset
    if imageFile != nil { bkgImage.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
}
   
    
    
// MARK: - TEXTFIELD DELEGATES
func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == nameTxt { peopleNrTxt.becomeFirstResponder()  }
    if textField == peopleNrTxt { phoneTxt.becomeFirstResponder()  }
    if textField == phoneTxt { phoneTxt.resignFirstResponder()  }

return true
}
    
    
// MARK: - DATE & TIME BUTTON
@IBAction func dateButt(sender: AnyObject) {
    showDatePicker()
}
    
    
// DATE PICKER CHANGED VALUE
func dateChanged(datePicker: UIDatePicker) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy - HH:mm"
    let dateStr = dateFormatter.stringFromDate(datePicker.date)
    dateOutlet.setTitle(dateStr, forState: UIControlState.Normal)
    
    nameTxt.resignFirstResponder()
    peopleNrTxt.resignFirstResponder()
    phoneTxt.resignFirstResponder()
}

    
// TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(sender: UITapGestureRecognizer) {
    dismissKeyb()
}
   
func dismissKeyb() {
    nameTxt.resignFirstResponder()
    peopleNrTxt.resignFirstResponder()
    phoneTxt.resignFirstResponder()
    hideDatePicker()
}

    
// SHOW/HIDE DATE PICKER
func showDatePicker() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.datePicker.frame.origin.y = self.view.frame.size.height - self.datePicker.frame.size.height - 44
    }, completion: { (finished: Bool) in  })
}
func hideDatePicker() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.datePicker.frame.origin.y = self.view.frame.size.height
    }, completion: { (finished: Bool) in  })
}

    
    
// ONLINE RESERVATION BUTTON
@IBAction func reservationButt(sender: AnyObject) {
    dismissKeyb()
    
    // This string containes standard HTML tags, you can edit them as you wish
    let messageStr = "<font size = '1' color= '#222222' style = 'font-family: 'HelveticaNeue'>Hello,<br>I would like to book a Table <br>On: <strong>\(dateOutlet.titleLabel!.text!)</strong> <br>For <strong>\(peopleNrTxt.text!) people</strong>. <br><br>Name: <strong>\(nameTxt.text!)</strong> <br>Phone: <strong>\(phoneTxt.text!)</strong><br> <br>Thank you,<br>Regards.</font>"
    
    let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject("RESERVATION REQUEST")
    mailComposer.setMessageBody(messageStr, isHTML: true)
    mailComposer.setToRecipients([MY_RESERVATION_EMAIL_ADDRESS])

    if MFMailComposeViewController.canSendMail() {
        presentViewController(mailComposer, animated: true, completion: nil)
    } else {
        self.simpleAlert("Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.")
    }

}
// Email delegate
func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        
        var resultMess = ""
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            resultMess = "Mail cancelled"
        case MFMailComposeResultSaved.rawValue:
            resultMess = "Mail saved"
        case MFMailComposeResultSent.rawValue:
            resultMess = "Thanks for making a reservation, we will get back to you asap!"
        case MFMailComposeResultFailed.rawValue:
            resultMess = "Something went wrong with sending Mail, try again later."
        default:break
        }
        
        // Show email result alert
        self.simpleAlert(resultMess)
        
        dismissViewControllerAnimated(false, completion: nil)
}

    
    
    
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
