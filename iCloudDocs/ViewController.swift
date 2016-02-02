//
//  ViewController.swift
//  iCloudDocs
//
//  Created by Stephen on 01/02/2016.
//  Copyright © 2016 luminator.technology.com. All rights reserved.
//

import UIKit

var mainViewController:ViewController!

class ViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var tView: UITextView!
    var doc:CloudDoc!
    
    @IBAction func didTapSave(sender: AnyObject) {
        doc.updateChangeCount(.Done)
    }
    
    @IBAction func didTapLoad(sender: AnyObject) {
        let docPicker:UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.content"], inMode: UIDocumentPickerMode.Open)
        docPicker.delegate = self
        docPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(docPicker, animated: true) { () -> Void in
            // handle completion
        }
    }
    
    @IBAction func didTapDelete(sender: AnyObject) {
        doc.closeWithCompletionHandler { (success:Bool) -> Void in
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, { () -> Void in
                self.deleteFile()
            })
        }
    }
    
    func deleteFile() {
        let coordinator = NSFileCoordinator(filePresenter: nil)
        coordinator.coordinateWritingItemAtURL(self.getURL(), options: .ForDeleting, error: nil) { (url:NSURL) -> Void in
            let fileManager:NSFileManager = NSFileManager()
            do {
                try fileManager.removeItemAtURL(url)
            } catch _ {
                print("Error deleting file")
            }
        }
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        let data:NSData? = NSData(contentsOfURL: url)
        if data?.length <= 0 {
            print("No data found")
            return
        }
        tView.text = String(data: data!, encoding: NSUTF8StringEncoding)!
    }
    
    func getURL() -> NSURL {
        let cloudURL:NSURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)!
        let fileURL:NSURL = cloudURL.URLByAppendingPathComponent("Documents/doc.txt")
        return fileURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainViewController = self
        doc = CloudDoc(fileURL:getURL())
        doc.openWithCompletionHandler { (success:Bool) -> Void in
            if !success {
                print("Error opening doc")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

