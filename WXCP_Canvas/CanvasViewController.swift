//
//  ViewController.swift
//  WXCP_Canvas
//
//  Created by Will Xu  on 10/18/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrowView: UIImageView!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var newlyCreatedFace: UIImageView!
    var trayOriginalCenter: CGPoint!
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 240
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func selected(_ sender: UIPanGestureRecognizer) {
        var velocity = (sender as AnyObject).velocity(in: view)
        let translation = (sender as AnyObject).translation(in: view)
        if (sender as AnyObject).state == .began {
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            UIView.animate(withDuration:0.2, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            view.addSubview(newlyCreatedFace)
        } else if (sender as AnyObject).state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if (sender as AnyObject).state == .ended {
            UIView.animate(withDuration:0.2, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            if (self.newlyCreatedFace.center.y > trayView.center.y - trayView.frame.height/2) {
                self.newlyCreatedFace.removeFromSuperview()
            }
        }
    }

    @objc func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration:0.2, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration:0.2, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            if (self.newlyCreatedFace.center.y > trayView.center.y - trayView.frame.height/2) {
                self.newlyCreatedFace.removeFromSuperview()
            }
        }
    }
    
    @IBAction func didPanTray(_ sender: Any) {
        var velocity = (sender as AnyObject).velocity(in: view)
        let translation = (sender as AnyObject).translation(in: view)
        if (sender as AnyObject).state == .began {
            trayOriginalCenter = trayView.center
        } else if (sender as AnyObject).state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if (sender as AnyObject).state == .ended {
            if (velocity.y > 0) {
                UIView.animate(withDuration:0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,
                               options: [],
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                                self.arrowView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                }, completion: nil)
            } else if (velocity.y < 0) {
                UIView.animate(withDuration:0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,
                               options: [],
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                                self.arrowView.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
}

