//
//  ProfileInfoViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 24/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD





class ProfileInfoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    let baseUrl = "http://linksy.co/api/index.php/"
    
    
    @IBOutlet weak var imgpic: UIImageView!
    
    @IBOutlet weak var labelinfo: UITextView!
    
    @IBOutlet weak var profileInfoCollectionView: UICollectionView!
   
    @IBOutlet weak var labelName: UILabel!
    
    
    @IBOutlet weak var labelSummary: UILabel!
    
    @IBOutlet weak var InnerScrollViewProfileInfo: UIView!
    
    
    @IBOutlet weak var ScrollViewProfileInfo: UIScrollView!
    
    
    @IBOutlet var MainFrameViewProfileInfo: UIView!
    
    
    
    @IBOutlet weak var btnBack: UIButton!
    
  
    @IBOutlet var btnDone: UIButton!
    
    
    var position = ["Chairman and CEO Netflix"]
    
    var duration = ["Oct 1997- Present"]
    
    var companydescription = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Ut enim ad minim veniam, quis nostrud exercitation ullamco "]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        

        // Do any additional setup after loading the view.
        
        profileInfoCollectionView.dataSource = self
        profileInfoCollectionView.delegate = self
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)

        btnBack.addTarget(self, action: #selector(backTOMatchesVC), for: .touchUpInside)
        btnDone.addTarget(self, action: #selector(backTOMatchesVC), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let otherusrinfo = MatchCellSelected.object(forKey: "MatchCellSelected") as Any?
        {
            let tempdata = JSON(otherusrinfo)
            
            print(tempdata)
            
            
            labelinfo.text = tempdata["Match_user_details"][0]["headline"].string!
            
            labelName.text = tempdata["Match_user_details"][0]["user_firstName"].string! + " " + tempdata["Match_user_details"][0]["user_lastName"].string!
            
            
            labelSummary.text = tempdata["Match_user_details"][0]["summary"].string!
            
            labelSummary.numberOfLines = 0
            
            labelSummary.sizeToFit()
            
            labelSummary.textAlignment = NSTextAlignment.justified
            
            labelSummary.translatesAutoresizingMaskIntoConstraints = true
            
           
            
            if let imgURL = NSURL(string: tempdata["Match_user_details"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    imgpic.image = img
                    
                }
            }
            
          
            
            profileInfoCollectionView.reloadData()
            
        }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let counttemp = JSON( MatchCellSelected.object(forKey: "MatchCellSelected")!)
        
        return counttemp["Match_user_details"].count
        
        //return position.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let infocell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCell", for: indexPath) as! PositioninfoCollectionViewCell
        
        //infocell.textViewCompanyName.text = position[indexPath.row]
        //infocell.labelJobDuration.text = duration[indexPath.row]
        //infocell.textViewCompanyinfo.text = companydescription[indexPath.row]
        
        
        
        if let otherusrinfo = MatchCellSelected.object(forKey: "MatchCellSelected") as Any?
        {
            let tempdata = JSON(otherusrinfo)
            
            //print(tempdata)
            
                       
            infocell.textViewCompanyName.text = tempdata["Match_user_details"][indexPath.row]["title"].string!
            infocell.labelJobDuration.text = tempdata["Match_user_details"][indexPath.row]["join_year"].string!
            infocell.textViewCompanyinfo.text = tempdata["Match_user_details"][indexPath.row]["company_name"].string!

            
        }
        
        //----------------------- code for dynamic size of collection view -----------------------------
        
        profileInfoCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        profileInfoCollectionView.layoutIfNeeded()
        
        self.profileInfoCollectionView.frame = CGRect(x: self.profileInfoCollectionView.frame.origin.x, y: self.labelSummary.frame.origin.y + self.labelSummary.frame.size.height + 50, width: self.profileInfoCollectionView.frame.size.width, height: self.profileInfoCollectionView.contentSize.height)
        
        self.profileInfoCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        //self.userProfileinfoCollectionView.reloadData()
        
        
        
        
       
        //------------------------dynamic height of scroll view---------------
        
        //self.InnerScrollViewProfileInfo.frame = CGRect(x: 0, y: 0, width: self.InnerScrollViewProfileInfo.frame.width, height: labelSummary.frame.origin.y + labelSummary.frame.height + profileInfoCollectionView.frame.height + 265 )
        
         self.InnerScrollViewProfileInfo.frame = CGRect(x: 0, y: 0, width: self.InnerScrollViewProfileInfo.frame.width, height: labelSummary.frame.origin.y + labelSummary.frame.height + profileInfoCollectionView.frame.height + 265)
        
        InnerScrollViewProfileInfo.translatesAutoresizingMaskIntoConstraints = true
        
       
        self.ScrollViewProfileInfo.contentSize = CGSize(width: self.ScrollViewProfileInfo.contentSize.width, height: self.InnerScrollViewProfileInfo.frame.height)
        
        //self.ScrollViewProfileInfo.frame = CGRect(x: 0, y: 0, width: self.ScrollViewProfileInfo.contentSize.width, height: self.ScrollViewProfileInfo.contentSize.height)
        
        //self.MainFrameViewProfileInfo.frame = CGRect(x: 0, y: 0, width: self.ScrollViewProfileInfo.contentSize.width, height: self.ScrollViewProfileInfo.contentSize.height + 68)
        
        
        return infocell
    }
    
    
    @IBAction func DeleteMatch(_ sender: UIButton) {
        
        //MatchIdSelected
        
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
            
            let MatchIdDelete = MatchIdSelected.object(forKey: "MatchIdSelected")
            
            //print(JSON(MatchIdDelete!))
            
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! , "match_id": JSON(MatchIdDelete!).stringValue ]
            
            print(parametersdata)
            
            
            Alamofire.request(baseUrl + "user/user_match_delete", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil )
                {
                    print(apiresponse.result.value!)
                    
                    let matchparameterdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!]
                    
                    //print(parametersdata)
                    
                    
                    Alamofire.request(self.baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: matchparameterdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                        
                        if((apiresponse.response) != nil )
                        {
                            
                            //print("gettig chat list successfully")
                            print(apiresponse.result.value!)
                            
                            ConnList.set(apiresponse.result.value, forKey: "ConnList")
                            
                            //loadingIndicator.stopAnimating()
                            
                            spinnerActivity.hide(animated: true)
                            
                            //self.performSegue(withIdentifier: "ProfileVcToMatchVc", sender: nil)
                            
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
    
    func backTOMatchesVC()
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
            let tempdata = JSON(userinfo)
            
            //print(tempdata)
            
            
            
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!]
            
            //print(parametersdata)
            
            
            Alamofire.request(baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil )
                {
                    
                    //print("gettig chat list successfully")
                    print(apiresponse.result.value!)
                    
                    ConnList.set(apiresponse.result.value, forKey: "ConnList")
                    
                    
                    //loadingIndicator.stopAnimating()
                    
                    spinnerActivity.hide(animated: true)
                    
                    //self.performSegue(withIdentifier: "ProfileVcToMatchVc", sender: nil)
                    
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
    
    
    
    @IBAction func btnChat(_ sender: UIButton) {
        
        MsgList.removeObject(forKey: "MsgList")
        
        chatId.removeObject(forKey:"chatId")
        
        let listinfo = JSON(MatchCellSelected.object(forKey: "MatchCellSelected")!)

        chatId.set(listinfo["Match_user_details"][0]["chat_id"].string!, forKey: "chatId")
        
        let obj : ChatOutViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatOutViewViewController") as! ChatOutViewViewController
        self.navigationController?.pushViewController(obj, animated: true)
        
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
