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
            NSForegroundColorAttributeName: UIColor.white
        ]
        navigationController!.navigationBar.barTintColor = UIColor.black

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        archiveTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as! ArchiveTableViewCell
        let index = dataArray.count - indexPath.row - 1
        cell.recordNameLabel.text = self.dataArray[index].name
        cell.timeLengthLabel.text = self.dataArray[index].recordLength
        cell.dateLabel.text = self.dataArray[index].currentDate
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = dataArray.count - indexPath.row - 1
        if editingStyle == .delete {
            // Delete the row from the data source
            dataArray.remove(at: indexPath.row)
            FileManager.sharedInstance.deleteRecordFileFromStorage(index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = dataArray.count - indexPath.row - 1
        self.recordFileIndex = index
        self.performSegue(withIdentifier: "goToReplay", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func mainPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToReplay" {
            let destination = segue.destination as! ArchiveReplayViewController
            let indexPath = archiveTableView.indexPathForSelectedRow!.row
            let index = dataArray.count - indexPath - 1
            destination.audioName = dataArray[index].name
            destination.recordFileIndex = self.recordFileIndex
//            print("indexpath is \(archiveTableView.indexPathForSelectedRow!.row)")
        }
        
    }
    

}
