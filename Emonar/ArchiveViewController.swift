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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
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
        cell.recordNameLabel.text = self.dataArray[indexPath.row].name
        cell.timeLengthLabel.text = self.dataArray[indexPath.row].recordLength
        cell.dateLabel.text = self.dataArray[indexPath.row].currentDate
        return cell
    }

    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            dataArray.removeAtIndex(indexPath.row)
            FileManager.sharedInstance.deleteRecordFileFromStorage(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goToReplay", sender: self)
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
            var index = archiveTableView.indexPathForSelectedRow!.row
            destination.audioName = dataArray[index].name
//            print("indexpath is \(archiveTableView.indexPathForSelectedRow!.row)")
        }
        
    }
    

}
