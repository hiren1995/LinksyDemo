//
//  SegueFromRight.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 03/10/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import Foundation
import UIKit

class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        //dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        
        /*
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
        
        */
        
        UIView.animate(withDuration: 0.25, animations: {
            
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }) { (true) in
            
            src.present(dst, animated: false, completion: nil)
            
        }
        
        
    }
}
