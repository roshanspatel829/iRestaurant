/*----------------------------------------

- China King -

Created by FV iMAGINATION ©2015.
All rights reserved.

------------------------------------------*/

import Foundation
import UIKit
import CloudKit



// Change the red string below accordingly to the new name you'll give to this app
let APP_NAME = "iRestaurant"


// COLORS
let brownLight = UIColor(red: 198.0/255.0, green: 156.0/255.0, blue: 109.0/255.0, alpha: 1.0)
let brownDark = UIColor(red: 54.0/255.0, green: 47/255.0, blue: 45/255.0, alpha: 1.0)


// EMAIL ADDRESSES TO EDIT
let MY_CONTACT_EMAIL_ADDRESS = "patelr11@students.ecu.edu"
let MY_RESERVATION_EMAIL_ADDRESS = "roshans.patel6@gmail.com"



// IMPORTANT: REPLACE THE RED STRING BELOW WITH THE APP ID YOU CAN GRAB FROM YOUR OneSignal DASHBOARD -> App Settings
// THIS IS TO ALLOW YOU TO SEND PUSH NOTIFICATIONS TO ALL REGISTERED USERS
let ONESIGNAL_APP_ID = "0f3bc961-87d9-47e5-b272-cebdf90c168e"



// HUD VIEW (customizable by editing the code below)
var hudView = UIView(frame: CGRectMake(0, 0, 80, 80))
var indicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
extension UIViewController {
    func showHUD() {
        hudView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        hudView.backgroundColor = brownDark
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        indicatorView.center = CGPointMake(hudView.frame.size.width/2, hudView.frame.size.height/2)
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        hudView.addSubview(indicatorView)
        view.addSubview(hudView)
        indicatorView.startAnimating()
    }
    
    func hideHUD() {  hudView.removeFromSuperview()  }
    
    func simpleAlert(mess:String) {
        UIAlertView(title: APP_NAME, message: mess, delegate: nil, cancelButtonTitle: "OK").show()
    }
}






/*********** DON'T EDIT THE FOLLOWING VARIABLES!! *************/
let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase


// RESTAURANT CLASS
var RESTAURANT_CLASS_NAME = "Restaurant"
var RESTAURANT_NAME = "name"
var RESTAURANT_DESCRIPTION = "description"
var RESTAURANT_ADDRESS = "address"
var RESTAURANT_PHONE = "phone"
var RESTAURANT_WEBSITE = "website"
var RESTAURANT_LOGO = "logo"
var RESTAURANT_COVER_IMAGE = "coverImage"
var RESTAURANT_FACEBOOK = "facebook"
var RESTAURANT_TWITTER = "twitter"
var RESTAURANT_TRIPADVISOR = "tripadvisor"
var RESTAURANT_INSTAGRAM = "instagram"

// MENU CLASS
var MENU_CLASS_NAME = "Menu"
var MENU_NAME = "name"
var MENU_IMAGE = "image"
var MENU_DESCRIPTION = "description"
var MENU_PRICE = "price"

// EVENTS CLASS
var EVENTS_CLASS_NAME = "Events"
var EVENTS_TITLE = "title"
var EVENTS_DATE = "date"
var EVENTS_IMAGE = "image"
var EVENTS_DESCRIPTION = "description"

// GALLERY CLASS
var GALLERY_CLASS_NAME = "Gallery"
var GALLERY_TITLE = "title"
var GALLERY_IMAGE = "image"


//===========================================================

