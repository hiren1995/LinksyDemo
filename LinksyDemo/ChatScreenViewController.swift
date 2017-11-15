//
//  ChatScreenViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 21/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

import  SwiftyJSON

import JSQMessagesViewController

import Alamofire

import MBProgressHUD

import CoreData

import MobileCoreServices

import TOCropViewController

import Kingfisher



@available(iOS 10.0, *)

class ChatScreenViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate{
    
  
    //NotificationCenter.default.addObserver(self , selector: #selector(loadMessages), name: "MessageNotification", object: nil)
    
    
    var x:JSON = JSON.null
    
    var chat_id = JSON(chatId.object(forKey: "chatId")!)
    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    var parametersdata:[String : String] = [:]
    
    private var messages = [JSQMessage]()
    
    let selfinfo = userpersonalinfo.object(forKey: "userpersonalinfo")
    
    let incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).incomingMessagesBubbleImage(with: UIColor.lightGray)
    let outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with: UIColor(red: 24/255, green: 187/255, blue: 236/255, alpha: 1.0))
    

    let picker = UIImagePickerController()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "MessageNotification"))
    }

    
    override func viewDidLayoutSubviews() {
        
       // automaticallyScrollsToMostRecentMessage = true
        
        self.scrollToBottom(animated: true)
        
    }
    
    // View did load without local database connection....
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        picker.delegate = self
    
        
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
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
        
        
    
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMessages(_:)), name: NSNotification.Name(rawValue: "MessageNotification"), object: nil)
        
        
        if(selfinfo != nil)
        {
            let tempselfinfo = JSON(selfinfo!)
            
            self.senderId = tempselfinfo["linkedin_login"][0]["user_id"].string!
            self.senderDisplayName = tempselfinfo["linkedin_login"][0]["user_firstName"].string! + " " + tempselfinfo["linkedin_login"][0]["user_lastName"].string!
            
        }
        
        
       
        
        
        //let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        let tempselfinfo = JSON(selfinfo!)
        
        //let chat_id = JSON((chatId.object(forKey: "chatId"))!)
        
        print(chat_id)
        
       
        let getchatdata:[String : String] = ["user_id": tempselfinfo["linkedin_login"][0]["user_id"].string! ,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": chat_id.stringValue]
        
        print(getchatdata)
        
        
        
        
        
        Alamofire.request(baseUrl + "user/chat_conversation_msgs", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { (apiresponseMsgs) in
                
                if((apiresponseMsgs.response) != nil)
                {
                    
                    
                    self.x = JSON(apiresponseMsgs.result.value!)
                    
                    print(self.x)
                    
                    if(self.x["chat_conversation_detail"].count > 0)
                    {
                        spinnerActivity.hide(animated: true)
                        
                        for i in 0...self.x["chat_conversation_detail"].count-1
                        {
                           if(self.x["chat_conversation_detail"][i]["chat_message_type"].string == "1")
                           {
                               // self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!)))
                               // self.collectionView.reloadData()
                            
                            
                            
                            
                                let dateFormatter = DateFormatter()
                                //Specify Format of String to Parse
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
                            
                                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                            
                                //print(self.x["chat_conversation_detail"][i]["chat_message_created_time"].string!)
                            
                                //Parse into NSDate
                                let dateFromString  = dateFormatter.date(from: self.x["chat_conversation_detail"][i]["chat_message_created_time"].string!)

                                //print(dateFromString)
                            
                                self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string, senderDisplayName: "sender", date:dateFromString as Date! , text: self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!)))
 
                            
                            
                                self.collectionView.reloadData()
                            
                            
                            
                                self.finishReceivingMessage(animated: true)
                            
                            }
                            
                            else
                           {
                                let img = JSQPhotoMediaItem(image: UIImage(named: "loading.gif"))
                            
                                img?.appliesMediaViewMaskAsOutgoing = true
                            
                                //self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string, displayName: "sender", media : img))

                            
                            
                            
                             
                                let dateFormatter = DateFormatter()
                             
                                //Specify Format of String to Parse
                             
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
                             
                                //Parse into NSDate
                             
                                let dateFromString : NSDate = dateFormatter.date(from: self.x["chat_conversation_detail"][i]["chat_message_created_time"].stringValue)! as NSDate
                             
                            
                            
                                self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string, senderDisplayName: "sender", date: dateFromString as Date!, media: img))
                             
                            
 
                            
                            
                                self.collectionView.reloadData()
                            
                                KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: self.x["chat_conversation_detail"][i]["chat_message_image"].string!)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                                    
                                    
                                    img?.image = image
                                    
                                    self.collectionView.reloadData()
                                })
                            
                                /*
                                if let imgURL = NSURL(string: self.x["chat_conversation_detail"][i]["chat_message_image"].string!)
                                {
                                    print(imgURL)
                                    if let imgdata = NSData(contentsOf: imgURL as URL) {
                                        
                                        let pic = UIImage(data: imgdata as Data)!
                                        
                                        //let img = JSQPhotoMediaItem(image: pic)
                                        
                                        self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string, displayName: "sender", media : img))
                                    }
                                }
                            
                                self.collectionView.reloadData()
 
                                */
                            
                            }
                           
                        }
                        
                        
                    }
                    else
                    {
                        //loadingIndicator.stopAnimating()
                        
                        spinnerActivity.hide(animated: true)
                    }
                    
                }
                    
                else
                {
                    print("Error")
                    
                    let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    spinnerActivity.hide(animated: true)
                    
                    self.present(alert, animated: true, completion: nil)
                }
               
                
        }
     
        
        
    }
    
    
 
    // View did load with local database connection...
    
    /*
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.senderId = "1"
     
        //self.senderDisplayName = "Hiren Kadam"
        
        
        
        // Storing Core Data datas
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        //------------------------
        
        
        
     
        
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
 
 
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMessages(_:)), name: NSNotification.Name(rawValue: "MessageNotification"), object: nil)
        
       
        if(selfinfo != nil)
        {
            let tempselfinfo = JSON(selfinfo!)
            
            self.senderId = tempselfinfo["linkedin_login"][0]["user_id"].string!
            self.senderDisplayName = tempselfinfo["linkedin_login"][0]["user_firstName"].string! + " " + tempselfinfo["linkedin_login"][0]["user_lastName"].string!
            
        }
        
        
        //let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        let tempselfinfo = JSON(selfinfo!)
      
        //let chat_id = JSON((chatId.object(forKey: "chatId"))!)
        
        print(chat_id)
        
        let getchatdata:[String : String] = ["user_id": tempselfinfo["linkedin_login"][0]["user_id"].string! ,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": chat_id.stringValue]
        
        print(getchatdata)
        
        
        
        
        
        // Selecting data from data base...
        
        
        let requests = NSFetchRequest<NSFetchRequestResult>(entityName : "Chats")
        
        requests.returnsObjectsAsFaults = false
        
        do
        {
            
            
            
            
            let results = try context.fetch(requests)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    
                    
                    if let chat_id_str = result.value(forKey: "chat_id") as? String
                    {
                        if(chat_id_str == chat_id.stringValue)
                        {
                            print("chat_id = \(chat_id_str) ")
                            print(result.value(forKey: "message_img") as? String)
                            print(result.value(forKey: "message_text") as? String)
                            
                            /*
                            if let message_id =  result.value(forKey: "message_id") as? String
                            {
                                
                                print("message_id = \(message_id)")
                            }
                            
                            if let sent_by =  result.value(forKey: "sent_by") as? String
                            {
                                
                                print("sent_by = \(sent_by)")
                            }
                            
                            if let message_text =  result.value(forKey: "message_text") as? String
                            {
                                
                                print("message_text = \(message_text)")
                            }
 
                             */
                            
                            if(result.value(forKey: "message_img") as! String == "not found")
                            {
                                self.messages.append(JSQMessage(senderId: result.value(forKey: "sent_by") as! String , displayName: "sender", text: result.value(forKey: "message_text") as! String))
                                
                                spinnerActivity.hide(animated: true)
                                
                                self.collectionView.reloadData()
                                
                                finishReceivingMessage(animated: true)
                                
                            }
                            else
                            {
                                
                                let img = JSQPhotoMediaItem(image: UIImage(named: "loading.gif"))
                                
                                img?.appliesMediaViewMaskAsOutgoing = true
                                
                                //self.collectionView.reloadData()
                                
                                self.messages.append(JSQMessage(senderId: result.value(forKey: "sent_by") as! String, displayName: "sender", media : img))
                                
                                self.collectionView.reloadData()
                                
                                //finishReceivingMessage(animated: true)
                                
                                KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: result.value(forKey: "message_img") as! String)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                                    
                                    
                                    img?.image = image
                                    
                                    self.collectionView.reloadData()
                                })
                                
                               
                                
                                /*
                                if let imgURL = NSURL(string: result.value(forKey: "message_img") as! String)
                                {
                                    var pic:UIImage? = nil
                                    
                                    print(imgURL)
                                    if let imgdata = NSData(contentsOf: imgURL as URL) {
                                        
                                        pic = UIImage(data: imgdata as Data)!
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        pic = UIImage(named: "img_errorloading")
                                        
                                    }
                                    
                                    let img = JSQPhotoMediaItem(image: pic)
                                    
                                    
                                    
                                    self.messages.append(JSQMessage(senderId: result.value(forKey: "sent_by") as! String, displayName: "sender", media : img))
                                }
                                */
                                
                               
                                
                                   //spinnerActivity.hide(animated: true)
                                
                                    //self.collectionView.reloadData()
                                
                                
                            }
                            
                            
                            
                            
                        }
                        //print("chat_id = \(chat_id_str) ")
                        
                    }
                    
                  
                   
                }
                
                
            }
            
           
            
        }
        catch
        {
            
            
        }
     
 
    }
 */
    
    
  
    
    
    // JSQMessages collection view functions...
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
       // let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        
        //return temp["chat_conversation_detail"].count
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellchat = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
       
      
        
        return cellchat
        
        
    }
    
    
    //------------------------------------------------ code for showing date and sender name for each cell--------------------------------------------
    
    
   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        
        let message = messages[indexPath.row]
        
        /*
        
        if(message.senderId == self.senderId)
        {
            //let m:String = "hiren"
            
            let myString = message.date
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            
            
        }
            
        else
        {
            let myString = let myString = message.date
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            return mutableAttributedString
            
        }
        */
        
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
   
     /*
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        
        if(message.senderId == self.senderId)
        {
            //let m:String = "hiren"
            
            let myString = "abc"
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            return mutableAttributedString
            
        }
            
        else
        {
            let myString = "pqr"
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            return mutableAttributedString
            
        }
        
        return nil
    }
    
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.row]
        
        if(message.senderId == self.senderId)
        {
            //let m:String = "hiren"
            
            let myString = "hiren"
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            return mutableAttributedString
            
        }
        
        else
        {
            let myString = "xyz"
            let myAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            let mutableAttributedString = NSMutableAttributedString(string: myString, attributes: myAttributes)
            
            return mutableAttributedString
            
        }
        
        return nil
    }
  
     */
 
    
    //------------------------------------------------ code for showing date and sender name for each cell End --------------------------------------------
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
       
        
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        //let bubblefactory = JSQMessagesBubbleImageFactory()
        
        //return bubblefactory?.outgoingMessagesBubbleImage(with: UIColor(red: 24/255, green: 187/255, blue: 236/255, alpha: 1.0))
        
        
        
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    
    
    // code for avatar image when not connected to local db
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        var img = UIImage()
        
        //let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        
        let tempselfinfo = JSON(selfinfo!)
        
        let index = messages[indexPath.item]
        
        
        if(self.senderId == index.senderId)
        {
            //img = UIImage(named: "random-user1")!
            
            if let imgURL = NSURL(string: tempselfinfo["linkedin_login"][0]["user_profilepic"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    img = UIImage(data: imgdata as Data)!
                    
                }
            }
        }
        else
        {
            //img = UIImage(named: "bg")!
            if let imgURL = NSURL(string: x["sender_img"].string!)
            {
                if let imgdata = NSData(contentsOf: imgURL as URL) {
                    
                    img = UIImage(data: imgdata as Data)!
                    
                }
            }
            
        }
        
        
        
        //return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "random-user1"), diameter: 30)
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: img, diameter: 60)
    }
 
 
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let message =  self.messages[indexPath.row]
        if message.isMediaMessage == true{
            let mediaItem =  message.media
            if mediaItem is JSQPhotoMediaItem{
                let photoItem = mediaItem as! JSQPhotoMediaItem
                let image:UIImage = photoItem.image //UIImage obtained.
                
                print("image obtained...")
                
                let x = image.size.height
                let y = image.size.width
                
                
                print(x)
                print(y)
                
                let imgData = UIImageJPEGRepresentation(image, 80.0)! as NSData
                
                UserDefaults.standard.set(imgData, forKey: "imageZoom")
                
                let obj : MsgImageDisplayViewController = self.storyboard?.instantiateViewController(withIdentifier: "MsgImageDisplayViewController") as! MsgImageDisplayViewController
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            
        }
        
        
    }
    
    
    
    //code for avatar image when connected to local db
    
   /*
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        var img = UIImage()
        
        //let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        
        let tempselfinfo = JSON(selfinfo!)
        
        let index = messages[indexPath.item]
        
        
        // Storing Core Data datas
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        //------------------------
        
        
        let requests = NSFetchRequest<NSFetchRequestResult>(entityName : "Chats")
        
        requests.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(requests)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    
                    
                    if let chat_id_str = result.value(forKey: "chat_id") as? String
                    {
                        if(chat_id_str == chat_id.stringValue)
                        {
                            print("chat_id = \(chat_id_str) ")
                            
                            
                            if(result.value(forKey: "sent_by") as? String == self.senderId)
                            {
                                //img = UIImage(named: "random-user1")!
                                
                                if let imgURL = NSURL(string: tempselfinfo["linkedin_login"][0]["user_profilepic"].string!)
                                {
                                    if let imgdata = NSData(contentsOf: imgURL as URL) {
                                        
                                        img = UIImage(data: imgdata as Data)!
                                        
                                    }
                                }
                            }
                            else
                            {
                                //img = UIImage(named: "bg")!
                                if let imgURL = NSURL(string: result.value(forKey: "sender_img") as! String)
                                {
                                    if let imgdata = NSData(contentsOf: imgURL as URL) {
                                        
                                        img = UIImage(data: imgdata as Data)!
                                        
                                    }
                                }
                                
                            }
                            
                            
                        }
                        //print("chat_id = \(chat_id_str) ")
                        
                    }
                    
                   
                    
                }
                
                
            }
            
            
            
        }
        catch
        {
            
            
        }
 
 
        
        
       
        //return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "random-user1"), diameter: 30)
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: img, diameter: 60)
    }
    
    */
 
    
    
    
    // methods for sending message...
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        
        //below code appends the message array with the message we type in text view... then all the above methods are called...
       
        self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, text: text))
        
        collectionView.reloadData()
     
        self.finishSendingMessage()
        
        //---------------------------------------------- used to send the messageto database---------------------
        
        let tempselfinfo = JSON(selfinfo!)
        print(tempselfinfo)
        
        let tempsendid = JSON((sendmsgid.object(forKey: "sendmsgid"))!)
        print(tempsendid)
        
        let chatids = JSON((chatId.object(forKey: "chatId"))!)
        
        print(chatids)
        
        let sendingMsg = encodeEmojiMsg(text)
        print(sendingMsg)
       
        
        let sendmsgdata:[String : String] = ["user_id":tempselfinfo["linkedin_login"][0]["user_id"].string!,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": chatids.stringValue ,"chat_message_to": tempsendid.stringValue , "chat_message_type":"1","chat_message_text": sendingMsg]
        
        print(sendmsgdata)
        
        
        if(tempsendid != JSON.null)
        {
        Alamofire.request(self.baseUrl+"user/send_chat_message", method: HTTPMethod.post, parameters: sendmsgdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
            
            if((apiresponse.response) != nil)
            {
                print("meaasage sent successfully..")
               
            
                
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
    
    //-------------- code for selecting image on click of accessory button---------------
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Media Message", message: "Please Select a Media", preferredStyle: .actionSheet)
        
        let cancel =   UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {(alert:UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
            
            
        })
        
        alert.addAction(photos)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //---------------------- picker media function------------------------------------
    
    private func chooseMedia(type: CFString)
    {
        picker.mediaTypes = [type as String]
        
        //picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //var sendImg:UIImage? = nil
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.dismiss(animated: true, completion: nil)
            
            //sendImg = pic
            
            let cropVC = TOCropViewController(image: pic)
            
            cropVC.delegate = self
            
            cropVC.aspectRatioPickerButtonHidden = true
            cropVC.aspectRatioPreset = .presetSquare
            cropVC.aspectRatioLockEnabled = true
            cropVC.resetAspectRatioEnabled = false
            self.present(cropVC, animated: true, completion: nil)
            
            
            //print(sendImg)
            
            //let img = JSQPhotoMediaItem(image: pic)
            
            //self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, media : img))
            
        }
        else if let vid = info[UIImagePickerControllerMediaURL] as? URL
        {
            
            
        }
       
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        
        let img = JSQPhotoMediaItem(image: image)
        
        self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, media : img))
        
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
        
        //---------------------------------------------- used to send the messageto database---------------------
        
        let tempselfinfo = JSON(selfinfo!)
        print(tempselfinfo)
        
        let tempsendid = JSON((sendmsgid.object(forKey: "sendmsgid"))!)
        print(tempsendid)
        
        let chatids = JSON((chatId.object(forKey: "chatId"))!)
        
        print(chatids)
        
        //let image_data = UIImagePNGRepresentation(sendImg!)
        
        //let sendmsgdata:[String : Any] = ["user_id":tempselfinfo["linkedin_login"][0]["user_id"].string!,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": chatids.stringValue ,"chat_message_to": tempsendid.stringValue , "chat_message_type":"2","chat_message_image": image_data!]
        
        //print(sendmsgdata)
        
        if(tempsendid != JSON.null)
        {
            //let imgData = UIImagePNGRepresentation(sendImg!)
            
            let imgData = UIImageJPEGRepresentation(image, 80.0)
            
            print(imgData!.base64EncodedString())
            
            let parameters:[String : Any] = ["user_id":tempselfinfo["linkedin_login"][0]["user_id"].string!,"user_token": tempselfinfo["linkedin_login"][0]["user_token"].string! , "chat_id": chatids.stringValue ,"chat_message_to": tempsendid.stringValue , "chat_message_type":"2"]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imgData{
                    
                    multipartFormData.append(data, withName: "chat_message_image", fileName: "image.jpg", mimeType: "image/jpg")
                    
                }
                
            },to: "https://bulale.in/linksy/api/index.php/user/send_chat_message", encodingCompletion: { (result) in
                
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        
                        print(response.result.value)
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    
                }
                
            })
            
            
        }
      
       // dismiss(animated: true, completion: nil)
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func loadMessages(_ notification : NSNotification)
    {
        
        
        print("Msg notification received..")
        
        //print(notification.userInfo?["send_chat_message"][0]["chat_message_text"])
        
        let tempnotify = JSON((notification.userInfo)!)
        
        print(tempnotify["body"])
        
        print(tempnotify["body"]["text_msg"])
       
        
        let tempsendid = JSON((sendmsgid.object(forKey: "sendmsgid"))!)
        
        if(tempnotify["body"]["chat_id"] == chat_id)
        {
            if(tempnotify["body"]["text_msg"].stringValue == "Send You a Photo.")
            {
                /*
                if let imgURL = NSURL(string: tempnotify["body"]["text_img"].stringValue)
                {
                    print(imgURL)
                    if let imgdata = NSData(contentsOf: imgURL as URL) {
                        
                        let pic = UIImage(data: imgdata as Data)!
                        
                        let img = JSQPhotoMediaItem(image: pic)
                        
                        self.messages.append(JSQMessage(senderId: tempsendid.string , displayName: "sender", media : img))
                    }
                }
 
                
                self.collectionView.reloadData()
 
                 */
                
                
                let img = JSQPhotoMediaItem(image: UIImage(named: "loading.gif"))
                
                img?.appliesMediaViewMaskAsOutgoing = true
                
                self.messages.append(JSQMessage(senderId: tempsendid.string, displayName: "sender", media : img))
                
                self.collectionView.reloadData()
                
                KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: tempnotify["body"]["text_img"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                    
                    
                    img?.image = image
                    
                    self.collectionView.reloadData()
                })
            }
            else
            {
                self.messages.append(JSQMessage(senderId: tempsendid.string , displayName: "sender", text: decodeEmojiMsg(tempnotify["body"]["text_msg"].string!)))
                
                self.collectionView.reloadData()
                
                
               // self.automaticallyScrollsToMostRecentMessage = true
                
                
            }
            
            
        }
        
        /*
        let tempdata = JSON((userpersonalinfo.object(forKey: "userpersonalinfo"))!)
        
        print(tempdata)
        
        let chat_id = JSON((chatId.object(forKey: "chatId"))!)
        print(chat_id)
        
        let getchatdata:[String : String] = ["user_id": tempdata["linkedin_login"][0]["user_id"].string! ,"user_token": tempdata["linkedin_login"][0]["user_token"].string! , "chat_id": chat_id.stringValue]
        
        print(getchatdata)
        
        if(tempdata != JSON.null)
        {
             let tempselfinfo = JSON(selfinfo!)
            
            
            
            
            Alamofire.request(baseUrl + "user/chat_conversation_msgs", method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
                { (apiresponseMsgs) in
                    
                    if((apiresponseMsgs.response) != nil)
                    {
                        
                        
                        self.x = JSON(apiresponseMsgs.result.value!)
                        
                        if(self.x["chat_conversation_detail"].count > 0)
                        {
                            for i in 0...self.x["chat_conversation_detail"].count-1
                            {
                                if(self.x["chat_conversation_detail"][i]["chat_message_from"].string == tempselfinfo["linkedin_login"][0]["user_id"].string!)
                                {
                                    self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: self.x["chat_conversation_detail"][i]["chat_message_text"].string))
                                    
                                    //messages.append(JSQMessage(senderId: "30" , displayName: "sender", text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                    
                                    self.collectionView.reloadData()
                                    
                                    
                                }
                                else
                                {
                                    //messages.append(JSQMessage(senderId:temp["chat_conversation_detail"][i]["chat_message_to"].string , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                    
                                    self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: self.x["chat_conversation_detail"][i]["chat_message_text"].string))
                                    
                                    //messages.append(JSQMessage(senderId: "25" , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                    self.collectionView.reloadData()
                                }
                                
                                //print(messages[i])
                                
                            }
                            
                            
                        }
                        else
                        {
                            
                        }
                        
                    }
            }
           
        }
        
        */
      
    }

    func encodeEmojiMsg(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decodeEmojiMsg(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
   
    
   /*
        steps for implementingthe chat....
     
        1. download the libraray by pod
        2. import that libraray..
        3. set the viewcontroller to JSQMessagesViewController
        4. implement the collection view numberof items method..
        5. make the cell in collectionview cellforitemAt method...
        6. implement the JSQMessagesCollection view mthod which returns the JSQMessage Data...
        7. implement the method which sends the message in text view to screen that is didpresssend method...
        8. implement the bubblemessage image for the chat..using messageBubbleImage Data method..
        9. implement the avatarImageDataForItemAt for setting the sender image brsite the message bubble..
   */
}

