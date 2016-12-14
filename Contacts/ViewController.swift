//
//  ViewController.swift
//  Contacts
//
//  Created by Jay Vadwala on 2015-12-19.
//  Copyright © 2015 Jay Vadwala. All rights reserved.
//

import UIKit
import CoreData

// main class to list contacts
class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    let manageContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var entity = [JsonData]()

    var json_url = "https://solstice.applauncher.com/external/contacts.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        
        
        // Get the data from core data and store it in entity array
        let request = NSFetchRequest(entityName: "JsonData")
        do{
            entity = try manageContext.executeFetchRequest(request) as! [JsonData]
            
        }catch {
            print("Fetching error")
        }
        
        //to prevent the call to remote server after calling once.
        if(entity.count == 0) {
            
            get_data_from_url(json_url)
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        let request = NSFetchRequest(entityName: "JsonData")
        do{
            entity = try manageContext.executeFetchRequest(request) as! [JsonData]
            
        }catch {
            print("Fetching error")
        }
        
        do_table_refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this function will get the json data
    func get_data_from_url(url:String)
    {
        
        
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            
            let json = NSString(data: data!, encoding: NSASCIIStringEncoding)
           
            self.extract_json(json!)
            
        }
        
        task.resume()
        
    }
    
    //this function is called to parse the json string once we have the json and save the data in core data
    func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        } catch let error as NSError {
            parseError = error
            json = nil
        }
        //go through each json data and save it in core data
        if (parseError == nil)
        {
            if let response = json as? NSArray
            {
                for (var i = 0; i < response.count ; i++ )
                {
                    if let data_block = response[i] as? NSDictionary
                    {
                        let storeDescription = NSEntityDescription.entityForName("JsonData", inManagedObjectContext: manageContext)
                        let jsonData = JsonData(entity: storeDescription!, insertIntoManagedObjectContext: manageContext)
                        
                        jsonData.sImage = nil
                        jsonData.hImage = nil
                        
                        let details = data_block["detailsURL"] as! String
                        
                        jsonData.sImageUrl = data_block["smallImageURL"] as? String
                        
                        jsonData.company = data_block["company"] as? String
                        jsonData.name  =  data_block["name"] as? String
                        
                        jsonData.birthdate  = data_block["birthdate"] as? String
                        
                        let detailurl:NSURL! = NSURL(string: details)
                        
                        let detailData: NSData! = NSData(contentsOfURL: detailurl)
                        //this do clause is to parse the detail url string
                        do{
                            let detailresponse = try NSJSONSerialization.JSONObjectWithData(detailData, options: []) as! NSDictionary
                            
                            
                            jsonData.favorite  = detailresponse["favorite"] as? Bool
                            jsonData.hImageUrl = detailresponse["largeImageURL"] as? String
                            jsonData.email = detailresponse["email"] as? String
                            jsonData.website = detailresponse["website"] as? String
                            
                            let address = detailresponse["address"] as? NSDictionary
                            
                            jsonData.street = address!["street"] as? String
                            jsonData.city  =  address!["city"] as? String
                            jsonData.country  =  address!["country"] as? String
                            jsonData.zip  = address!["zip"] as? String
                            jsonData.state = address!["state"]  as? String
                            
                        }  catch {
                            print("json error: ")
                        }
                        
                        let numbers = data_block["phone"] as! NSDictionary
                        jsonData.work = numbers["work"] as? String
                        jsonData.home = numbers["home"] as? String
                        
                        let mobile = numbers["mobile"] as? String
                        if(mobile == nil) {
                            jsonData.mobile = ""
                        } else {
                            jsonData.mobile = mobile
                        }
                        
                        
                        do{
                            try self.manageContext.save()
                            //  print("Saved")
                        } catch{
                            print("Error in saving data")
                        }
                        
                    }
                }
                
                
                //fill the entity array with the data to display cells
                let request = NSFetchRequest(entityName: "JsonData")
                do{
                    entity = try manageContext.executeFetchRequest(request) as! [JsonData]
                    
                }catch {
                    print("Fetching error")
                }
                
                do_table_refresh()
                
                
            }
            
        }
    }
    
    func do_table_refresh()
    {
        //it will be safe to refresh the table by main_queue.
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            
            return
        })
    }
    
    //function to save the large image in core data for later use .
    func save_hImage(hUrlString: String, index: NSInteger){
        let highurl:NSURL = NSURL(string: hUrlString)!
        
        let session = NSURLSession.sharedSession()
        //download the image from url asynchronously
        let task = session.downloadTaskWithURL(highurl) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let image = UIImage(data : imageData!)
                
                let imgdata = UIImageJPEGRepresentation(image!, 1.0)
                
                let request = NSFetchRequest(entityName: "JsonData")
                do{
                    self.entity = try self.manageContext.executeFetchRequest(request) as! [JsonData]
                    
                }catch {
                    print("Fetching error")
                }
                
                
                self.entity[index].hImage = imgdata
                
                
                do{
                    try self.manageContext.save()
                } catch{
                    print("Error in saving data")
                }
                return
            })
            
        }
        
        task.resume()
        
        
        
        
    }
    //load the small image to contact list view once it is ready. This is done asynchronously
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        let url:NSURL = NSURL(string: urlString)!
        
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(url) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let image = UIImage(data : imageData!)
                
                let imgdata = UIImageJPEGRepresentation(image!, 1.0)
                
                let request = NSFetchRequest(entityName: "JsonData")
                do{
                    self.entity = try self.manageContext.executeFetchRequest(request) as! [JsonData]
                    
                }catch {
                    print("Fetching error")
                }
                
                
                self.entity[index].sImage = imgdata
                
                
                do{
                    try self.manageContext.save()
                    
                } catch{
                    print("Error in saving data")
                }
                
                let images = UIImage(data : self.entity[index].sImage!)
                imageview.image = images
                
                return
            })
            
        }
        
        task.resume()
    }
    
    
//this is a UItableViewcell datasource function which updates each cell accordingly
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        
        //to round the image
        cell.img.layer.borderWidth = 1.0
        cell.img.layer.masksToBounds = true
        cell.img.layer.borderColor = UIColor.whiteColor().CGColor
        cell.img.layer.cornerRadius = 50.0
        
        let data = self.entity[indexPath.row]
        
        if (data.sImage == nil)
        {
            cell.img.image = UIImage(named: "agent_picture.png")
            load_image(data.sImageUrl!, imageview: cell.img!, index: indexPath.row)
            save_hImage(data.hImageUrl!, index:indexPath.row)
            
        }
        else{
            let image = UIImage(data : entity[indexPath.row].sImage!)
            cell.img.image = image
            
        }
        cell.ContactName.text = entity[indexPath.row].name
        cell.phoneNumber.text =  entity[indexPath.row].work
        // let imageName = "agent_picture.png"
        
        
        return cell
        
    }
    
    
    //this will return number of cells to show
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return entity.count
        
    }
    //this function will transite from contact_list view to detail_view screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let detailView = segue.destinationViewController as! detailViewController
            
            let indexpath = self.tableView.indexPathForSelectedRow
            
            let row = indexpath?.row
        
            detailView.detailEntity = self.entity[row!]
        
    }
    
    
}

