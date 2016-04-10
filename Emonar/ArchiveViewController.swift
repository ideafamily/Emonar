//
//  ArchiveViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var archiveTableView: UITableView!
    var dataArray = FileManager.sharedInstance.getAllLocalRecordFileFromStorage()
    var recordFileIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
//        navigationItem.titleView
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        archiveTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArchiveTableViewCell", forIndexPath: indexPath) as! ArchiveTableViewCell
        let index = dataArray.count - indexPath.row - 1
        cell.recordNameLabel.text = self.dataArray[index].name
        cell.timeLengthLabel.text = self.dataArray[index].recordLength
        cell.dateLabel.text = self.dataArray[index].currentDate
        return cell
    }

    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let index = dataArray.count - indexPath.row - 1
        if editingStyle == .Delete {
            // Delete the row from the data source
            dataArray.removeAtIndex(indexPath.row)
            FileManager.sharedInstance.deleteRecordFileFromStorage(index)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = dataArray.count - indexPath.row - 1
        self.recordFileIndex = index
        self.performSegueWithIdentifier("goToReplay", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func mainPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToReplay" {
            let destination = segue.destinationViewController as! ArchiveReplayViewController
            let indexPath = archiveTableView.indexPathForSelectedRow!.row
            let index = dataArray.count - indexPath - 1
            destination.audioName = dataArray[index].name
            destination.recordFileIndex = self.recordFileIndex
//            print("indexpath is \(archiveTableView.indexPathForSelectedRow!.row)")
        }
        
    }
    

}
