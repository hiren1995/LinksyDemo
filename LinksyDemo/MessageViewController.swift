//
//  MessageViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 21/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

let sendmsgid = UserDefaults.standard

class MessageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    
    
    @IBOutlet weak var btnBackToSwipe: UIButton!
    
    
    var images = ["random-user1","random-user2","random-user3","random-user4","random-user5","random-user1","random-user2","random-user3","random-user4","random-user5"]
    var names = ["Kim Jacobs","Justin Walker","Shannon Adams","Denise Ruiz","Willard Thomas","Kim Jacobs","Justin Walker","Shannon Adams","Denise Ruiz","Willard Thomas"]
    
    var time = ["Today, 12:21pm","Yesterday, 10:21am","Today, 12:21am","Yesterday, 10:21pm","Today, 09:21am","Yesterday, 08:21am","Today, 12:21pm","Yesterday, 10:21am","Today, 12:21am","Yesterday, 10:21pm","Today, 09:21am","Yesterday, 08:21am"]
    
    
    @IBOutlet weak var MessageCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
        
        self.MessageCollectionView.delegate = self
        self.MessageCollectionView.dataSource = self
        
        
        btnBackToSwipe.addTarget(self, action: #selector(backToSwipe), for: .touchUpInside)
        
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
               
        let tempx = JSON(MsgList.object(forKey: "MsgList")!)
        
        return tempx["User's Chat List"].count
        
        
        
       // return images.count
        
       
        
        //return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let msgcell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCollectionViewCell

        
        
       if let userinfo = MsgList.object(forKey: "MsgList") as Any?
        {
            let tempdata = JSON(userinfo)
            
            
            //print(tempdata)
            
            //print(tempdata["User's Chat List"][0]["msg_name"])
            //print(tempdata["User's Chat List"][1]["msg_name"])
            
  
            msgcell.labelMatchName.text = tempdata["User's Chat List"][indexPath.row]["msg_name"].string!
            
            msgcell.labelMsgTime.text = tempdata["User's Chat List"][indexPath.row]["chat_created_time"].string!
            
            if(tempdata["User's Chat List"][indexPath.row]["last_msg"].string == "empty")
            {
                
                
                msgcell.labelLastMsg.text = "No Messages To Show yet"
            }
            
            
            else
            {
                msgcell.labelLastMsg.text = tempdata["User's Chat List"][indexPath.row]["last_msg"].string!
            }
            
            
            
            if let imgURL = NSURL(string: tempdata["User's Chat List"][indexPath.row]["msg_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL)
                {
                    
                    let img = UIImage(data: imgdata as Data)
            
                    msgcell.imgMatchProfilePic.image = img
                    msgcell.imgMatchProfilePic.layer.cornerRadius = 30
                    
                    
                }
            }
            
        }

        
        
        
        //let msgcell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCollectionViewCell
        
        //msgcell.imgMatchProfilePic.layer.cornerRadius = 30
        //msgcell.imgMatchProfilePic.image = UIImage(named: images[indexPath.row])
        //msgcell.labelMatchName.text = names[indexPath.row]
        //msgcell.labelMsgTime.text = time[indexPath.row]
        
        
        return msgcell
        
        
    }

    
    //this function is used for resizing the collectionview cell with dynamically according to the screen width...
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let cellSize:CGSize = CGSize(width: self.MessageCollectionView.frame.width, height: 78)
        
        return cellSize
    }
    
 
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
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
        
        let indexValueOfCell = indexPath.row
        
        //print(indexValueOfCell)
        
        MatchCellSelected.set(indexValueOfCell, forKey: "MatchCellSelected")
        
        
        if let msglistinfo = MsgList.object(forKey: "MsgList") as Any?
        {
            
            let userinfo = userpersonalinfo.object(forKey: "userpersonalinfo")
            
            let tempdata = JSON(userinfo!)
            
            
            let tempmsglist = JSON(msglistinfo)
            
            let tempmatchcellselected:Int = MatchCellSelected.object(forKey: "MatchCellSelected") as! Int
            
            //labelName.text = tempmsglist["User's Chat List"][tempmatchcellselected]["msg_name"].string
            
            
            // print(tempmsglist)
            //print(tempmsglist["User's Chat List"][tempmatchcellselected]["chat_id"])
            
            let chat_id = tempmsglist["User's Chat List"][tempmatchcellselected]["chat_id"].string
            
            var sendmsg_id : String? = nil
            
            if(tempmsglist["User's Chat List"][tempmatchcellselected]["message_from"].string == tempdata["linkedin_login"][0]["user_id"].string!)
            {
                sendmsg_id = tempmsglist["User's Chat List"][tempmatchcellselected]["message_to"].string
            }
            else
            {
                sendmsg_id = tempmsglist["User's Chat List"][tempmatchcellselected]["message_from"].string

            }
            
            //print(sendmsg_id!)
            
            //print(chat_id!)
            
            chatId.set(chat_id, forKey: "chatId")
            sendmsgid.set(sendmsg_id, forKey: "sendmsgid")
            
            //loadingIndicator.stopAnimating()
            
            spinnerActivity.hide(animated: true)
            
            self.performSegue(withIdentifier: "MsgTOChat", sender: nil)
            
            
            
        }
        
        
        
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
                    
                    
                    self.performSegue(withIdentifier: "MessageToSwipe", sender: nil)
                    
                    
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
    
        
    @IBAction func BtnMatch(_ sender: UIButton) {
        
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
                    
                    self.performSegue(withIdentifier: "msglistToConnectionList", sender: nil)
                    
                    
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
                
                
                Alamofire.request(self.baseUrl + "user/user_chat_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                    
                    if((apiresponse.response) != nil)
                    {
                        
                        //print("gettig chat list successfully")
                        
                        print(JSON(apiresponse.result.value!))
                        
                        MsgList.set(apiresponse.result.value, forKey: "MsgList")
                        
                        
                        self.MessageCollectionView.reloadData()
                        
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
