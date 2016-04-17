


import UIKit
import CloudKit
import MapKit


class Location: UIViewController,
MKMapViewDelegate
{

    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneTxt: UITextView!
    @IBOutlet var websiteTxt: UITextView!
    
    @IBOutlet var socialButtons: [UIButton]!
    
    
    /* Variables */
    var restArray = NSMutableArray()
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!

    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 550)
    mapView.delegate = self
    
    
    // Init Social Buttons
    for butt in socialButtons {
        butt.addTarget(self, action: #selector(socialButtTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    queryRestDetails()
}

    
    
// MARK: - QUERY RESTAURANT DETAILS
func queryRestDetails() {
    showHUD()
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: RESTAURANT_CLASS_NAME, predicate: predicate)
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error == nil { dispatch_async(dispatch_get_main_queue()) {
            self.restArray = NSMutableArray(array: results!)
            self.showDetails()
            self.hideHUD()
        // Error
        }} else { dispatch_async(dispatch_get_main_queue()) {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    } } }
}
 

func showDetails() {
    let restClass = restArray[0] as! CKRecord
        
    // Show location on MapView
    let addressStr = "\(restClass[RESTAURANT_ADDRESS]!)"
    addPinOnMap(addressStr)
    
    addressLabel.text = addressStr
    
    // Check if Phone and Website data exist
    if restClass[RESTAURANT_PHONE] != nil {  phoneTxt.text = "\(restClass[RESTAURANT_PHONE]!)"
    } else { phoneTxt.text = ""}
    
    if restClass[RESTAURANT_WEBSITE] != nil { websiteTxt.text = "\(restClass[RESTAURANT_WEBSITE]!)"
    } else { websiteTxt.text = "Under Construction"}
}
    
    
    
// MARK: -  ADD A PIN ON THE MAP
func addPinOnMap(address: String) {
        let restClass = restArray[0] as! CKRecord
        
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0] 
            mapView.removeAnnotation(annotation)
        }
        // Make a search on the Map
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            // Add PointAnnonation text and a Pin to the Map
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = "\(restClass[RESTAURANT_NAME]!)"
            self.pointAnnotation.coordinate = CLLocationCoordinate2D( latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinView.annotation!)
            
            // Zoom the Map to the location
            self.region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, 1000, 1000);
            self.mapView.setRegion(self.region, animated: true)
            self.mapView.regionThatFits(self.region)
            self.mapView.reloadInputViews()
        }
    
}

 
    
// MARK: - CUSTOMIZE PIN ANNOTATION
func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
    // Handle custom annotations.
    if annotation.isKindOfClass(MKPointAnnotation) {
            
        // Try to dequeue an existing pin view first.
        let reuseID = "CustomPinAnnotationView"
        var annotView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
            
        if annotView == nil {
            annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotView!.canShowCallout = true
            
            
            // Custom Pin image
            let imageView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
    
            let restClass = restArray[0] as! CKRecord
            let imageFile = restClass[RESTAURANT_LOGO] as? CKAsset
            if imageFile != nil { imageView.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor.darkGrayColor()
            imageView.layer.cornerRadius = imageView.bounds.size.width/2
            imageView.layer.borderColor = UIColor.darkGrayColor().CGColor
            imageView.layer.borderWidth = 1
            imageView.center = annotView!.center
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            annotView!.addSubview(imageView)
            
            
            // Add a RIGHT CALLOUT Accessory
            let rightButton = UIButton(type: UIButtonType.Custom)
            rightButton.frame = CGRectMake(0, 0, 32, 32)
            rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
            rightButton.clipsToBounds = true
            rightButton.setImage(UIImage(named: "openInMaps"), forState: UIControlState.Normal)
            annotView!.rightCalloutAccessoryView = rightButton
        }
        return annotView
    }
    
    
return nil
}
    
    
// OPEN THE NATIVE iOS MAPS APP
func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    annotation = view.annotation
    let coordinate = annotation.coordinate
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
    let mapitem = MKMapItem(placemark: placemark)
    mapitem.name = annotation.title!
    mapitem.openInMapsWithLaunchOptions(nil)
}

    
    
    
    
// SOCIAL BUTTON TAPPED
func socialButtTapped(sender: UIButton) {
    var urlStr = ""
    
    let restClass = restArray[0] as! CKRecord
        
    switch sender.tag {
        case 0:
            if restClass[RESTAURANT_FACEBOOK] != nil { urlStr = "\(restClass[RESTAURANT_FACEBOOK]!)" }
        case 1:
            if restClass[RESTAURANT_TWITTER] != nil  { urlStr = "\(restClass[RESTAURANT_TWITTER]!)" }
        case 2:
            if restClass[RESTAURANT_TRIPADVISOR] != nil { urlStr = "\(restClass[RESTAURANT_TRIPADVISOR]!)"  }
        case 3:
            if restClass[RESTAURANT_INSTAGRAM] != nil { urlStr = "\(restClass[RESTAURANT_INSTAGRAM]!)"    }
    
    default:break  }
        
    let socialURL = NSURL(string: urlStr)
    UIApplication.sharedApplication().openURL(socialURL!)
}


    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
