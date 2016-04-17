
import UIKit
import CloudKit


class Gallery: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
{
    
    /* Views */
    @IBOutlet var galleryCollView: UICollectionView!
    
    @IBOutlet var imagePreviewView: UIView!
    @IBOutlet var imgScrollView: UIScrollView!
    @IBOutlet var imgPrev: UIImageView!
    
    
    /* Variables */
    var galleryArray = NSMutableArray()
    
    
    
    

override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePreviewView.frame = CGRectMake(0, 0, 0, 0)
    
    queryGallery()
}
 
func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imgPrev
}
    
    
// MARK: - QUERY GALLERY DATA FROM PARSE DATABASE
func queryGallery() {
    showHUD()
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: GALLERY_CLASS_NAME, predicate: predicate)
    let sort = NSSortDescriptor(key: "creationDate", ascending: false)
    query.sortDescriptors = [sort]
    
    publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
        if error == nil { dispatch_async(dispatch_get_main_queue()) {
            self.galleryArray = NSMutableArray(array: results!)
            self.galleryCollView.reloadData()
            self.hideHUD()
        // Error
        }} else { dispatch_async(dispatch_get_main_queue()) {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    } } }
    
}
    
    
    
    
// MARK: - COLLECTION VIEW DELEGATES
func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}
func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return galleryArray.count
}
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCell
    
    let galleryClass = galleryArray[indexPath.row] as! CKRecord
    
    // Get Title
    if galleryClass[GALLERY_TITLE] != nil {
        cell.titleLabel.hidden = false
        cell.titleLabel.text = "\(galleryClass[GALLERY_TITLE]!)"
    } else {
        cell.titleLabel.hidden = true
    }
    
    
    // Get image
    let imageFile = galleryClass[GALLERY_IMAGE] as? CKAsset
    if imageFile != nil { cell.galImage.image = UIImage(contentsOfFile: imageFile!.fileURL.path!) }
    cell.galImage.layer.borderColor = UIColor.blackColor().CGColor
    cell.galImage.layer.borderWidth = 1
    
    
return cell
}
    
func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(view.frame.size.width/3, view.frame.size.width/3)
}
    
// MARK: - IMAGE TAPPED
func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let galleryClass = galleryArray[indexPath.row] as! CKRecord
    
    let imageFile = galleryClass[GALLERY_IMAGE] as? CKAsset
    if imageFile != nil {
        imgPrev.image = UIImage(contentsOfFile: imageFile!.fileURL.path!)
        self.showImagePrevView()
    }
}
    
    
    
// MARK: - SHOW/HIDE PREVIEW IMAGE VIEW
func showImagePrevView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
    self.imagePreviewView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    }, completion: { (finished: Bool) in  })
}
func hideImagePrevView() {
    imgPrev.image = nil
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
    self.imagePreviewView.frame = CGRectMake(0, 0, 0, 0)
    }, completion: { (finished: Bool) in  })
}
    
    
    
// MARK: - TAP ON IMAGE TO CLOSE PREVIEW
    @IBAction func tapToClosePreview(sender: UITapGestureRecognizer) {
    hideImagePrevView()
}
    

// MARK: - BACK BUTTON
@IBAction func backButt(sender: AnyObject) {
   dismissViewControllerAnimated(true, completion: nil)
}

    
    
 
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}