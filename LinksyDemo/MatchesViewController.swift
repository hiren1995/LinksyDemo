//
//  MatchesViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 20/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

var MatchCellSelected = UserDefaults.standard

var MatchIdSelected = UserDefaults.standard


@available(iOS 10.0, *)
class MatchesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
  
    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    
    @IBOutlet weak var labelmessage: UILabel!
    @IBOutlet weak var labelMatches: UILabel!
    
    var images = ["random-user1","random-user2","random-user3","random-user4","random-user5"]
    var names = ["Kim Jacobs","Justin Walker","Shannon Adams","Denise Ruiz","Willard Thomas"]
    
    @IBOutlet weak var MatchesCollectionView: UICollectionView!

    
    @IBOutlet weak var btnBackToSwipe: UIButton!
    
    
    @IBOutlet weak var labelNewMsgIcon: UILabel!
    
    
    @IBOutlet weak var labelNoMatches: UILabel!
    
    
    @IBOutlet weak var countInfoView: UIView!
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelNoMatches.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        

        // Do any additional setup after loading the view.
        
        self.MatchesCollectionView.delegate = self
        self.MatchesCollectionView.dataSource = self
        
        labelNewMsgIcon.layer.cornerRadius = 7.5
        
        btnBackToSwipe.addTarget(self, action: #selector(backToSwipe), for: .touchUpInside)
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        let tempdatas = JSON(ConnList.object(forKey: "ConnList")!)
        
         print(tempdatas["chat_msgs"])
        
        
        
        labelmessage.text = tempdatas["chat_msgs"].stringValue
        
        labelNewMsgIcon.isHidden = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        MatchesCollectionView.refreshControl = refreshControl
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        //return images.count
        
        
        let tempx = JSON(ConnList.object(forKey: "ConnList")!)
       
        //use N?SNumber to convert that number to string value and setting the text...
        
        //let x = tempx["User's_match_List"].count as NSNumber
       
        let x = tempx["new_matches"]
        
        labelMatches.text = x.stringValue
        
        if(tempx["User's_match_List"].count == 0)
        {
            labelNoMatches.isHidden = false
            countInfoView.isHidden = true
        }
        
        
        return tempx["User's_match_List"].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let matchingcell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! MatchesCollectionViewCell
        
        
        if let userinfo = ConnList.object(forKey: "ConnList") as Any?
        {
            let tempdata = JSON(userinfo)

            //print(tempdata)
        
            matchingcell.imgNewMatches.layer.cornerRadius = 7.5
            matchingcell.imgNewMatches.layer.backgroundColor = UIColor(red: 218/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
            matchingcell.imgNewMatches.layer.borderColor = UIColor.white.cgColor
            matchingcell.imgNewMatches.layer.borderWidth = 2
        
        
            matchingcell.imgNewMessage.layer.cornerRadius = 7.5
            matchingcell.imgNewMessage.layer.backgroundColor = UIColor(red: 52/255, green: 178/255, blue: 117/255, alpha: 1.0).cgColor
            matchingcell.imgNewMessage.layer.borderColor = UIColor.white.cgColor
            matchingcell.imgNewMessage.layer.borderWidth = 2

        
        
            matchingcell.imgMatchPic.layer.cornerRadius = 25
        
        
            //matchingcell.imgMatchPic.image = UIImage(named: images[indexPath.row])
        
            //matchingcell.labelMatchName.text = names[indexPath.row]
            
            matchingcell.labelMatchName.text = tempdata["User's_match_List"][indexPath.row]["user_name"].string!
            
            
            if let imgURL = NSURL(string: tempdata["User's_match_List"][indexPath.row]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL)
                {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    matchingcell.imgMatchPic.image = img
                    
                    
                    
                }
            }
            
        
        }

        
        return matchingcell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading"
        spinnerActivity.detailsLabel.text = "Please Wait!!"
        spinnerActivity.isUserInteractionEnabled = false
        spinnerActivity.bezelView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        spinnerActivity.bezelView.color = UIColor.black
        spinnerActivity.label.textColor = UIColor.white
        spinnerActivity.detailsLabel.textColor = UIColor.white
        spinnerActivity.activityIndicatorColor = UIColor.white
        spinnerActivity.layer.zPosition = 1
        
        
        
        let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        
            let tempdata = JSON(userinfo!)
        
         let conninfo = ConnList.object(forKey: "ConnList") as Any?
        
            let conndata = JSON(conninfo!)
        
        print(conndata)
        
        //let m = indexPath.row
        
        //print(m)
        
        MatchIdSelected.set(conndata["User's_match_List"][indexPath.row]["match_id"].string , forKey: "MatchIdSelected")
        
        var parametersdata = [String:String]()
        
        print(parametersdata)
        
        if(conndata["User's_match_List"][indexPath.row]["to_user"].string! == tempdata["linkedin_login"][0]["user_id"].string!)
        
        {
             parametersdata = ["user_id":tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! , "user_match_id": conndata["User's_match_List"][indexPath.row]["match_id"].string!]
            
            
        }
        else
        {
              parametersdata = ["user_id":tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! , "user_match_id": conndata["User's_match_List"][indexPath.row]["match_id"].string!]
            
            
        }
        
      
        
        
        //print(parametersdata)
        
        Alamofire.request(baseUrl+"user/user_matchs_details", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
            
            
            
            if((apiresponse.response) != nil)
            {
                
                
                //print(apiresponse.result.value!)
                
                MatchCellSelected.set(apiresponse.result.value, forKey: "MatchCellSelected")
                
                
                spinnerActivity.hide(animated: true)
                
                //self.performSegue(withIdentifier: "MatchesToInfo", sender: nil)
                
                let obj : ProfileInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoViewController") as! ProfileInfoViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else
            {
                print("Error")
                
                let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        
        
        //let indexValueOfCell = indexPath.row
        
        //MatchCellSelected.set(indexValueOfCell, forKey: "MatchCellSelected")
        
        //let xyz = MatchCellSelected.object(forKey: "MatchCellSelected")
        
        //print(xyz!)
       
       
        
 
    }

    
    func backToSwipe()
    {
        
        //loadingIndicator.startAnimating()
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading"
        spinnerActivity.detailsLabel.text = "Please Wait!!"
        spinnerActivity.isUserInteractionEnabled = false
        spinnerActivity.bezelView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        spinnerActivity.bezelView.color = UIColor.black
        spinnerActivity.label.textColor = UIColor.white
        spinnerActivity.detailsLabel.textColor = UIColor.white
        spinnerActivity.activityIndicatorColor = UIColor.white
        spinnerActivity.layer.zPosition = 1
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            
            
            let baseUrl = "https://bulale.in/linksy/api/index.php/"
            
            let tempdata = JSON(userinfo)
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
            
            
            
            Alamofire.request(baseUrl + "user/get_user_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil)
                {
                    
                    //print(JSON(apiresponse.result.value!))
                    
                    tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
                    
                    //print(JSON(tempProfiles))
                    
                    
                    //loadingIndicator.stopAnimating()
                    
                    spinnerActivity.hide(animated: true)
                   
                    
                    //self.performSegue(withIdentifier: "MatchesToSwipe", sender: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }
    
    }

    @IBAction func btnMatchesTomsg(_ sender: Any) {
        
        //loadingIndicator.startAnimating()
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading"
        spinnerActivity.detailsLabel.text = "Please Wait!!"
        spinnerActivity.isUserInteractionEnabled = false
        spinnerActivity.bezelView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        spinnerActivity.bezelView.color = UIColor.black
        spinnerActivity.label.textColor = UIColor.white
        spinnerActivity.detailsLabel.textColor = UIColor.white
        spinnerActivity.activityIndicatorColor = UIColor.white
        spinnerActivity.layer.zPosition = 1
        
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            //print(tempdata)
            
            
            
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!]
            
            //print(parametersdata)
            
            
            Alamofire.request(self.baseUrl + "user/user_chat_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil)
                {
                    
                    //print("gettig chat list successfully")
                    
                    //print(JSON(apiresponse.result.value!))
                    
                    MsgList.set(apiresponse.result.value, forKey: "MsgList")
                    
                    
                    
                    //loadingIndicator.stopAnimating()
                    
                    spinnerActivity.hide(animated: true)
                    
                    //self.performSegue(withIdentifier: "MatchestoMsg", sender: nil)
                    
                    let obj : MessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
                    self.navigationController?.pushViewController(obj, animated: true)
                    
                    //print(apiresponse.result.value!)
                    
                    
                    
                }
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            
            
            
            
        }
        
        
        
        //MatchestoMsg
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
        
        
        
        alert.addAction(UIAlertAction(title: "Nice", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity.label.text = "Loading"
            spinnerActivity.detailsLabel.text = "Please Wait!!"
            spinnerActivity.isUserInteractionEnabled = false
            spinnerActivity.bezelView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
            spinnerActivity.bezelView.color = UIColor.black
            spinnerActivity.label.textColor = UIColor.white
            spinnerActivity.detailsLabel.textColor = UIColor.white
            spinnerActivity.activityIndicatorColor = UIColor.white
            spinnerActivity.layer.zPosition = 1
            
            
            if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
            {
                let tempdata = JSON(userinfo)
                
                //print(tempdata)
                
                
                
                let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!]
                
                //print(parametersdata)
                
                
                Alamofire.request(self.baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                    
                    if((apiresponse.response) != nil )
                    {
                        
                        //print("gettig chat list successfully")
                        print(apiresponse.result.value!)
                        
                        ConnList.set(apiresponse.result.value, forKey: "ConnList")
                        
                        
                        self.MatchesCollectionView.reloadData()
                        
                        //loadingIndicator.stopAnimating()
                        
                        spinnerActivity.hide(animated: true)
                        
                       
                        
                        
                    }
                    else
                    {
                        print("Error")
                        
                        let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            
        }))
        
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
            
        } else{
            self.dismiss(animated: false, completion: {
                self.present(alert, animated: true, completion: nil)
            })
        }
        
        //self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func refresh()
    {
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            //print(tempdata)
            
            
            
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!]
            
            //print(parametersdata)
            
            
            Alamofire.request(self.baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil )
                {
                    
                    //print("gettig chat list successfully")
                    print(apiresponse.result.value!)
                    
                    ConnList.set(apiresponse.result.value, forKey: "ConnList")
                    
                }
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
         
        }
       
        MatchesCollectionView.reloadData()
        
        refreshControl.endRefreshing()
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
