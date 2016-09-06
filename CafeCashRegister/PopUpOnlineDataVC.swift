//
//  PopUpOnlineDataVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 06/09/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class PopUpOnlineDataVC: UIViewController {

    @IBOutlet weak var dataUrl: UITextField!
    @IBOutlet weak var imagesUrl: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
        self.showAnimate()
        getPathFromLocalSorage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Local storage methods
    
    func getPathFromLocalSorage(){
    

        
        if let dataUrlStored = defaults.stringForKey(RemoteDataKeys.dataUrl) {
            dataUrl.text = dataUrlStored;
        }
        
        if let imagesUrlStored = defaults.stringForKey(RemoteDataKeys.imagesUrl) {
            imagesUrl.text = imagesUrlStored
        }
    }
    
    
    
    //MARK: Buttons
    
    @IBAction func Save(sender: AnyObject) {
    
        
        defaults.setValue(dataUrl.text, forKey: RemoteDataKeys.dataUrl)
        defaults.setValue(imagesUrl.text, forKey: RemoteDataKeys.imagesUrl)
        
        defaults.synchronize()
    
        
        self.removeAnimate()
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        
        
        //self.view.removeFromSuperview()
        self.removeAnimate()
        
    }
    
    //MARK: Animations
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
        
    
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }


 

}
