//
//  SettingsViewController.swift
//  Unit Three Lesson Two Part Six
//
//  Created by David Molloy on 24/03/2015.
//  Copyright (c) 2015 riis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var whiteBtn: UIButton!
    @IBOutlet weak var selectedColor: UIButton!
    @IBOutlet weak var RGBColor: UIButton!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        whiteBtn.layer.borderColor = UIColor.blackColor().CGColor
        whiteBtn.layer.borderWidth = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("red") != nil{
            let red = CGFloat(defaults.floatForKey("red"))
            let green = CGFloat(defaults.floatForKey("green"))
            let blue = CGFloat(defaults.floatForKey("blue"))
            selectedColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectColor(sender: AnyObject) {
        
        selectedColor.backgroundColor = sender.backgroundColor
        
        getRGBValues()
    }
    
    @IBAction func RGBSlider(sender: AnyObject) {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        
        RGBColor.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func getRGBValues(){
        var numComponents: UInt!
        var color: UIColor = selectedColor.backgroundColor!
        numComponents = CGColorGetNumberOfComponents(color.CGColor)
        if numComponents == 4{
            var components: UnsafePointer <CGFloat> = CGColorGetComponents(color.CGColor)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setFloat(Float(components[0]), forKey: "red")
            defaults.setFloat(Float(components[1]), forKey: "green")
            defaults.setFloat(Float(components[2]), forKey: "blue")
            defaults.synchronize()
        }
    }
    
}
