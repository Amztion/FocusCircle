//
//  DatabaseController.swift
//  FocusCircle
//
//  Created by 赵亮 on 16/1/12.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

//let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, false)
let documentPath = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false).path!

class DatabaseController: NSObject {
    static var sharedController = DatabaseController()
    
    let database = FMDatabase(path: NSString.pathWithComponents([documentPath, "db.sqlite"]))
    let databaseQueue = FMDatabaseQueue(path: NSString.pathWithComponents([documentPath, "db.sqlite"]))
    
    override init() {
        super.init()
        
        print("DocumentPath: \(documentPath)")
        
        if !database.open() {
            print("Unable To Open Database")
        }else {
            let sql = "CREATE TABLE IF NOT EXISTS timers(id INTEGER PRIMARY KEY AUTOINCREMENT, identifier TEXT, name TEXT, durationTime REAL, state INTEGER, timeStarted REAL, timeShoudEnd REAL)"
            do {
                try database.executeStatements(sql)
            }catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
            
            database.close()
        }
    }
}
