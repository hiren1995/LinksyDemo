////
//  ProfileViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 18/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import BEMCheckBox
import SwiftRangeSlider
import SwiftyJSON
import Alamofire
import LinkedinSwift
import MBProgressHUD
//import IQKeyboardManagerSwift

var tempProfiles = UserDefaults.standard

var preferencesdefault = UserDefaults.standard


@available(iOS 10.0, *)
class ProfileViewController: UIViewController,BEMCheckBoxDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    
    @IBOutlet weak var InnerScrollView: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    @IBOutlet weak var IndustriesCollectionView: UICollectionView!
    
    @IBOutlet weak var FunctionsCollectionView: UICollectionView!
    
    @IBOutlet weak var PositionsCollectionView: UICollectionView!
    
    @IBOutlet weak var IntentsCollectionView: UICollectionView!
    
    @IBOutlet weak var checkIndustries: BEMCheckBox!
   
    @IBOutlet weak var checkFunctions: BEMCheckBox!
    
    @IBOutlet weak var checkPositions: BEMCheckBox!
    
    @IBOutlet weak var checkIntent: BEMCheckBox!
    
    
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var btnRemoveAccount: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    
    //range slider connection
    
    @IBOutlet weak var sliderUI: RangeSlider!
    
    @IBOutlet weak var btn500m: UIButton!

    @IBOutlet weak var btn1km: UIButton!
    
    @IBOutlet weak var btn5km: UIButton!

    @IBOutlet weak var btn20km: UIButton!
    
    @IBOutlet weak var btn50km: UIButton!
    
    @IBOutlet weak var btn100km: UIButton!
    
    
    // labels for names etc...
    
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHeadLine: UITextView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    

    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    var btnindustriesflag=0;
  
    
    var industryArray:[[String:String]] = [["value":"Financial","isSelected":"n"],["value":"Corporate","isSelected":"n"],["value":"Technology","isSelected":"n"],["value":"Consumer","isSelected":"n"],["value":"Media","isSelected":"n"],["value":"Legal","isSelected":"n"],["value":"Real Estate","isSelected":"n"],["value":"Transportation","isSelected":"n"],["value":"Public","isSelected":"n"],["value":"Creative","isSelected":"n"],["value":"Manufacturing","isSelected":"n"],["value":"non-Profit","isSelected":"n"],["value":"Health","isSelected":"n"],["value":"Entertainment","isSelected":"n"],["value":"Agriculture","isSelected":"n"],["value":"Education","isSelected":"n"]]
    
    var functionsArray:[[String:String]] = [["value":"Marketing","isSelected":"n"],["value":"Sales","isSelected":"n"],["value":"Technology","isSelected":"n"],["value":"Finance","isSelected":"n"],["value":"HR","isSelected":"n"],["value":"Security","isSelected":"n"],["value":"Risk","isSelected":"n"],["value":"Legal","isSelected":"n"],["value":"Other","isSelected":"n"]]
    
    var positionsArray:[[String:String]] = [["value":"Owner","isSelected":"n"],["value":"CXO","isSelected":"n"],["value":"VP","isSelected":"n"],["value":"Director","isSelected":"n"],["value":"Manager","isSelected":"n"],["value":"Senior","isSelected":"n"],["value":"Entry-level","isSelected":"n"],["value":"Training","isSelected":"n"],["value":"Other","isSelected":"n"]]
    
    var intentArray:[[String:String]] = [["value":"Recruitment","isSelected":"n"],["value":"Networking","isSelected":"n"],["value":"Business","isSelected":"n"],["value":"New job","isSelected":"n"],["value":"Investment","isSelected":"n"],["value":"Other","isSelected":"n"]]
    
    
    @IBOutlet weak var imgprofile: UIImageView!

    @IBOutlet weak var imgTopics: UIImageView!
    
    @IBOutlet weak var imgCompanies: UIImageView!
    
    // declarations for the topics module
    
    @IBOutlet weak var TopicsCollectionView: UICollectionView!
    @IBOutlet weak var txtTopic: UITextField!
    var topicarray = [String]()
    
    
    var topiccellwidth:CGFloat = 0
   
    
    // declarations for the company module

    @IBOutlet weak var CompaniesCollectionView: UICollectionView!
    
    @IBOutlet weak var txtCompany: UITextField!
    
    var companyarray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
        //imgprofile.layer.cornerRadius = 50
       

        // Do any additional setup after loading the view.
        
        
        sliderUI.dragTrack = true
        
      
        self.IndustriesCollectionView.delegate = self
        self.IndustriesCollectionView.dataSource = self
        
        self.FunctionsCollectionView.delegate = self
        self.FunctionsCollectionView.dataSource = self
        
        self.PositionsCollectionView.delegate = self
        self.PositionsCollectionView.dataSource = self
        
        self.IntentsCollectionView.delegate = self
        self.IntentsCollectionView.dataSource = self
        
        self.TopicsCollectionView.delegate = self
        self.TopicsCollectionView.dataSource = self
        
        
        self.CompaniesCollectionView.delegate = self
        self.CompaniesCollectionView.dataSource = self
        
        
        
        
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
        
        imgTopics.layer.borderColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0).cgColor
        imgTopics.layer.borderWidth = 0.5
        
        
        imgCompanies.layer.borderColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0).cgColor
        imgCompanies.layer.borderWidth = 0.5
        
        
        
        // below code for making all check box of industry checked...
        
        checkIndustries.addTarget(self, action: #selector(SelAllIndustries), for: .allEvents)
        
        checkFunctions.addTarget(self, action: #selector(SelAllFunctions), for: .allEvents)
        
        checkPositions.addTarget(self, action: #selector(SelAllPositions), for: .allEvents)
        
        checkIntent.addTarget(self, action: #selector(SelAllIntents), for: .allEvents)
        
        
      
        
        btnSave.addTarget(self, action: #selector(loadingurl), for: .touchUpInside)
        
        btnBack.addTarget(self, action: #selector(loadingurl), for: .touchUpInside)
        
        btnDone.addTarget(self, action: #selector(loadingurl), for: .touchUpInside)
        
        btnLogout.addTarget(self, action: #selector(signout), for: .touchUpInside)
        
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
       /*
        
        checkIndustries.on = true
        
        for i in 0...industryArray.count-1
        {
            industryArray[i]["isSelected"] = "y"
        }
        
        IndustriesCollectionView.reloadData()
       
        
        
        checkPositions.on = true
        
        for i in 0...positionsArray.count-1
        {
            positionsArray[i]["isSelected"] = "y"
        }
        
        PositionsCollectionView.reloadData()
        
        
        
        checkIntent.on = true
        
        for i in 0...intentArray.count-1
        {
            intentArray[i]["isSelected"] = "y"
        }
        
        IntentsCollectionView.reloadData()  

        
        
        
        checkFunctions.on = true
        
        for i in 0...functionsArray.count-1
        {
            functionsArray[i]["isSelected"] = "y"
        }
        
        FunctionsCollectionView.reloadData()


       */
        
        
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            print(tempdata)
            
            let firstName = tempdata["linkedin_login"][0]["user_firstName"].string
            let lastName = tempdata["linkedin_login"][0]["user_lastName"].string

            
            labelName.text = firstName!.capitalized + " " + lastName!.capitalized
            
            labelHeadLine.text =  tempdata["linkedin_login"][0]["headline"].string
            
            if let imgURL = NSURL(string: tempdata["linkedin_login"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    imgProfilePic.image = img
                    
                }
            }
          
            //
            
            let preferencesdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
            
            let baseUrl = "https://bulale.in/linksy/api/index.php/"
            
            Alamofire.request(baseUrl + "user/get_user_prefrences", method: HTTPMethod.post, parameters: preferencesdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponsePreference) in
                
                if((apiresponsePreference.response) != nil)
                {
                    
                   // print(JSON(apiresponse.result.value!))
                    
                    preferencesdefault.set(apiresponsePreference.result.value, forKey: "preferencesdefault")
                    
                    let tempPreferences = JSON(preferencesdefault.object(forKey: "preferencesdefault")!)
                    
                    print(tempPreferences)
                    //print(tempPreferences["intent fields"].count)
                    //print(tempPreferences["Company fields"].count)
                    
                    if(tempPreferences["user radius"][0]["user_radius"].string == "0.5")
                    {
                        self.sliderUI.upperValue = 1
                        
                        
                        self.btn500m.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        
                    }
                    else if(tempPreferences["user radius"][0]["user_radius"].string == "1")
                    {
                        self.sliderUI.upperValue = 2
                        
                        self.btn1km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    else if(tempPreferences["user radius"][0]["user_radius"].string == "5")
                    {
                        self.sliderUI.upperValue = 3
                        
                        self.btn5km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    else if(tempPreferences["user radius"][0]["user_radius"].string == "20")
                    {
                        self.sliderUI.upperValue = 4
                        
                        self.btn20km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    else if(tempPreferences["user radius"][0]["user_radius"].string == "50")
                    {
                        self.sliderUI.upperValue = 5
                        
                        self.btn50km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    else if(tempPreferences["user radius"][0]["user_radius"].string == "100")
                    {
                        self.sliderUI.upperValue = 6
                        
                        self.btn100km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    else
                    {
                        self.sliderUI.upperValue = 1
                        
                        
                        self.btn500m.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
                        
                        self.btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                        self.btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
                    }
                    
                    
                    if(tempPreferences["Topics fields"].count > 0)
                    {
                        for i in 0...tempPreferences["Topics fields"].count-1
                        {
                             self.topicarray.append(tempPreferences["Topics fields"][i]["topics_name"].string!)
                        }
                        self.TopicsCollectionView.reloadData()
                        
                        
                        
                        
                        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
                        self.TopicsCollectionView.layoutIfNeeded()
                        
                        self.TopicsCollectionView.frame = CGRect(x: self.TopicsCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y, width: self.TopicsCollectionView.frame.size.width, height: self.TopicsCollectionView.contentSize.height)
                        
                        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
                        
                        self.TopicsCollectionView.reloadData()
                        
                        //self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
                        
                        
                        
                        //self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
                        
                        //self.TopicsCollectionView.reloadData()
                        
                        //------------------------dynamic height of scroll view---------------
                        
                        
                         self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.CompaniesCollectionView.frame.origin.y + 950 + self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height)
                        
                        //self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.TopicsCollectionView.frame.origin.y + 950 + self.TopicsCollectionView.frame.height)
                        
                        self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
                        
                        
                    }
                    
                    
                    
                    if(tempPreferences["Company fields"].count > 0)
                    {
                        for i in 0...tempPreferences["Company fields"].count-1
                        {
                            self.companyarray.append(tempPreferences["Company fields"][i]["company_name"].string!)
                        }
                        self.CompaniesCollectionView.reloadData()
                        
                      
                        
                        
                        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
                        
                        self.CompaniesCollectionView.layoutIfNeeded()
                        
                        self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
                        
                       // self.TopicsCollectionView.frame.origin.y + self.TopicsCollectionView.frame.height + 99
                        
                        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
                        
                        self.CompaniesCollectionView.reloadData()
                        
                        //------------------------dynamic height of scroll view---------------
                        
                        self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.CompaniesCollectionView.frame.origin.y + 950 + self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height)
                        
                        //self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.CompaniesCollectionView.frame.origin.y + 950 + self.CompaniesCollectionView.frame.height)
                        
                        self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
                        
                        
                    }
                    
                    
                    
                    
                    if(tempPreferences["intent fields"].count == 0 && tempPreferences["Topics fields"].count == 0 && tempPreferences["function fields"].count == 0 && tempPreferences["position fields"].count == 0 && tempPreferences["Company fields"].count == 0 && tempPreferences["industry fields"].count == 0)
                    {
                    
                        self.checkIndustries.on = true
                        
                        for i in 0...self.industryArray.count-1
                        {
                            self.industryArray[i]["isSelected"] = "y"
                        }
                        
                        self.IndustriesCollectionView.reloadData()
                        
                        
                        
                        self.checkPositions.on = true
                        
                        for i in 0...self.positionsArray.count-1
                        {
                            self.positionsArray[i]["isSelected"] = "y"
                        }
                        
                        self.PositionsCollectionView.reloadData()
                        
                        
                        
                        self.checkIntent.on = true
                        
                        for i in 0...self.intentArray.count-1
                        {
                            self.intentArray[i]["isSelected"] = "y"
                        }
                        
                        self.IntentsCollectionView.reloadData()  
                        
                        
                        
                        
                        self.checkFunctions.on = true
                        
                        for i in 0...self.functionsArray.count-1
                        {
                            self.functionsArray[i]["isSelected"] = "y"
                        }
                        
                        self.FunctionsCollectionView.reloadData()
                        
                        
                    }
                        
                    else if(tempPreferences["intent fields"].count == 6 && tempPreferences["function fields"].count == 9 && tempPreferences["position fields"].count == 9 && tempPreferences["industry fields"].count == 16)
                    {
                        self.checkFunctions.on = true
                        self.checkIntent.on = true
                        self.checkPositions.on = true
                        self.checkIndustries.on = true
                         
                         if(tempPreferences["function fields"].count > 0)
                         {
                            for j in 0...tempPreferences["function fields"].count-1
                            {
                                    //print(tempPreferences["function fields"][j]["function_master_name"])
                                    for i in 0...self.functionsArray.count-1
                                    {
                                            //print(self.functionsArray[i]["value"]!)
                         
                                            if(tempPreferences["function fields"][j]["function_master_name"].string == self.functionsArray[i]["value"])
                                            {
                                                self.functionsArray[i]["isSelected"] = "y"
                                                self.FunctionsCollectionView.reloadData()
                                            }
                         
                                    }
                            }
                         }
                         
                         if(tempPreferences["intent fields"].count > 0)
                         {
                            for j in 0...tempPreferences["intent fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.intentArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                         
                                    if(tempPreferences["intent fields"][j]["intent_master_name"].string == self.intentArray[i]["value"])
                                    {
                                        self.intentArray[i]["isSelected"] = "y"
                                        self.IntentsCollectionView.reloadData()
                                    }
                         
                                }
                            }
                         }
                         
                         
                         if(tempPreferences["industry fields"].count > 0)
                         {
                            for j in 0...tempPreferences["industry fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.industryArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                         
                                    if(tempPreferences["industry fields"][j]["industry_master_name"].string == self.industryArray[i]["value"])
                                    {
                                        self.industryArray[i]["isSelected"] = "y"
                                        self.IndustriesCollectionView.reloadData()
                                    }
                         
                                }
                            }
                         }
                         
                         if(tempPreferences["position fields"].count > 0)
                         {
                            for j in 0...tempPreferences["position fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.positionsArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                         
                                    if(tempPreferences["position fields"][j]["position_master_name"].string == self.positionsArray[i]["value"])
                                    {
                                        self.positionsArray[i]["isSelected"] = "y"
                                        self.PositionsCollectionView.reloadData()
                                    }
                         
                                }
                            }
                         }
                        
                    }
                        
                    
                    else
                    {
                        if(tempPreferences["function fields"].count > 0)
                        {
                            for j in 0...tempPreferences["function fields"].count-1
                            {
                                //print(tempPreferences["function fields"][j]["function_master_name"])
                                for i in 0...self.functionsArray.count-1
                                {
                                    //print(self.functionsArray[i]["value"]!)
                                
                                    if(tempPreferences["function fields"][j]["function_master_name"].string == self.functionsArray[i]["value"])
                                    {
                                        self.functionsArray[i]["isSelected"] = "y"
                                        self.FunctionsCollectionView.reloadData()
                                    }
                                
                                }
                            }
                        }
                        
                        if(tempPreferences["intent fields"].count > 0)
                        {
                            for j in 0...tempPreferences["intent fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.intentArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                                
                                    if(tempPreferences["intent fields"][j]["intent_master_name"].string == self.intentArray[i]["value"])
                                    {
                                        self.intentArray[i]["isSelected"] = "y"
                                        self.IntentsCollectionView.reloadData()
                                    }
                                
                                }
                            }
                        }
                        
                        
                        if(tempPreferences["industry fields"].count > 0)
                        {
                            for j in 0...tempPreferences["industry fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.industryArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                                    
                                    if(tempPreferences["industry fields"][j]["industry_master_name"].string == self.industryArray[i]["value"])
                                    {
                                        self.industryArray[i]["isSelected"] = "y"
                                        self.IndustriesCollectionView.reloadData()
                                    }
                                    
                                }
                            }
                        }
                        
                        if(tempPreferences["position fields"].count > 0)
                        {
                            for j in 0...tempPreferences["position fields"].count-1
                            {
                                //print(tempPreferences["intent fields"][j]["intent_master_name"])
                                for i in 0...self.positionsArray.count-1
                                {
                                    //print(self.intentArray[i]["value"]!)
                                    
                                    if(tempPreferences["position fields"][j]["position_master_name"].string == self.positionsArray[i]["value"])
                                    {
                                        self.positionsArray[i]["isSelected"] = "y"
                                        self.PositionsCollectionView.reloadData()
                                    }
                                    
                                }
                            }
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
    
    
    
    
    
    
    
        @IBAction func btnallIndustry(_ sender: Any) {
           
         if(btnindustriesflag == 0)
         {
            btnindustriesflag = 1;
            checkboxSelected()
            
         }
         else{
         
            btnindustriesflag=0;
            checkboxNotSelected()
         }
            
            
            
    }
    
 
 
    func SelAllIndustries()
    {
        if(checkIndustries.on == true)
        {
            for i in 0...industryArray.count-1
            {
                    industryArray[i]["isSelected"] = "y"
          
            }
        
            IndustriesCollectionView.reloadData()
        }
        else{
        
            for i in 0...industryArray.count-1
            {
                industryArray[i]["isSelected"] = "n"
                
            }
            
            IndustriesCollectionView.reloadData()

            
        }
        

    }
    
    func SelAllFunctions()
    {
        if(checkFunctions.on == true)
        {
            for i in 0...functionsArray.count-1
            {
                functionsArray[i]["isSelected"] = "y"
                
            }
            
            FunctionsCollectionView.reloadData()
        }
        else{
            
            for i in 0...functionsArray.count-1
            {
                functionsArray[i]["isSelected"] = "n"
                
            }
            
            FunctionsCollectionView.reloadData()
            
            
        }
        
        
    }
    
    func SelAllPositions()
    {
        if(checkPositions.on == true)
        {
            for i in 0...positionsArray.count-1
            {
                positionsArray[i]["isSelected"] = "y"
                
            }
            
            PositionsCollectionView.reloadData()
        }
        else{
            
            for i in 0...positionsArray.count-1
            {
                positionsArray[i]["isSelected"] = "n"
                
            }
            
            PositionsCollectionView.reloadData()
            
            
        }
        
        
    }
    
    func SelAllIntents()
    {
        if(checkIntent.on == true)
        {
            for i in 0...intentArray.count-1
            {
                intentArray[i]["isSelected"] = "y"
                
            }
            
            IntentsCollectionView.reloadData()
        }
        else{
            
            for i in 0...intentArray.count-1
            {
                intentArray[i]["isSelected"] = "n"
                
            }
            
            IntentsCollectionView.reloadData()
            
            
        }
        
        
    }
 
 
    func checkboxSelected(){
        
        checkIndustries.on = true
       
    }
    
    func checkboxNotSelected()
    {
        checkIndustries.on = false
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if(collectionView == IndustriesCollectionView)
        {
            //return items_industry.count
            return industryArray.count
        }
        else if(collectionView == FunctionsCollectionView)
        {
            return functionsArray.count
        }
        else if(collectionView == PositionsCollectionView){
            return positionsArray.count
        }
        else if(collectionView == IntentsCollectionView){
            return intentArray.count;
        }
        else if(collectionView == TopicsCollectionView)
        {
            return topicarray.count
        }
        
        return companyarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == IndustriesCollectionView)
        {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellIndustries", for: indexPath) as! NameCellCollectionViewCell
        
                itemCell.nameLabel.text = industryArray[indexPath.row]["value"]
            
                if(industryArray[indexPath.row]["isSelected"] == "y")
                {
                        itemCell.checkBox.on = true
                }
                else if(industryArray[indexPath.row]["isSelected"] == "n")
                {
                    itemCell.checkBox.on = false
                }
            return itemCell
        }
            
            
        else if(collectionView == FunctionsCollectionView)
        {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellFunctions", for: indexPath) as! NameCellCollectionViewCell
            
            itemCell.nameLabel.text = functionsArray[indexPath.row]["value"]
            
            if(functionsArray[indexPath.row]["isSelected"] == "y")
            {
                itemCell.checkBox.on = true
            }
            else if(functionsArray[indexPath.row]["isSelected"] == "n")
            {
                itemCell.checkBox.on = false
            }
            
            return itemCell
        }
            
        else if(collectionView == PositionsCollectionView)
        {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellPositions", for: indexPath) as! NameCellCollectionViewCell
            
            itemCell.nameLabel.text = positionsArray[indexPath.row]["value"]
            
            if(positionsArray[indexPath.row]["isSelected"] == "y")
            {
                itemCell.checkBox.on = true
            }
            else if(positionsArray[indexPath.row]["isSelected"] == "n")
            {
                itemCell.checkBox.on = false
            }

            
            return itemCell
        }
            
        else if(collectionView == IntentsCollectionView)
        {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellIntents", for: indexPath) as! NameCellCollectionViewCell
            
            itemCell.nameLabel.text = intentArray[indexPath.row]["value"]
            
            if(intentArray[indexPath.row]["isSelected"] == "y")
            {
                itemCell.checkBox.on = true
            }
            else if(intentArray[indexPath.row]["isSelected"] == "n")
            {
                itemCell.checkBox.on = false
            }
            
            return itemCell
        }
        
        else if(collectionView == CompaniesCollectionView)
        {
            let companycell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompaniesCell", for: indexPath) as! CompanyCollectionViewCell
            if(companyarray.count  != 0)
            {
                companycell.labelCompanyName.text = companyarray[indexPath.row]
                
                companycell.labelCompanyName.numberOfLines = 1
                
                
                //below statement to set the layer value and send it to delete function to delete item at that place...
                
                companycell.btnCancelCompany.layer.setValue(indexPath.row, forKey: "index")
                companycell.btnCancelCompany.addTarget(self, action: #selector(deletecellCompany), for: .touchUpInside)
                
                
            }
            return companycell
        }
            
            
        else
        {
            let topiccell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath) as! TopicsCollectionViewCell
            if(topicarray.count  != 0)
            {
                topiccell.labelTopic.text = topicarray[indexPath.row]
                topiccell.labelTopic.textColor = UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0)
            
                topiccell.labelTopic.numberOfLines = 1
             
                
                //below statement to set the layer value and send it to delete function to delete item at that place...
                topiccell.btnCancelTopic.layer.setValue(indexPath.row, forKey: "index")
                topiccell.btnCancelTopic.addTarget(self, action: #selector(deletecell), for: .touchUpInside)
                
            }
            return topiccell
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == IndustriesCollectionView)
        {
          
            var tempdic = industryArray[indexPath.row]
            
            if(tempdic["isSelected"] == "y")
            {
                
                tempdic["isSelected"] = "n"
            }
            else
            {
                tempdic["isSelected"] = "y"
            }
            
            industryArray[indexPath.row] = tempdic
            
            IndustriesCollectionView.reloadData()
        }
        else if(collectionView == FunctionsCollectionView)
        {
            var tempdic = functionsArray[indexPath.row]
            
            if(tempdic["isSelected"] == "y")
            {
                
                tempdic["isSelected"] = "n"
            }
            else
            {
                tempdic["isSelected"] = "y"
            }
            
            functionsArray[indexPath.row] = tempdic
            
            FunctionsCollectionView.reloadData()
        
        }
        
        else if(collectionView == PositionsCollectionView)
        {
            var tempdic = positionsArray[indexPath.row]
            
            if(tempdic["isSelected"] == "y")
            {
                
                tempdic["isSelected"] = "n"
            }
            else
            {
                tempdic["isSelected"] = "y"
            }
            
            positionsArray[indexPath.row] = tempdic
            
            PositionsCollectionView.reloadData()
        }
        
        else
        {
            var tempdic = intentArray[indexPath.row]
            
            if(tempdic["isSelected"] == "y")
            {
                
                tempdic["isSelected"] = "n"
            }
            else
            {
                tempdic["isSelected"] = "y"
            }
            
            intentArray[indexPath.row] = tempdic
            
            IntentsCollectionView.reloadData()
        }
       
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
        
        var cellSize:CGSize = CGSize(width: 0, height: 0)
        
        if(collectionView == TopicsCollectionView)
        {
        /*
         let topicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellPositions", for:indexPath as IndexPath) as! NameCellCollectionViewCell
         
         print(topicsCell.nameLabel.intrinsicContentSize.width)
         
         cellSize = CGSize(width: topiccellwidth, height: 23)
         */
        
        //let size: CGSize = topicarray[indexPath.row].size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)])
        
        cellSize = CGSize(width: self.TopicsCollectionView.frame.width, height: 23)
        
        //size.width + 45.0
        
        }
        return cellSize
    }
 
 */
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        var cellSize:CGSize = CGSize(width: 107, height: 24)
        
        if(collectionView == TopicsCollectionView )
        {
            
            
            
            /*
     
             let topicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCellPositions", for:indexPath as IndexPath) as! NameCellCollectionViewCell
             
             print(topicsCell.nameLabel.intrinsicContentSize.width)
             
             cellSize = CGSize(width: topiccellwidth, height: 23)
             */
            
            
            
            
            // first we need to ge the width of text of all index in array of topics with the text size we  defined for the label in cell and add the width of buttonbeside it to that and set that size to the cell.....and its done..
            
            let size: CGSize = topicarray[indexPath.row].size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)])
            
            cellSize = CGSize(width: size.width + 35.0, height: 23)
            
            //size.width + 45.0
            
            
        }
        
        else if(collectionView == CompaniesCollectionView )
        {
            let size: CGSize = companyarray[indexPath.row].size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)])
            
            cellSize = CGSize(width: size.width + 35.0, height: 23)
        }
        
        return cellSize
    }

 
  
    
    
 
 
    @IBAction func btn500m(_ sender: UIButton) {
        
        sliderUI.upperValue = 1
        
        btn500m.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
        
    }
    
    @IBAction func btn1km(_ sender: UIButton) {
        
        sliderUI.upperValue = 2
        
        
        btn1km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
        
    }
    
    
    @IBAction func btn5km(_ sender: UIButton) {
        
        sliderUI.upperValue = 3
        
        btn5km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
    }
    
    
    @IBAction func btn20km(_ sender: UIButton) {
        
        sliderUI.upperValue = 4
        
        btn20km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
    }
    
    @IBAction func btn50km(_ sender: UIButton) {
        
        sliderUI.upperValue = 5
        
        btn50km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn100km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
    }
    
    
    @IBAction func btn100km(_ sender: UIButton) {
        sliderUI.upperValue = 6
        
        
        
        btn100km.setTitleColor(UIColor(red: 0/255, green: 157/255, blue: 217/255, alpha: 1.0), for: .normal)
        
        btn500m.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn1km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn5km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn20km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        btn50km.titleLabel?.textColor = UIColor(red: 169/255, green: 171/255, blue: 171/255, alpha: 1.0)
        
       
    }
    
    
    // Topics module implementation...
    
    @IBAction func btnAddTopic(_ sender: UIButton) {
        
        if(txtTopic.text != nil && (txtTopic.text?.characters.count)! > 0)
        {
           // topicarray.append(txtTopic.text!)
            
            // This code is written to get the text in textfield store that in temp string and then split and store in temp array and append that to topic array..
            
            let tempstr = txtTopic.text!
            
            let temparray = tempstr.components(separatedBy: ",")
            
            for element in 0...temparray.count-1
            {
                topicarray.append(temparray[element])
            }

   
            TopicsCollectionView.reloadData()
            
            
            self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
            self.TopicsCollectionView.layoutIfNeeded()
            
            TopicsCollectionView.frame = CGRect(x: TopicsCollectionView.frame.origin.x, y: TopicsCollectionView.frame.origin.y, width: TopicsCollectionView.frame.size.width, height: TopicsCollectionView.contentSize.height)
            
            /*
            CompaniesCollectionView.frame = CGRect(x: CompaniesCollectionView.frame.origin.x, y: CompaniesCollectionView.frame.origin.y + TopicsCollectionView.frame.size.height, width: CompaniesCollectionView.frame.size.width, height: CompaniesCollectionView.contentSize.height)
            */
            
            
            self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
            TopicsCollectionView.reloadData()
            
            
            //------------------------dynamic height of scroll view---------------
            
//            InnerScrollView.frame = CGRect(x: 0, y: 0, width: InnerScrollView.frame.width, height: InnerScrollView.frame.height + TopicsCollectionView.frame.height + TopicsCollectionView.frame.origin.y)
//            
//            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: InnerScrollView.frame.height)
            
            
            self.CompaniesCollectionView.reloadData()
            
            
            
            
            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
            
            self.CompaniesCollectionView.layoutIfNeeded()
            
            self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
            
            // self.TopicsCollectionView.frame.origin.y + self.TopicsCollectionView.frame.height + 99
            
            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
            
            self.CompaniesCollectionView.reloadData()
            
            //------------------------dynamic height of scroll view---------------
            
            self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.CompaniesCollectionView.frame.origin.y + 950 + self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height)
            
            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
            
            
           // printarray()
        }
     
        txtTopic.text = nil
        
        
        
    }
 
    @IBAction func btnAddCompany(_ sender: UIButton) {
    
        
        if(txtCompany.text != nil && (txtCompany.text?.characters.count)! > 0)
        {
           
            
            //companyarray.append(txtCompany.text!)
            
            // This code is written to get the text in textfield store that in temp string and then split and store in temp array and append that to company array..
            
            let tempstr = txtCompany.text!
            
            let temparray = tempstr.components(separatedBy: ",")
            
            for element in 0...temparray.count-1
            {
                companyarray.append(temparray[element])
            }
            
             self.CompaniesCollectionView.reloadData()
            
            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
            
            self.CompaniesCollectionView.layoutIfNeeded()
            
            self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
            
            // self.TopicsCollectionView.frame.origin.y + self.TopicsCollectionView.frame.height + 99
            
            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
            
            self.CompaniesCollectionView.reloadData()
            
            //------------------------dynamic height of scroll view---------------
            
            self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: self.CompaniesCollectionView.frame.origin.y + 950 + self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height)
            
            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
            

            
            
            
            
            
            
            
//            CompaniesCollectionView.reloadData()
//            
//          
//            
//            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
//            
//            self.CompaniesCollectionView.layoutIfNeeded()
//            
//                CompaniesCollectionView.frame = CGRect(x: CompaniesCollectionView.frame.origin.x, y: CompaniesCollectionView.frame.origin.y, width: CompaniesCollectionView.frame.size.width, height: CompaniesCollectionView.contentSize.height)
//            
//            
//            
//            self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
//            
//            CompaniesCollectionView.reloadData()
//            
//            //------------------------dynamic height of scroll view---------------
//            
//            InnerScrollView.frame = CGRect(x: 0, y: 0, width: InnerScrollView.frame.width, height: InnerScrollView.frame.height + CompaniesCollectionView.frame.height + CompaniesCollectionView.frame.origin.y)
//            
//            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: InnerScrollView.frame.height)
        }
        
        txtCompany.text = nil

    
    }
    
    func printarray()
    {
        
            for element in topicarray
            {
                print(element)
                print(element.characters.count)
            }
        
    }

    @IBAction func deletecell(_sender:UIButton){
    
        let i : Int = (_sender.layer.value(forKey: "index")) as! Int
        topicarray.remove(at: i)
//        TopicsCollectionView.reloadData()
//    
//        
//        TopicsCollectionView.frame = CGRect(x: TopicsCollectionView.frame.origin.x, y: TopicsCollectionView.frame.origin.y, width: TopicsCollectionView.frame.size.width, height: TopicsCollectionView.contentSize.height)
//        
//        TopicsCollectionView.reloadData()
        
        
        TopicsCollectionView.reloadData()
        
        
        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
        self.TopicsCollectionView.layoutIfNeeded()
        
        TopicsCollectionView.frame = CGRect(x: TopicsCollectionView.frame.origin.x, y: TopicsCollectionView.frame.origin.y, width: TopicsCollectionView.frame.size.width, height: TopicsCollectionView.contentSize.height)
        
        /*
         CompaniesCollectionView.frame = CGRect(x: CompaniesCollectionView.frame.origin.x, y: CompaniesCollectionView.frame.origin.y + TopicsCollectionView.frame.size.height, width: CompaniesCollectionView.frame.size.width, height: CompaniesCollectionView.contentSize.height)
         */
        
        
        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        TopicsCollectionView.reloadData()
        
        
        //------------------------dynamic height of scroll view---------------
        
        //            InnerScrollView.frame = CGRect(x: 0, y: 0, width: InnerScrollView.frame.width, height: InnerScrollView.frame.height + TopicsCollectionView.frame.height + TopicsCollectionView.frame.origin.y)
        //
        //            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: InnerScrollView.frame.height)
        
        
        self.CompaniesCollectionView.reloadData()
        
        
        
        
        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        self.CompaniesCollectionView.layoutIfNeeded()
        
        self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
        
        // self.TopicsCollectionView.frame.origin.y + self.TopicsCollectionView.frame.height + 99
        
        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        self.CompaniesCollectionView.reloadData()
        
        //------------------------dynamic height of scroll view---------------
        
        self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height:  self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height + self.CompaniesCollectionView.frame.origin.y + 950)
        
        self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
        
        
    
    }
    
    @IBAction func deletecellCompany(_sender:UIButton){
        
        let i : Int = (_sender.layer.value(forKey: "index")) as! Int
        companyarray.remove(at: i)
        
//        CompaniesCollectionView.reloadData()
//        
//        CompaniesCollectionView.frame = CGRect(x: CompaniesCollectionView.frame.origin.x, y: CompaniesCollectionView.frame.origin.y, width: CompaniesCollectionView.frame.size.width, height: CompaniesCollectionView.contentSize.height)
//        CompaniesCollectionView.reloadData()
        
        
        TopicsCollectionView.reloadData()
        
        
        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
        self.TopicsCollectionView.layoutIfNeeded()
        
        TopicsCollectionView.frame = CGRect(x: TopicsCollectionView.frame.origin.x, y: TopicsCollectionView.frame.origin.y, width: TopicsCollectionView.frame.size.width, height: TopicsCollectionView.contentSize.height)
        
        /*
         CompaniesCollectionView.frame = CGRect(x: CompaniesCollectionView.frame.origin.x, y: CompaniesCollectionView.frame.origin.y + TopicsCollectionView.frame.size.height, width: CompaniesCollectionView.frame.size.width, height: CompaniesCollectionView.contentSize.height)
         */
        
        
        self.TopicsCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        TopicsCollectionView.reloadData()
        
        
        //------------------------dynamic height of scroll view---------------
        
        //            InnerScrollView.frame = CGRect(x: 0, y: 0, width: InnerScrollView.frame.width, height: InnerScrollView.frame.height + TopicsCollectionView.frame.height + TopicsCollectionView.frame.origin.y)
        //
        //            self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: InnerScrollView.frame.height)
        
        
        self.CompaniesCollectionView.reloadData()
        
        
        
        
        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        self.CompaniesCollectionView.layoutIfNeeded()
        
        self.CompaniesCollectionView.frame = CGRect(x: self.CompaniesCollectionView.frame.origin.x, y: self.TopicsCollectionView.frame.origin.y+99+self.TopicsCollectionView.frame.size.height, width: self.CompaniesCollectionView.frame.size.width, height: self.CompaniesCollectionView.contentSize.height)
        
        // self.TopicsCollectionView.frame.origin.y + self.TopicsCollectionView.frame.height + 99
        
        self.CompaniesCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        self.CompaniesCollectionView.reloadData()
        
        //------------------------dynamic height of scroll view---------------
        
        self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height:  self.CompaniesCollectionView.frame.height + self.TopicsCollectionView.frame.height + self.CompaniesCollectionView.frame.origin.y + 950)
        
        self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
    }


    
    func loadingurl()
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
            
 
            //let industryarray = industryArray.map({ $0["values"] ?? ""}) as [String]
            
            
            var arrayIndustry = [String]()
            
            for element in 0...industryArray.count-1
            {
                if(industryArray[element]["isSelected"] == "y")
                {
                 arrayIndustry.append(industryArray[element]["value"]!)
                }
            }
            
            
            var arrayFunctions = [String]()
            
            for element in 0...functionsArray.count-1
            {
                if(functionsArray[element]["isSelected"] == "y")
                {
                    arrayFunctions.append(functionsArray[element]["value"]!)
                }
            }
            
            var arrayPositions = [String]()
            
            for element in 0...positionsArray.count-1
            {
                if(positionsArray[element]["isSelected"] == "y")
                {
                    arrayPositions.append(positionsArray[element]["value"]!)
                }
            }
            
            var arrayIntents = [String]()
            
            for element in 0...intentArray.count-1
            {
                if(intentArray[element]["isSelected"] == "y")
                {
                    arrayIntents.append(intentArray[element]["value"]!)
                }
            }
          
            
            var radius:Double = 0
            
            if(sliderUI.upperValue == 1)
            {
                radius = 0.5
            }
            else if(sliderUI.upperValue == 2)
            {
                radius = 1
            }
            else if(sliderUI.upperValue == 3)
            {
                radius = 5
            }
            else if(sliderUI.upperValue == 4)
            {
                radius = 20
            }
            else if(sliderUI.upperValue == 5)
            {
                radius = 50
            }
            else
            {
                radius = 100
            }

            
        
            let parametersdataIndustry:[String : Any] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string!,"function_master_name": arrayFunctions,"industry_master_name":arrayIndustry,"intent_master_name":arrayIntents,"position_master_name":arrayPositions,"topics_name":topicarray,"company_name":companyarray,"user_radius":radius]
        
            print(parametersdataIndustry)
            
            
            Alamofire.request(baseUrl + "user/addupdate_user_fields", method: HTTPMethod.post, parameters: parametersdataIndustry as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ (apiresponseindustry) in
            
                if((apiresponseindustry.response) != nil)
                {
                
                    //print("industries stored..")
                    print(apiresponseindustry.result.value!)
                
                    //tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
                
                    //print(JSON(tempProfiles))
                
                
                }
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            
            }
        
            
            
        
        
        
       
            
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
            
            
            
            Alamofire.request(baseUrl + "user/get_user_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil)
                {
                    
                    //print(JSON(apiresponse.result.value!))
                    
                    tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
                    
                    //print(JSON(tempProfiles))
                    
                    
                    //loadingIndicator.stopAnimating()
                    
                    spinnerActivity.hide(animated: true)
                    
                    //customActivityIndicatory(self.view, startAnimate: false)
                    
                    //self.performSegue(withIdentifier: "SwipeView", sender: nil)
                    
                    //SwipingViewController
                    
                    let obj : SwipingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                    self.navigationController?.pushViewController(obj, animated: true)
                    
                    
                   //self.navigationController?.popToRootViewController(animated: true)

                    
                }
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }

            
            
            /*
             
             Alamofire.request(baseUrl + "user/get_user_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
             
             if((apiresponse.response) != nil)
             {
             
             print(JSON(apiresponse.result.value!))
             
             //tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
             
             //print(JSON(tempProfiles))
             
             /*
             if let m = tempProfiles.object(forKey: "otherUserProfiles") as Any?
             {
             print(JSON(m))
             
             }
             */
             
             }
             else
             {
             print("Error")
             }
             
             }
             
             */
            
            
   
        }
   
    }
   
    
    func signout()
    {
        
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
        
        
 
        for cookie in HTTPCookieStorage.shared.cookies! {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        UserDefaults.standard.synchronize()
    
 
        
        // Removes cache for all responses
        URLCache.shared.removeAllCachedResponses()
        
        UserDefaults.standard.removeObject(forKey: "userpersonalinfo")
        
        
        
        spinnerActivity.hide(animated: true)
        
        self.performSegue(withIdentifier: "Signout", sender: nil)
        
       
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
    
    
    @IBAction func ProfileDetails(_ sender: UIButton) {
        
        let obj : UserProfileInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileInfoViewController") as! UserProfileInfoViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 255/255)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0/255)
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
