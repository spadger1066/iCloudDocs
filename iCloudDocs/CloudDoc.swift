//
//  CloudDoc.swift
//  iCloudDocs
//
//  Created by Stephen on 02/02/2016.
//  Copyright © 2016 luminator.technology.com. All rights reserved.
//

import UIKit

class CloudDoc: UIDocument {
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        guard let loadedData:String = String(data: contents as! NSData, encoding: NSUTF8StringEncoding) else {
            print("Error loading data")
            return
        }
        mainViewController.tView.text = loadedData
    }
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        return mainViewController.tView.text.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
