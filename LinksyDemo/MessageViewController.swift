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
import CoreData
import SugarRecord
import JSQMessagesViewController


let sendmsgid = UserDefaults.standard

@available(iOS 10.0, *)


class MessageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    
    let baseUrl = "http://linksy.co/api/index.php/"
    
    
    @IBOutlet weak var btnBackToSwipe: UIButton!
    
    static var imgcount = 1
    
    
    var images = ["random-user1","random-user2","random-user3","random-user4","random-user5","random-user1","random-user2","random-user3","random-user4","random-user5"]
    var names = ["Kim Jacobs","Justin Walker","Shannon Adams","Denise Ruiz","Willard Thomas","Kim Jacobs","Justin Walker","Shannon Adams","Denise Ruiz","Willard Thomas"]
    
    var time = ["Today, 12:21pm","Yesterday, 10:21am","Today, 12:21am","Yesterday, 10:21pm","Today, 09:21am","Yesterday, 08:21am","Today, 12:21pm","Yesterday, 10:21am","Today, 12:21am","Yesterday, 10:21pm","Today, 09:21am","Yesterday, 08:21am"]
    
    
    @IBOutlet weak var MessageCollectionView: UICollectionView!
    
    
    @IBOutlet weak var labelNoChat: UILabel!
    
    var refreshControl: UIRefreshControl!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMatches(_:)), name: NSNotification.Name(rawValue: "MatchNotification"), object: nil)
        
        
        labelNoChat.isHidden = true
        
        
        self.MessageCollectionView.delegate = self
        self.MessageCollectionView.dataSource = self
        
        
        btnBackToSwipe.addTarget(self, action: #selector(backToSwipe), for: .touchUpInside)
        
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        MessageCollectionView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
      
        self.refresh()
        
        
        /*
         
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
        
        
        
        
        let tempselfinfo = JSON(userpersonalinfo.object(forKey: "userpersonalinfo"))
        
        
        
        
        // ----------------------------------Storing Core Data datas-----------------------------
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        //---------------------------------------------------------------------------------------
        
        
        // Selecting data from data base...
        
        
        let requests = NSFetchRequest<NSFetchRequestResult>(entityName : "Chat_List")
        
        requests.returnsObjectsAsFaults = false
        
        do
        {
            
            
            let x = JSON(MsgList.object(forKey: "MsgList"))
            
            let results = try context.fetch(requests)
            
            if results.count > 0
            {
                var flag:Bool = false
                
                OuterLoop: for i in 0...x["User's Chat List"].count-1
                {
                    InnerLoop: for result in results as! [NSManagedObject]
                    {
                        if (x["User's Chat List"][i]["chat_id"].stringValue == result.value(forKey: "chat_id") as? String)
                        {
                            print("Match id same")
                            
                            flag = true
                            
                            break InnerLoop
                            
                        }
                        
                    }
                    
                    if(flag == true)
                    {
                        flag = false
                        
                        continue OuterLoop
                    }
                    else
                    {
                        let Userchatid = NSEntityDescription.insertNewObject(forEntityName: "Chat_List", into: context)
                        
                        Userchatid.setValue(x["User's Chat List"][i]["chat_id"].stringValue, forKey: "chat_id")
                        
                    }
                    
                }
            }
            else
            {
                
                
                for i in 0...x["User's Chat List"].count-1
                {
                    let Userchatid = NSEntityDescription.insertNewObject(forEntityName: "Chat_List", into: context)
                    
                    
                    Userchatid.setValue(x["User's Chat List"][i]["chat_id"].stringValue, forKey: "chat_id")
                    
                    do
                    {
                        try context.save()
                        
                        print("Chat id Saved in internal database")
                        
                    }
                    catch
                    {
                        print("error")
                    }
                }
                
            }
        }
        catch
        {
            
        }
        
        
        
        // code for inseriting messages into chats table for storing messages....
        
        
        // Selecting data from data base...
        
        
        let request_chats = NSFetchRequest<NSFetchRequestResult>(entityName : "Chats")
        
        request_chats.returnsObjectsAsFaults = false
        
        do
        {
            
            let resultsforchats = try context.fetch(request_chats)
            
            let results = try context.fetch(requests)
            
            
            if resultsforchats.count > 0
            {
                
                var flag:Bool = false
                
                OuterLoop: for result in results as! [NSManagedObject]
                {
                    print(result.value(forKey: "chat_id"))
                    
                    InnerLoop: for resultmsg in resultsforchats as! [NSManagedObject]
                    {
                        print(resultmsg.value(forKey: "chat_id"))
                        
                        if (result.value(forKey: "chat_id") as? String == resultmsg.value(forKey: "chat_id") as? String)
                        {
                            print("chat id same chat is already present..")
                           
                            flag = true
                            
                            break InnerLoop
                            
                        }
                        
                    }
                    
                    if(flag == true)
                    {
                        
                        
                        let requestMaxMsgId = NSFetchRequest<NSFetchRequestResult>(entityName : "Chats")
                        
                        requestMaxMsgId.returnsObjectsAsFaults = false
                        
                        let sortDescriptor = NSSortDescriptor(key: "message_id", ascending: false)
                        
                        requestMaxMsgId.sortDescriptors = [sortDescriptor]
                        
                        requestMaxMsgId.predicate = NSPredicate(format: "chat_id == %@" , result.value(forKey: "chat_id") as! String)
                        
                        do
                        {
                            
                            let resultsMaxMsgId = try context.fetch(requestMaxMsgId) as? [NSManagedObject]
                            
                            for i in resultsMaxMsgId as! [NSManagedObject]
                            {
                                print(i.value(forKey: "message_id"))
                                
                                
                            }
                            
                            let max = resultsMaxMsgId?.first
                            
                            print(max?.value(forKey: "message_id") as! Int16)
                            
                            
                            let getchatdata:[String : Any] = ["user_id": tempselfinfo["linkedin_login"][0]["user_id"].string! ,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": result.value(forKey: "chat_id") as! String , "chat_message_id": max?.value(forKey: "message_id") as! Int16]
                            
                            Alamofire.request(baseUrl + "user/chat_conversation_msgs_new", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
                                { (apiresponseMsgs) in
                                    
                                    if((apiresponseMsgs.response) != nil)
                                    {
                                        let x = JSON(apiresponseMsgs.result.value!)
                                        
                                        print(x)
                                        
                                        if(x["chat_conversation_detail"].count > 0)
                                        {
                                            
                                            for i in 0...x["chat_conversation_detail"].count-1
                                            {
                                                
                                                // Storing Core Data
                                                
                                                
                                                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: context)
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_id"].stringValue, forKey: "chat_id")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_from"].stringValue, forKey: "sent_by")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_to"].stringValue, forKey: "sent_to")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_id"].int16Value, forKey: "message_id")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_type"].stringValue, forKey: "message_type")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_image"].stringValue, forKey: "message_img")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_created_time"].stringValue, forKey: "message_time")
                                                
                                                newUser.setValue(x["sender_img"].stringValue, forKey: "sender_img")
                                                
                                                newUser.setValue(self.decodeEmojiMsg(x["chat_conversation_detail"][i]["chat_message_text"].string!) , forKey: "message_text")
                                                
                                                newUser.setValue("false", forKey: "message_readFlag")
                                                
                                                
                                                
                                                do
                                                {
                                                    try context.save()
                                                    
                                                    print("New Messages for present chat Saved in internal database")
                                                    
                                                    
                                                }
                                                catch
                                                {
                                                    //inserting process error...
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                            }
                           
                        }
                        catch
                        {
                            
                        }
                       
                        
                        flag = false
                        
                        continue OuterLoop
                        
                    }
                    else
                    {
                        
                            let getchatdata:[String : String] = ["user_id": tempselfinfo["linkedin_login"][0]["user_id"].string! ,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": result.value(forKey: "chat_id") as! String]
                            
                            Alamofire.request(baseUrl + "user/chat_conversation_msgs", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
                                { (apiresponseMsgs) in
                                    
                                    if((apiresponseMsgs.response) != nil)
                                    {
                                        let x = JSON(apiresponseMsgs.result.value!)
                                        
                                        if(x["chat_conversation_detail"].count > 0)
                                        {
                                            for i in 0...x["chat_conversation_detail"].count-1
                                            {
                                                
                                                // Storing Core Data
                                                
                                                print(x["chat_conversation_detail"][i]["chat_message_id"].int16Value)
                                                
                                                
                                                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: context)
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_id"].stringValue, forKey: "chat_id")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_from"].stringValue, forKey: "sent_by")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_to"].stringValue, forKey: "sent_to")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_id"].int16Value, forKey: "message_id")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_type"].stringValue, forKey: "message_type")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_image"].stringValue, forKey: "message_img")
                                                
                                                newUser.setValue(x["chat_conversation_detail"][i]["chat_message_created_time"].stringValue, forKey: "message_time")
                                                
                                                newUser.setValue(x["sender_img"].stringValue, forKey: "sender_img")
                                                
                                                newUser.setValue(self.decodeEmojiMsg(x["chat_conversation_detail"][i]["chat_message_text"].string!) , forKey: "message_text")
                                                
                                                newUser.setValue("false", forKey: "message_readFlag")
                                                
                                                
                                                
                                                do
                                                {
                                                    try context.save()
                                                    
                                                    print("Messages Saved in internal database")
                                                    
                                                    
                                                }
                                                catch
                                                {
                                                    //inserting process error...
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                            }
                        
                    }
                    
                }
            }
            else
            {
                for result in results as! [NSManagedObject]
                {
                    let getchatdata:[String : String] = ["user_id": tempselfinfo["linkedin_login"][0]["user_id"].string! ,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": result.value(forKey: "chat_id") as! String]
                    
                    Alamofire.request(baseUrl + "user/chat_conversation_msgs", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
                        { (apiresponseMsgs) in
                            
                            if((apiresponseMsgs.response) != nil)
                            {
                                let x = JSON(apiresponseMsgs.result.value!)
                                
                                if(x["chat_conversation_detail"].count > 0)
                                {
                                    for i in 0...x["chat_conversation_detail"].count-1
                                    {
                                        
                                        // Storing Core Data
                                        
                                        
                                        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: context)
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_id"].stringValue, forKey: "chat_id")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_from"].stringValue, forKey: "sent_by")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_to"].stringValue, forKey: "sent_to")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_id"].int16Value, forKey: "message_id")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_type"].stringValue, forKey: "message_type")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_image"].stringValue, forKey: "message_img")
                                        
                                        newUser.setValue(x["chat_conversation_detail"][i]["chat_message_created_time"].stringValue, forKey: "message_time")
                                        
                                        newUser.setValue(x["sender_img"].stringValue, forKey: "sender_img")
                                        
                                        newUser.setValue(self.decodeEmojiMsg(x["chat_conversation_detail"][i]["chat_message_text"].string!) , forKey: "message_text")
                                        
                                        newUser.setValue("false", forKey: "message_readFlag")
                                        
                                        
                                        
                                        do
                                        {
                                            try context.save()
                                            
                                            print("All Messages Saved in internal database first time")
                                            
                                            
                                        }
                                        catch
                                        {
                                            //inserting process error...
                                            
                                        }
                                    }
                                    
                                }
                            }
                            
                    }
                }
            }
        }
        catch
        {
            
        }
        
        
        spinnerActivity.hide(animated: true)
        
        */
        
        
    }
 
 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
               
        let tempx = JSON(MsgList.object(forKey: "MsgList")!)
        
        if(tempx["User's Chat List"].count == 0)
        {
            
            labelNoChat.isHidden = false
        }
        
        
        return tempx["User's Chat List"].count
        
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let msgcell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCollectionViewCell
        
        
        if let userinfo = MsgList.object(forKey: "MsgList") as Any?
        {
            let tempdata = JSON(userinfo)
            
            
            print(tempdata)
            
            //print(tempdata["User's Chat List"][0]["msg_name"])
            //print(tempdata["User's Chat List"][1]["msg_name"])
            
            
            msgcell.labelMatchName.text = tempdata["User's Chat List"][indexPath.row]["msg_name"].string!
            
            msgcell.labelMsgTime.text = tempdata["User's Chat List"][indexPath.row]["chat_created_time"].string!
            
            if(tempdata["User's Chat List"][indexPath.row]["last_msg"].string == "empty")
            {
                
                
                msgcell.labelLastMsg.text = "No Messages To Show yet"
            }
            else if(tempdata["User's Chat List"][indexPath.row]["last_msg"].string == "no message")
            {
                msgcell.labelLastMsg.text = "Image"
            }
                
            else
            {
                //decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!)
                
                msgcell.labelLastMsg.text = decodeEmojiMsg(tempdata["User's Chat List"][indexPath.row]["last_msg"].string!)
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
            
            //self.performSegue(withIdentifier: "MsgTOChat", sender: nil)
            
            let obj : ChatOutViewViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatOutViewViewController") as! ChatOutViewViewController
            self.navigationController?.pushViewController(obj, animated: true)
            
            
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
            
            
            let baseUrl = "http://linksy.co/api/index.php/"
            
            let tempdata = JSON(userinfo)
            let parametersdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! ]
            
            
            
            Alamofire.request(baseUrl + "user/get_user_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil)
                {
                   
                    tempProfiles.set(apiresponse.result.value, forKey: "otherUserProfiles")
                    
                    spinnerActivity.hide(animated: true)
                    
                    
                    //self.performSegue(withIdentifier: "MessageToSwipe", sender: nil)
                    
                    //let obj : SwipingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SwipingViewController") as! SwipingViewController
                    //self.navigationController?.pushViewController(obj, animated: true)
                    
                    
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
    
    /*
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
            
            
            Alamofire.request(self.baseUrl + "user/user_chat_list", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                
                if((apiresponse.response) != nil)
                {
                    
                    //print("gettig chat list successfully")
                    
                    print(JSON(apiresponse.result.value!))
                    
                    MsgList.set(apiresponse.result.value, forKey: "MsgList")
                   
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
        
        MessageCollectionView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func decodeEmojiMsg(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
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
