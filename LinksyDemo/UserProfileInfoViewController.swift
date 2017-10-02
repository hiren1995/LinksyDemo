//
//  UserProfileInfoViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 27/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class UserProfileInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet weak var userProfileinfoCollectionView: UICollectionView!
    
    @IBOutlet weak var labelSummary: UITextView!
    
    
    @IBOutlet weak var labelUseName: UILabel!
    
    @IBOutlet weak var labelPosInfo: UITextView!
    
    var userposition = ["Chairman and CEO Netflix"]
    
    var userduration = ["Oct 1997- Present"]
    
   
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var btnLinkedinUpdate: UIButton!
    
    
    @IBOutlet weak var labelCity: UILabel!
    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"

    
    var usercompanydescription = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Ut enim ad minim veniam, quis nostrud exercitation ullamco "]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
        
        userProfileinfoCollectionView.delegate = self
        userProfileinfoCollectionView.dataSource = self
        
        btnUpdate.addTarget(self, action: #selector(updateinfo), for: .touchUpInside)
        btnLinkedinUpdate.addTarget(self, action: #selector(updateinfo), for: .touchUpInside)
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            print(tempdata)
            
            labelPosInfo.text = tempdata["linkedin_login"][0]["headline"].string
            
            labelSummary.text = tempdata["linkedin_login"][0]["summary"].string
            
            labelUseName.text = tempdata["linkedin_login"][0]["user_firstName"].string! + " " + tempdata["linkedin_login"][0]["user_lastName"].string!
           
            labelCity.text = tempdata["linkedin_login"][0]["user_city"].string!
            
            if let imgURL = NSURL(string: tempdata["linkedin_login"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    userProfilePic.image = img
                    
                }
            }
 
            
            
        }
        
        
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return userposition.count
        
        let tempx = JSON(userpersonalinfo.object(forKey: "userpersonalinfo")!)
        
        return tempx["position_data"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let userinfocell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPositionCell", for: indexPath) as! UserPositioninfoCollectionViewCell
        
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            print(tempdata)
            
            userinfocell.textViewUserCompanyName.text = tempdata["position_data"][indexPath.row]["title"].string
            userinfocell.labelUserJobDuration.text = tempdata["position_data"][indexPath.row]["join_year"].string
            userinfocell.textViewUserCompanyinfo.text = tempdata["position_data"][indexPath.row]["industry"].string
            
        }
        
        //userinfocell.textViewUserCompanyName.text = userposition[indexPath.row]
        //userinfocell.labelUserJobDuration.text = userduration[indexPath.row]
        //userinfocell.textViewUserCompanyinfo.text = usercompanydescription[indexPath.row]
        
        return userinfocell
    }
     

    
    func updateinfo()
    {
        
        let temp = JSON(linkedinparameters.object(forKey: "linkedinparameters")!)
        
        print(temp)
        
        let authtoken = temp["oauth2_access_token"].stringValue
        let authid = temp["linkedin_id"].stringValue
       
        
        let parametersdata = ["login_type":"linkedin","oauth2_access_token": authtoken , "linkedin_id": authid , "device_token": device_token!,"user_latitude" : latMagnitude! , "user_longitude" : longMagnitude!] as [String : Any]
        
        //self.parametersdata = ["login_type":"linkedin","oauth2_access_token": AuthAcess! , "linkedin_id": Authid!,"device_token": device_token!,"user_latitude" : latMagnitude , "user_longitude" : longMagnitude]
        
        loadingIndicator.startAnimating()
        
        
        Alamofire.request(baseUrl+"linkedin/linkedin_refresh_data", method: HTTPMethod.post, parameters:parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
            
            
            
            if((apiresponse.response) != nil)
            {
                print(apiresponse.result.value!)
                
                userpersonalinfo.set(apiresponse.result.value, forKey: "userpersonalinfo")
                
                self.viewWillAppear(true)
                
                loadingIndicator.stopAnimating()
                
                
            }
            else
            {
                print("Error")
            }
            
        }
        
        
    }
    
    
    func loadMatches(_ notification : NSNotification)
    {
        let x =  JSON((notification.userInfo)!)
        
        print(x)
        
        let msgstring = "Ther is a Match! \n " + x["body"]["name"].string! + " wants to meet you too"
        
        let alert = UIAlertController(title: "\n \n \n Congratulations!", message: msgstring, preferredStyle: UIAlertControllerStyle.alert)
        
        //var imageView = UIImageView(frame: CGRectMake(220, 10, 40, 40))
        
        
        
        //let imageView = UIImageView(frame: CGRect(x: 220, y: 10, width: 40, height: 40))
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: 10, width: 70, height: 70))
        
        
        
        if let imgURL = NSURL(string: x["body"]["img"].string!)
        {
            if let imgdata = NSData(contentsOf: imgURL as URL) {
                
                let img = UIImage(data: imgdata as Data)
                
                imageView.image = img
                
            }
        }
        
        
        imageView.layer.cornerRadius = 35
        
        imageView.layer.borderWidth = 2
        
        imageView.layer.borderColor = UIColor(red: 218/255, green: 0/255, blue: 0/255, alpha: 0/255).cgColor
        
        imageView.clipsToBounds = true
        
        alert.view.addSubview(imageView)
        
        
        
        alert.addAction(UIAlertAction(title: "Nice", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
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
