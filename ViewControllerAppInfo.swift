//
//  ViewControllerDetails.swift
//  Chinese Cuisine Review
//
//  Used to display information about this app 
//  using a local HTML file and stylesheet.
//

import UIKit

class ViewControllerAppInfo: UIViewController {
    
    // Primary web view.
    @IBOutlet weak var webViewPrimary: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let filePath = NSBundle.mainBundle().URLForResource("info", withExtension: "html")
        let request = NSURLRequest(URL: filePath!)
        webViewPrimary.loadRequest(request)
                        
    }
    
}
