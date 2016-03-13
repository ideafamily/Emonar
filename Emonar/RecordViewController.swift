//
//  RecordViewController.swift
//  Emonar
//
//  Created by ZengJintao on 3/8/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import Gifu

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var soundWaveView: UIView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var data = ["Happy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        recordTableView.backgroundColor = UIColor.blackColor()
        
        
        self.navigationController?.navigationBarHidden = true
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
//        recordTableView.rowHeight = UITableViewAutomaticDimension
        recordTableView.estimatedRowHeight = 125
        recordTableView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
//        recordButton.setTitle("Start", forState: .Normal)
        recordButton.selected = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordTableViewCell", forIndexPath: indexPath) as! RecordTableViewCell
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
//        cell.emotionLabel.text = data[indexPath.row]
        cell.emotionLabel.text = "Happy"
        
//        if indexPath.row == data.count - 1 {
//            cell.emotionImg.animateWithImage(named: "loading4.gif")
//            //        cell.emotionImg.image = UIImage.gifWithName("loading4")
//            delay(5) { () -> () in
//                cell.emotionImg.stopAnimatingGIF()
//                cell.emotionImg.image = UIImage(named: "temp")
//            }
//        } else {
            cell.emotionImg.image = UIImage(named: "temp")
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            cell.alpha = 1
        }
    }
    
    
    
    @IBAction func cancelPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordPressed(sender: UIButton) {
        data.insert("WOWwww", atIndex: 0)
//        recordTableView.reloadData()
//        var a = NSIndexPath(forRow: 0, inSection: 0)
        
        recordTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Left)
        if sender.selected == true {
            sender.selected = false
        } else {
            sender.selected = true
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    deinit {
        self.recordTableView = nil
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
