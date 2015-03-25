//
//  ViewController.swift
//  Unit Three Lesson Two Part Six
//
//  Created by David Molloy on 24/03/2015.
//  Copyright (c) 2015 riis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var lastPoint = CGPoint.zeroPoint
    var color: CGColorRef = UIColor.grayColor().CGColor
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false

    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var tempView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainView.layer.borderColor = UIColor.blackColor().CGColor
        mainView.layer.borderWidth = 1
        
        tempView.layer.borderColor = UIColor.blackColor().CGColor
        tempView.layer.borderWidth = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("red") != nil{
            let red = CGFloat(defaults.floatForKey("red"))
            let green = CGFloat(defaults.floatForKey("green"))
            let blue = CGFloat(defaults.floatForKey("blue"))
            color = UIColor(red: red, green: green, blue: blue, alpha: 1).CGColor
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clear(sender: AnyObject) {
        mainView.image = nil
    }
    
    @IBAction func save(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainView.bounds.size)
        mainView.image?.drawInRect(CGRect(x:0, y:0, width: mainView.frame.size.width, height: mainView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        swiped = false
        if let touch = touches.anyObject() as? UITouch{
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetStrokeColorWithColor(context, color)
        
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        CGContextStrokePath(context)
        
        tempView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {

        swiped = true
        if let touch = touches.anyObject() as? UITouch{
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if !swiped{
            //draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        //merge tempView into mainView
        UIGraphicsBeginImageContext(mainView.frame.size)
        mainView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
        tempView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
        mainView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempView.image = nil
    }
}

