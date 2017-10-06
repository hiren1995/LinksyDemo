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

class ChatScreenViewController: JSQMessagesViewController {
    
    
    //NotificationCenter.default.addObserver(self , selector: #selector(loadMessages), name: "MessageNotification", object: nil)
    
    
    var x:JSON = JSON.null
    
    
    let baseUrl = "https://bulale.in/linksy/api/index.php/"
    
    var parametersdata:[String : String] = [:]
    
    private var messages = [JSQMessage]()
    
    let selfinfo = userpersonalinfo.object(forKey: "userpersonalinfo")
    
    let incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).incomingMessagesBubbleImage(with: UIColor.lightGray)
    let outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with: UIColor(red: 24/255, green: 187/255, blue: 236/255, alpha: 1.0))
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "MessageNotification"))
    }
    
    
   
     override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.senderId = "1"
        //self.senderDisplayName = "Hiren Kadam"
        
        
        
        
        
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
      
        let chat_id = JSON((chatId.object(forKey: "chatId"))!)
        
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
                        for i in 0...self.x["chat_conversation_detail"].count-1
                        {
                            if(self.x["chat_conversation_detail"][i]["chat_message_from"].string == tempselfinfo["linkedin_login"][0]["user_id"].string!)
                            {
                                self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!)))
                                
                                //messages.append(JSQMessage(senderId: "30" , displayName: "sender", text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                
                                self.collectionView.reloadData()
                                
                                
                                
                                // Storing Core Data
                                
                                
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                let context = appdelegate.persistentContainer.viewContext
                                
                                
                                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: context)
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_id"].stringValue, forKey: "chat_id")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_from"].stringValue, forKey: "sent_by")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_to"].stringValue, forKey: "sent_to")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_id"].stringValue, forKey: "message_id")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_type"].stringValue, forKey: "message_type")
                                
                                newUser.setValue(self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!) , forKey: "message_text")
                                
                                do
                                {
                                    try context.save()
                                    
                                    print("User Saved in internal database")
                                    
                                    
                                }
                                catch
                                {
                                    //inserting process error...
                                    
                                }
                                
                                
                            }
                            else
                            {
                                //messages.append(JSQMessage(senderId:temp["chat_conversation_detail"][i]["chat_message_to"].string , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                
                                self.messages.append(JSQMessage(senderId: self.x["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!)))
                                
                                //messages.append(JSQMessage(senderId: "25" , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                                self.collectionView.reloadData()
                                
                                // Storing Core Data
                                
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                let context = appdelegate.persistentContainer.viewContext
                             
                                
                                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: context)
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_id"].stringValue , forKey: "chat_id")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_to"].stringValue, forKey: "sent_by")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_from"].stringValue, forKey: "sent_to")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_id"].stringValue, forKey: "message_id")
                                
                                newUser.setValue(self.x["chat_conversation_detail"][i]["chat_message_type"].stringValue, forKey: "message_type")
                                
                                newUser.setValue(self.decodeEmojiMsg(self.x["chat_conversation_detail"][i]["chat_message_text"].string!) , forKey: "message_text")
                                
                                do
                                {
                                    try context.save()
                                    
                                    print("User Saved in internal database")
                                    
                                    
                                }
                                catch
                                {
                                    //inserting process error...
                                    
                                }
                                
                            }
                            
                            //print(messages[i])
                            
                        }
                        
                        //loadingIndicator.stopAnimating()
                        
                        spinnerActivity.hide(animated: true)
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
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                //-------------------- this is to move to present messages ----------------
                self.automaticallyScrollsToMostRecentMessage = true
                
                
        }

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
       
      
    }
   
    // JSQMessages collection view functions...
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
       // let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        
        //return temp["chat_conversation_detail"].count
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellchat = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        //cellchat.frame = CGRect(x: 0, y: 68, width: self.view.frame.width, height: self.view.frame.height - cellchat.textView.frame.height)
        
        //cellchat.frame =
        
        return cellchat
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        /*
 
        let temp = JSON((chatMsgArray.object(forKey: "chatMsgArray"))!)
        let tempselfinfo = JSON(selfinfo!)
        
        
        
        for i in 0...temp["chat_conversation_detail"].count-1
        {
            if(temp["chat_conversation_detail"][i]["chat_message_from"].string == tempselfinfo["linkedin_login"][0]["user_id"].string!)
            {
                 messages.append(JSQMessage(senderId: temp["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                
                //messages.append(JSQMessage(senderId: "30" , displayName: "sender", text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
            }
            else
            {
                 //messages.append(JSQMessage(senderId:temp["chat_conversation_detail"][i]["chat_message_to"].string , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                
                 messages.append(JSQMessage(senderId: temp["chat_conversation_detail"][i]["chat_message_from"].string , displayName: "sender", text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
                
                //messages.append(JSQMessage(senderId: "25" , displayName: "Receiver" , text: temp["chat_conversation_detail"][i]["chat_message_text"].string))
            }
       
            print(messages[i])
        
        }
        
        */
        
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        //let bubblefactory = JSQMessagesBubbleImageFactory()
        
        //return bubblefactory?.outgoingMessagesBubbleImage(with: UIColor(red: 24/255, green: 187/255, blue: 236/255, alpha: 1.0))
        
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
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
    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func loadMessages(_ notification : NSNotification)
    {
        
        
        print("Msg notification receioved..")
        
        //print(notification.userInfo?["send_chat_message"][0]["chat_message_text"])
        
        let tempnotify = JSON((notification.userInfo)!)
        
        print(tempnotify["body"]["text_msg"])
       
        
        let tempsendid = JSON((sendmsgid.object(forKey: "sendmsgid"))!)
        
        
        
        self.messages.append(JSQMessage(senderId: tempsendid.string , displayName: "sender", text: decodeEmojiMsg(tempnotify["body"]["text_msg"].string!)))
        
        self.collectionView.reloadData()
        
        
        self.automaticallyScrollsToMostRecentMessage = true
       
        
        
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

