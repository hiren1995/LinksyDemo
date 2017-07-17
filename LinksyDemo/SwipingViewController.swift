//
//  SwipingViewController.swift
//  LinksyDemo
//
//  Created by APPLE MAC MINI on 14/07/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit


class SwipingViewController: UIViewController {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
   
    
    @IBOutlet weak var SwipeView: ZLSwipeableView!
  
    
    var reloadBarButtonItem: UIBarButtonItem!
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var colorIndex = 0
    var loadCardsFromXib = false
    
    
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

        // Do any additional setup after loading the view.
        
        
        //btncancel.tintColor = UIColor.red
        //btnselect.tintColor = UIColor(red: 6/255, green: 96/255, blue: 147/255, alpha: 1)
        
        SwipeView.backgroundColor = UIColor.green
        
        reloadBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadButtonAction))
        leftBarButtonItem = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(leftButtonAction))
        rightBarButtonItem = UIBarButtonItem(title: "→", style: .plain, target: self, action: #selector(rightButtonAction))
        
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [fixedSpace, reloadBarButtonItem!, flexibleSpace, leftBarButtonItem!, flexibleSpace, rightBarButtonItem!, fixedSpace]
        toolbarItems = items
        
        
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
 
        
        
    }
    
    func reloadButtonAction() {
        let alertController = UIAlertController(title: nil, message: "Load Cards:", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let ProgrammaticallyAction = UIAlertAction(title: "Programmatically", style: .default) { (action) in
            self.loadCardsFromXib = false
            self.colorIndex = 0
            self.SwipeView.discardViews()
            self.SwipeView.loadViews()
        }
        alertController.addAction(ProgrammaticallyAction)
        
        let XibAction = UIAlertAction(title: "From Xib", style: .default) { (action) in
            self.loadCardsFromXib = true
            self.colorIndex = 0
            self.SwipeView.discardViews()
            self.SwipeView.loadViews()
        }
        alertController.addAction(XibAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func leftButtonAction() {
        self.SwipeView.swipeTopView(inDirection: .Left)
    }
    
    func rightButtonAction() {
        self.SwipeView.swipeTopView(inDirection: .Right)
    }
    
    
    
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }
        
        
        let cardView = CardView(frame: SwipeView.bounds)
        cardView.backgroundColor = colorForName(colors[colorIndex])
        colorIndex += 1
        loadCardsFromXib = true
        if loadCardsFromXib {
            let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! UIView
            //contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.backgroundColor = cardView.backgroundColor
            cardView.addSubview(contentView)
            
            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            /*// Alternative:
             let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
             let views = ["contentView": contentView, "cardView": cardView]
             cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
             cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
             */
            
           
            constrain(contentView, cardView) { view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
 
            }
            
        }
        return cardView
    }
    
    
    func colorForName(_ name: String) -> UIColor {
        //let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        //let selector = "flat\(sanitizedName)Color"
        //return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
        
        return UIColor.white
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
