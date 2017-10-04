//
//  ChatOutViewViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 23/08/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD

var msgsenderinfo = UserDefaults.standard

var chatId = UserDefaults.standard

let chatMsgArray = UserDefaults.standard

class ChatOutViewViewController: UIViewController {

    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
         
        if let msglistinfo = MsgList.object(forKey: "MsgList") as Any?
        {
            
            let tempmsglist = JSON(msglistinfo)
            
            let tempmatchcellselected:Int = MatchCellSelected.object(forKey: "MatchCellSelected") as! Int
            
            labelName.text = tempmsglist["User's Chat List"][tempmatchcellselected]["msg_name"].string
            
            
           // print(tempmsglist)
           //print(tempmsglist["User's Chat List"][tempmatchcellselected]["chat_id"])
            
            /*
            let chat_id = tempmsglist["User's Chat List"][tempmatchcellselected]["chat_id"].string
            
            print(chat_id!)
            
            chatId.set(chat_id, forKey: "chatId")
            */
            
            
            if let imgURL = NSURL(string: tempmsglist["User's Chat List"][tempmatchcellselected]["msg_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL)
                {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    imgProfile.image = img
                   
                    
                    
                }
            }
            
            //print(tempmsglist)
            
        }
        
        else
        {
            let tempmsglist = JSON((msgsenderinfo.object(forKey: "msgsenderinfo"))!)
            
            labelName.text = tempmsglist["body"]["name"].string!
            
            
            
            if let imgURL = NSURL(string: tempmsglist["body"]["image"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL)
                {
                    
                    let img = UIImage(data: imgdata as Data)
                    
                    imgProfile.image = img
                    
                    
                    
                }
            }
 
            
        }
 
        
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnBack(_ sender: UIButton) {
        
      
        
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
                    
                    self.performSegue(withIdentifier: "ChatToMessage", sender: nil)
                    
                    
                    
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
