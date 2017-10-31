//
//  MsgImageDisplayViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 31/10/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

class MsgImageDisplayViewController: UIViewController {

    
    @IBOutlet weak var Image: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       let imgDataZoom = UserDefaults.standard.object(forKey: "imageZoom") as! NSData
        Image.image = UIImage(data: imgDataZoom as Data)
        
        //Image.frame = CGRect(x: 0, y: 0, width: UserDefaults.standard.float(forKey: "ImageZoomWidth"), height: UserDefaults.standard.float(forKey: "ImageZoomHeight"))
        
        //Image.frame = CGRect(x: 0, y: 0, width: UserDefaults.standard.object(forKey: "ImageZoomWidth") as! CGFloat,height: UserDefaults.standard.object(forKey: "ImageZoomHeight") as! CGFloat)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
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
