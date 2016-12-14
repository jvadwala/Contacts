//
//  detailViewController.swift
//  Contacts
//
//  Created by Jay Vadwala on 2015-12-20.
//  Copyright © 2015 Jay Vadwala. All rights reserved.
//

import UIKit
import CoreData

var g_entity: JsonData?   //global variable which gets updated once editView controller updates the data
var coming_from_edit_View: Bool? // to check if we came here because of edit_view or contact_list view

class detailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    var detailEntity:JsonData?
    
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var homeNumber: UILabel!
    @IBOutlet weak var CompanyName: UILabel!
    
    @IBOutlet weak var bDay: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var Zip_Code: UILabel!
    @IBOutlet weak var State: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var street: UILabel!
    
    // to get the managedObjectContext object to get hold of core data
    
    let manageContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //here in view did load we will update the detail view with the data pass on from contact_view selected cell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = detailEntity
        
        let image = UIImage(data : d!.hImage!)
        detailImage.layer.borderWidth = 1.0
        detailImage.layer.masksToBounds = true
        detailImage.layer.borderColor = UIColor.blackColor().CGColor
        detailImage.layer.cornerRadius = 50.0
        
        detailImage.image = image
        
        contactName.text = d?.name
        CompanyName.text  = d?.company
        homeNumber.text  = d?.home
        street.text = d?.street
        City.text = (d?.city)! + "," + (d?.state)!  + " " + (d?.zip)!
        email.text  = d?.email
        //parse the string date and convert it to data format
        let birthday = (d?.birthdate)! as String
        
        let timeinterval: NSTimeInterval = (birthday as NSString).doubleValue
        
        let dateFromServer = NSDate(timeIntervalSince1970: timeinterval)
        
        let dateFormater : NSDateFormatter = NSDateFormatter()
        dateFormater.dateFormat = "MMMM dd, YYYY"
        
        bDay.text = dateFormater.stringFromDate(dateFromServer)
    }
    
    
    override func viewWillAppear(animated: Bool)  {
        if(coming_from_edit_View == true) {
            contactName.text = g_entity?.name
            CompanyName.text  = g_entity?.company
            homeNumber.text  = g_entity?.home
            street.text = g_entity?.street
            City.text = (g_entity?.city)! + "," + (g_entity?.state)!  + " " + (g_entity?.zip)!
            email.text  = g_entity?.email
        }
        coming_from_edit_View = false
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    //view transition from detail view to editView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let editView = segue.destinationViewController as! editViewController
        
        editView.editEntity = self.detailEntity
        
        
    }
    
    
}
