//
//  dummyViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 14/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LinkedinSwift
import MBProgressHUD


//var userpersonalinfo = [JSON]()


let userpersonalinfo = UserDefaults.standard
let linkedinparameters = UserDefaults.standard

let linkedinHelper = LinkedinSwiftHelper(configuration:
    LinkedinSwiftConfiguration(
        clientId: "7802515wwt4ny3",
        clientSecret: "4AVbSU8PwyYDHPIU",
        state: "DLKDJF45DIWOERCM",
        permissions: ["r_basicprofile", "r_emailaddress","rw_company_admin","w_share"],
        redirectUrl: "http://barodacoders.com/linksy/"
    )
    
)


var loadingIndicator = UIActivityIndicatorView()



@available(iOS 10.0, *)
class dummyViewController: UIViewController{

    
    let baseUrl = "http://linksy.co/api/index.php/"
    
    
    //let parametersdata:[String : String] = ["login_type":"linkedin","oauth2_access_token":"AQUOxSqFxmJJkeuGQ-ArmF4qDt6fhapGNlnBGjUyudQW5skxqTEWSgBs1yKopWb015Y737WF-E015-UdhC-ceAuZPzMJbYbNRuQN07Grxmh8--CNgesg4H5Iei985bv4hrcymiiwwZvom3Biu9iag6bbBEI3hMzWNIiuHup6D7EPJyPXelU","linkedin_id":"CphZ4m2hOL"]
    
    var parametersdata:[String : Any] = [:]
    
    //let parametersdata:[String : String] = ["login_type":"linkedin","oauth2_access_token":"AQWMRkEuDi5FlPZiYbBbiZ8iLW-5z14UUrr9DocIjUUPG48HHgCiLbnLGHBt3b4SELFKOdi6Fhh413mj5gW_xhsCYoniV_dg3d1zQDe3YJ0skAsIxS7z4cg2URPHipaTdzmzW6Va7PArETUZgKsJqBPs95GpuuhUI8g9QSZlOq742h9XOSs","linkedin_id":"f0J3h6Whyv"]
    
    
    
    //let parameters = ["login_type": "linkedin", "oauth2_access_token":"AQWMRkEuDi5FlPZiYbBbiZ8iLW-5z14UUrr9DocIjUUPG48HHgCiLbnLGHBt3b4SELFKOdi6Fhh413mj5gW_xhsCYoniV_dg3d1zQDe3YJ0skAsIxS7z4cg2URPHipaTdzmzW6Va7PArETUZgKsJqBPs95GpuuhUI8g9QSZlOq742h9XOSs","linkedin_id": "f0J3h6Whyv"] as Dictionary<String, String>
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        
        //------------------- code for initioalizing the loading indicator ---------------------
        
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        loadingIndicator.transform = transform
        loadingIndicator.center = self.view.center
        loadingIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(loadingIndicator)
        
        //------------------- code for initioalizing the loading indicator End ---------------------
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    
    @IBAction func loginbtn(_ sender: UIButton) {
        
        
        //--------------------------- this is code for login in Linkedin Account and getting the Auth Access Token -----------------------
        
        
        
        linkedinHelper.authorizeSuccess({(lsToken) -> Void in
            
            //print("Login success lsToken: \(lsToken)")
            
            let AuthAcess = lsToken.accessToken
            
            print(AuthAcess!)
            
            //loadingIndicator.startAnimating()
            
            
             //------------------- code for initioalizing the loading indicator ---------------------
            
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
            
            
            
            
            // this code is to get the profile info of user...
            
            linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                //print("Request success with response: \(response)")
                
                let temp = JSON(response.jsonObject)
                
                print(temp["id"])
                
                let Authid = temp["id"].string
                
                self.parametersdata = ["login_type":"linkedin","oauth2_access_token": AuthAcess! , "linkedin_id": Authid!,"device_token": device_token!,"user_latitude" : latMagnitude , "user_longitude" : longMagnitude]
                
            
                linkedinparameters.set(self.parametersdata, forKey: "linkedinparameters")
                
                //loadingIndicator.startAnimating()
                

                Alamofire.request(self.baseUrl+"linkedin/linkedin_login", method: HTTPMethod.post, parameters: self.parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
                    
                
                    
                    if((apiresponse.response) != nil)
                    {
                        print(apiresponse.result.value!)
                        
                        userpersonalinfo.set(apiresponse.result.value, forKey: "userpersonalinfo")
                        
                        //loadingIndicator.stopAnimating()
                        
                        
                        spinnerActivity.hide(animated: true)
                        
                        //self.performSegue(withIdentifier: "ProfileSegue", sender: nil)
                        
                        let obj : ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(obj, animated: true)
                    
                        
                        /*
                         
                         if let m = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                         {
                         print(JSON(m))
                         
                         }
                         
                        */
 
                        
                        //print(apiresponse.result.value)
                        
                        
                    }
                    else
                    {
                        print("Error")
                        
                        let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
                
                
                
            }) {(error) -> Void in
                
                print("Encounter error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Error 404", message: "Please check your network Connection and try again", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
        
            
        }, error: {(error) -> Void in
            
            print("Encounter error: \(error.localizedDescription)")
       
            
            
        }, cancel: { () -> Void in
            
            print("User Cancelled!")
        })

      
        
        
        
        
        /*
 
        Alamofire.request(baseUrl+"linkedin/linkedin_login", method: HTTPMethod.post, parameters: parametersdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (apiresponse) in
            
            if((apiresponse.response) != nil)
            {
                
                userpersonalinfo.set(apiresponse.result.value, forKey: "userpersonalinfo")
              
                
                /*
 
                    if let m = userpersonalinfo.object(forKey: "userpersonalinfo") as Any?
                    {
                            print(JSON(m))

                    }
 
                */
 
                print(apiresponse.result.value)
                
                
            }
            else
            {
                print("Error")
            }
            
        }

        
     */
 
        
        /*
        
        let url1 = URL(string: baseUrl + "linkedin/linkedin_login")
        
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url1!)
        
        request.httpMethod = "POST"
       
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = httpBody
       
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            
            if(error != nil)
            {
                print("Error")
            }
            
            else{
               
                do{
                    //let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(json)
                  
                    //print(self.parameters)
                    
                    print(data!)
                    
                }
                
                catch{
                
                    print("Error2")
                }
                
                
            }
        }
        
        task.resume()
 
 
        */
        
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

    
    
    
    
    
    /*
     
     // This is code for the SwiftyJson Library...
     
     
     // let apijson =  apiresponse.result.value
     
     // print(apijson!)
     
     
     //let apijson = JSON(apiresponse.result.value)
     
     
     //print(apijson)
     
     /*
     
     //this code is used for parsing the data
     
     let x = JSON(apiresponse.result.value)
     
     print(x.type)
     
     let y = x["linkedin_login"]
     
     print(y.type)
     
     print(y[0]["user_email"])
     
     */
     
     //let tempuserinfo = apijson["linkedin_login"]
     
     
     //print(tempuserinfo)
     
     
     
     /*
     
     this code is used to store the tempuser data in json array and accessing the values...
     
     userpersonalinfo = [tempuserinfo]
     
     let tempemailid = userpersonalinfo[0][0]["user_firstName"]
     
     print(userpersonalinfo)
     print(tempemailid)
     
     */
     
     
     */
    
  
}
