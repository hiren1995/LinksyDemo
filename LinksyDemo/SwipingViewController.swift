//
//  SwipingViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 14/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Pulsator
import MBProgressHUD

var MsgList = UserDefaults.standard
var ConnList = UserDefaults.standard




class SwipingViewController: UIViewController {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var imgsymbol: UIImageView!
   
    
    @IBOutlet var ViewRipple: UIView!
    
    @IBOutlet var ImgRipple: UIImageView!
    
    @IBOutlet var ViewBtn: UIView!
    
    let pulsator = Pulsator()
    
    
    @IBOutlet weak var dummyImgView: UIImageView! //for the ripple effect rotation..
    
    @IBOutlet weak var SwipeView: ZLSwipeableView!
  
    
    var reloadBarButtonItem: UIBarButtonItem!
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var SwipeIndex:Int = 0
    
    var swipedCardIndex = 0
   
    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    
    @IBOutlet weak var btnChatList: UIButton!
    
    
    @IBOutlet weak var btnConnectionList: UIButton!
    
    
    @IBOutlet weak var labelNoCards: UILabel!
    
    
    
    //var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    //var colorIndex = 0
    
    var loadCardsFromXib = false
    
    
    var tempotheruserdata:JSON = []
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
       
        
        
                SwipeView.nextView = {
                    return self.nextCardView()
                }
        
     
    }
 
    
    @IBAction func btnSelect(_ sender: UIButton) {
        
        self.SwipeView.swipeTopView(inDirection: .Right)
        //btnSelect.layer.backgroundColor = UIColor(red: 18/255, green: 171/255, blue: 217/255, alpha: 1.0).cgColor
        
        
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        
        self.SwipeView.swipeTopView(inDirection: .Left)
        //btnCancel.layer.backgroundColor = UIColor(red: 156/255, green: 158/255, blue: 158/255, alpha: 1.0).cgColor
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        loadingIndicator.color = UIColor.white
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(loadingIndicator)

        
        btnChatList.addTarget(self, action: #selector(loadMsgList), for: .touchUpInside)
       
        btnConnectionList.addTarget(self, action: #selector(loadConnectionList), for: .touchUpInside)
        
        
    
        
        
         // ----------------------Below is the code for the Ripple effect-----------------
        
        /*
        
        print("This is code for ripple effect..")
         
         if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
         {
            let tempdata = JSON(userinfo)
         
            if let imgURL = NSURL(string: tempdata["linkedin_login"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
         
                    let img = UIImage(data: imgdata as Data)
         
                    self.ImgRipple.image = img
         
                }
            }
         
         }
         
        
         self.view.layer.addSublayer(self.pulsator)
         self.pulsator.start()
         self.pulsator.numPulse = 4
         self.pulsator.radius = 240.0
         self.pulsator.backgroundColor = UIColor(red: 24/255 , green: 187/255, blue: 236/255, alpha: 1).cgColor
         
         
         //self.pulsator.frame = CGRect(x: self.view.center.x, y: self.view.center.y , width: self.pulsator.frame.width, height: self.pulsator.frame.height)
         
         self.pulsator.position = self.view.center
         
         self.pulsator.animationDuration = 5.0
         
         ImgRipple.layer.zPosition = 1
         
         */
         
         //---------------------------------------------------------
    
 
    
        
        if let otheruserinfo = tempProfiles.object(forKey: "otherUserProfiles") as Any?
        {
            tempotheruserdata = JSON(otheruserinfo)
            
            //print(tempotheruserdata.type)
            
            print(tempotheruserdata)
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        SwipeView.backgroundColor = UIColor.white
        
        SwipeView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
            
            
        }
        SwipeView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        SwipeView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        
        
        SwipeView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
            
            if(direction == Direction.Right)
            {
               // print("card swiped right")
               // print(self.swipedCardIndex)
              
                
                if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                {
                    let tempdata = JSON(userinfo)
                    
                    //print(tempdata)
                    
                    
                    
                    let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ,"user_likes_whom": self.tempotheruserdata["get_user_details"][self.swipedCardIndex]["user_id"].string! ]
                    
                    //print(parametersdata)
                    
                    
                    Alamofire.request(self.baseUrl + "user/user_like", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                        
                        if((apiresponse.response) != nil)
                        {
                            
                            print("user was liked successfully..")
                            
                        }
                        else
                        {
                            print("Error")
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                self.swipedCardIndex = self.swipedCardIndex + 1
                
                
            }
            
            else
            {
                    print("card swiped left")
                    print(self.swipedCardIndex)
                
               
                
                if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                {
                    let tempdata = JSON(userinfo)
                    
                    //print(tempdata)
                    
                    
                    
                    let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ,"user_likes_whom": self.tempotheruserdata["get_user_details"][self.swipedCardIndex]["user_id"].string! ]
                    
                    //print(parametersdata)
                    
                    
                    Alamofire.request(self.baseUrl + "user/user_dislike", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                        
                        if((apiresponse.response) != nil)
                        {
                            
                            print("user was unliked successfully..")
                            
                        }
                        else
                        {
                            print("Error")
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                
                    self.swipedCardIndex = self.swipedCardIndex + 1
            }
            
            
        }
        
        
        SwipeView.didCancel = {view in
            print("Did cancel swiping view")
        }
        SwipeView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        SwipeView.didDisappear = { view in
            print("Did disappear swiping view")
        }
        
    
        
        constrain(SwipeView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
        
        }
 
        
        
        self.imgsymbol.isHidden = true
        
        self.ViewBtn.isHidden = true
        
        self.SwipeView.isHidden = true

        // from here the control goes to view did load method where the animation starts
        
        
     
        
       /*
        
       UIView.animate(withDuration: 1.0, animations: {
        
                self.imgsymbol.transform = CGAffineTransform(rotationAngle: (30 * 3.14)/180)
        
        
       }) { (true) in
        
        
                UIView.animate(withDuration: 1.0, animations: {
                    self.imgsymbol.transform = CGAffineTransform(rotationAngle: (-30 * 3.14)/180)
                    
                    
                }, completion: { (true) in
                    
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        
                        self.imgsymbol.transform = CGAffineTransform(rotationAngle: (0 * 3.14)/180)
                        
                    }, completion: { (true) in
                        
                            UIView.animate(withDuration: 1.0, animations: {
                                
                                
                                self.imgsymbol.isHidden = true
                            })
                        
                    })
                })
        
        }
        
        */
 
        
       
        
}
    
    override func viewDidAppear(_ animated: Bool) {
        

        
        
        
        
        //-------------------------------------------Ripple Effect Code------------------------------------
        
        
        
        if let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
        {
            let tempdata = JSON(userinfo)
            
            if let imgURL = NSURL(string: tempdata["linkedin_login"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    self.ImgRipple.image = img
                    
                }
            }
            
        }
        
        
        self.view.layer.addSublayer(self.pulsator)
        self.pulsator.start()
        self.pulsator.numPulse = 4
        self.pulsator.radius = 240.0
        self.pulsator.backgroundColor = UIColor(red: 24/255 , green: 187/255, blue: 236/255, alpha: 1).cgColor
        
        
        //self.pulsator.frame = CGRect(x: self.view.center.x, y: self.view.center.y , width: self.pulsator.frame.width, height: self.pulsator.frame.height)
        
        self.pulsator.position = self.view.center
        
        self.pulsator.animationDuration = 5.0
        
        ImgRipple.layer.zPosition = 1

        
        //-------------------------------------------Ripple Effect Code------------------------------------
        
        
        
        UIView.animate(withDuration: 5.0, animations: {
        
        //UIView.animate(withDuration: 5.0, delay: 5.0 , options: UIViewAnimationOptions.allowAnimatedContent , animations: {
            
            
            //self.ImgRipple.transform = CGAffineTransform(rotationAngle: (30 * 3.14)/180)
            
            
            //self.ImgRipple.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            
            
            
            self.dummyImgView.transform = CGAffineTransform(rotationAngle: (30 * 3.14)/180)
            
            self.imgsymbol.isHidden = true
            
            self.ViewBtn.isHidden = true
            
            self.SwipeView.isHidden = true
            
            
            
            
        }) { (true) in
            
           let otheruserinfo = JSON(tempProfiles.object(forKey: "otherUserProfiles")!)
            
           
            UIView.animate(withDuration: 1.0, animations: {
                
               
                    
                
                
                    self.ImgRipple.isHidden = true
                
                    self.pulsator.isHidden = true
                
                    self.SwipeView.isHidden = false
                
                if(otheruserinfo["status"] != "failure")
                {
                    self.imgsymbol.isHidden = false
                    
                    self.ViewBtn.isHidden = false
                
                    
                }
                
                    self.imgsymbol.transform = CGAffineTransform(rotationAngle: (30 * 3.14)/180)
                    
                
               
                
                
            }) { (true) in
                
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.imgsymbol.transform = CGAffineTransform(rotationAngle: (-30 * 3.14)/180)
                    
                    
                    
                    
                }, completion: { (true) in
                    
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        
                        self.imgsymbol.transform = CGAffineTransform(rotationAngle: (0 * 3.14)/180)
                        
                        
                        
                    }, completion: { (true) in
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            
                            
                            self.imgsymbol.isHidden = true
                            
                            
                            
                            
                        })
                        
                    })
                })
                
            }
            
           
        
        }
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        //loadingIndicator.startAnimating()
        
        //------------------------------------ Code for setting the swipe cards data into the defaults-----------------
        
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
        
        //------------------------------------ Code for setting the swipe cards data into the defaults End----------------- 
        
        //loadingIndicator.stopAnimating()
    }
    
    
    
    func nextCardView() -> UIView? {
        
       //----------------------- code for loading the cards in bunch ------------------------
        
        
        if SwipeIndex >= tempotheruserdata["get_user_details"].count {
           
            //SwipeIndex = 0
           
            
            
            return nil
        }
        
        
        let cardView = CardView(frame: SwipeView.bounds)
        
        
        let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! CardView
       
        loadCardsFromXib = true
        
        if loadCardsFromXib 
        {
                //contentView.translatesAutoresizingMaskIntoConstraints = false
            
            
                    //print(tempotheruserdata["get_user_details"][SwipeIndex]["user_name"])
            
                //print(tempotheruserdata["get_user_details"][SwipeIndex])
            
                    
                    contentView.labelName.text = tempotheruserdata["get_user_details"][SwipeIndex]["user_firstName"].string! + " " + tempotheruserdata["get_user_details"][SwipeIndex]["user_lastName"].string!
            
                    contentView.labelCity.text = tempotheruserdata["get_user_details"][SwipeIndex]["user_city"].string!
            
            
                    if(tempotheruserdata["get_user_details"][SwipeIndex]["headline"].string == "--")
                    {
                        contentView.labelPosition.text = "Not Found"
                    }
                    else
                    {
                        contentView.labelPosition.text = tempotheruserdata["get_user_details"][SwipeIndex]["headline"].string
                        
                    }
            
            
                    if let imgURL = NSURL(string: tempotheruserdata["get_user_details"][SwipeIndex]["user_profilepic"].string!)
                    {
                        if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                                let img = UIImage(data: imgdata as Data)
                    
                                contentView.imgProfile.image = img
                    
                        }
                    }
            
            
            
                    contentView.backgroundColor = cardView.backgroundColor
          
                    
                    cardView.addSubview(contentView)
            
                // This is important:
                // https://github.com/zhxnlai/ZLSwipeableView/issues/9
                /*
                    // Alternative:
                    let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
                    let views = ["contentView": contentView, "cardView": cardView]
                    cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
                    cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
                */
            
            constrain(contentView, cardView)
            {
                view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
 
            }
        }
      
        SwipeIndex += 1

        return cardView
    }
    
    
    func colorForName(_ name: String) -> UIColor {
        //let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        //let selector = "flat\(sanitizedName)Color"
        //return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
        
        return UIColor.white
    }
    
    
    
    
    func  loadMsgList(){
        
        
        //---------------------------- code for loading msgs list in next view controller ---------------------
    
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
                    
                    print(JSON(apiresponse.result.value!))
                    
                    MsgList.set(apiresponse.result.value, forKey: "MsgList")
                    
                    
                    
                    //loadingIndicator.stopAnimating()
                   
                    spinnerActivity.hide(animated: true)
                    
                    

                    
                    // ----------- segue for loading next view controller
                    
                    self.performSegue(withIdentifier: "MsgSegue", sender: nil)
                    
                    
                    
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

        //---------------------------- code for loading msgs list in next view controller End ---------------------
    }
        
        
        func  loadConnectionList(){
            
            
            //---------------------------- code for loading connection list in next view controller ---------------------
            
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
                
                
                Alamofire.request(self.baseUrl + "user/user_matchs", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                    
                    if((apiresponse.response) != nil )
                    {
                        
                        //print("gettig chat list successfully")
                        print(apiresponse.result.value!)
                        
                        ConnList.set(apiresponse.result.value, forKey: "ConnList")
                        
                        
                        
                        
                        //loadingIndicator.stopAnimating()
                        
                        spinnerActivity.hide(animated: true)
                        
                        self.performSegue(withIdentifier: "ConnectionListSegue", sender: nil)
                        
                        
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

        //---------------------------- code for loading connection list in next view controller End ---------------------
        
    }
    
    
    
    @IBAction func backtoProfile(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SwipetoProfile", sender: nil)
        
        //let objViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        //self.navigationController?.pushViewController(objViewController, animated: true)
    
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
        
    
    
}

