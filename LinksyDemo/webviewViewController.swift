//
//  webviewViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 14/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

class webviewViewController: UIViewController {
    
    @IBOutlet weak var WebView: UIWebView!
    
    
    
    
    //var url1 = NSURL(string:"https://www.linkedin.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        
       //WebView.loadRequest(NSURLRequest(url: url1! as URL) as URLRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
