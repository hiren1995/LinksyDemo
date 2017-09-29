//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 5/24/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
class CardView: UIView {



    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelPosition: UILabel!
    
    @IBOutlet weak var labelCity: UILabel!
    
    var xyz = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func awakeFromNib() {
        
         //labelName.text = "Kartik"
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // Shadow
        
        /*
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        */
        
        
        
        layer.borderColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        
        //layer.borderColor = UIColor.black.cgColor
        
        layer.borderWidth = 0.5
        
        //Run karo me dekh raha hoon
      
       
        //run karo
      
        
        
        
             // Corner Radius
      //  layer.cornerRadius = 10.0;
    }
}
