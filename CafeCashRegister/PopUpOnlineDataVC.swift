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

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        self.showAnimate()
        getPathFromLocalSorage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Local storage methods
    
    func getPathFromLocalSorage(){
    

        if let dataUrlStored = defaults.string(forKey: RemoteDataKeys.dataUrl) {
            dataUrl.text = dataUrlStored;
        }
        
        if let imagesUrlStored = defaults.string(forKey: RemoteDataKeys.imagesUrl) {
            imagesUrl.text = imagesUrlStored
        }
    }
    
    
    
    //MARK: Buttons
    
    @IBAction func Save(_ sender: AnyObject) {
    
        
        defaults.setValue(dataUrl.text, forKey: RemoteDataKeys.dataUrl)
        defaults.setValue(imagesUrl.text, forKey: RemoteDataKeys.imagesUrl)
        
        defaults.synchronize()
    
        
        self.removeAnimate()
    }
    
    @IBAction func Cancel(_ sender: AnyObject) {
        
        
        //self.view.removeFromSuperview()
        self.removeAnimate()
        
    }
    
    //MARK: Animations
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }


 

}
