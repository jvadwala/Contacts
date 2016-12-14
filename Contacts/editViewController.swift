//
//  editViewController.swift
//  Contacts
//
//  Created by Jay Vadwala on 2015-12-20.
//  Copyright © 2015 Jay Vadwala. All rights reserved.
//

import UIKit
import CoreData



//Class to edit the Contact information
class editViewController: UIViewController, UITextFieldDelegate{
    
    var editEntity: JsonData?
    
    let manageContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var CompanyName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBOutlet weak var Street: UITextField!
    
    
    @IBOutlet weak var email_id: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var countryName: UITextField!
    
    //viewDidload will load the contact information pass from detail_view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.phoneNumber.keyboardType = UIKeyboardType.PhonePad
        self.phoneNumber.returnKeyType = UIReturnKeyType.Done
        phoneNumber.delegate = self
        nameField.delegate  = self
        CompanyName.delegate  = self
        Street.delegate  = self
        city.delegate  = self
        countryName.delegate  = self
        email_id.delegate  = self
        
        
        
        nameField.text = editEntity?.name
        CompanyName.text = editEntity?.company
        phoneNumber.text = editEntity?.home
        Street.text = editEntity?.street
        city.text = editEntity?.city
        countryName.text = editEntity?.country
        email_id.text = editEntity?.email
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if(textField == nameField){
            return
        }
        if(textField  == CompanyName){
            return
        }
        if(textField  == phoneNumber){
            return
        }
        
        animateViewMoving(true, moveValue:100)
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
        if(textField == nameField){
            return
        }
        if(textField  == CompanyName){
            return
        }
        if(textField  == phoneNumber){
            return
        }
        
        animateViewMoving(false, moveValue:100)
        
    }
    
    //class to move the view when keyboard appears/disappears
    func animateViewMoving(up:Bool, moveValue:CGFloat)
    {
        let movementDuration: NSTimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    @IBAction func saveData(sender: AnyObject) {
 
        editEntity!.name = nameField.text
        editEntity!.company  = CompanyName.text
        editEntity!.home = phoneNumber.text
        editEntity!.email = email_id.text
        editEntity!.street  = Street.text
        editEntity!.city  = city.text
        editEntity!.country  = countryName.text
        
        g_entity = editEntity
        
        
        do{
            try self.manageContext.save()
            print("Saved Succesfully")
        } catch{
            print("Error in saving data")
            let alert_box = UIAlertView(title: "Error", message: "Unsuccesful in updating contacts", delegate: nil, cancelButtonTitle: "Ok")
            
            alert_box.show()
            
            
        }
        coming_from_edit_View = true;
        let alert_box = UIAlertView(title: "Success", message: "Contact information is updated", delegate: nil, cancelButtonTitle: "Ok")
        alert_box.show()
        
        
    }
    
    //calls this function when user press enter key
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //will caus ethe keyboard to disappear
        textField.resignFirstResponder()
        return true;
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
