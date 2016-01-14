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
    
    //MARK: Timer Stroage
    func readAllTimersFromDatabase() -> Array<[NSObject: AnyObject]>? {
        var resultArray = Array<[NSObject: AnyObject]>()
        
        if !database.open(){
            print("Unable To Open Database")
        }else {
            let rs = try? database.executeQuery("SELECT * FROM timers", values:nil)
            while rs!.next() {
                resultArray.append((rs?.resultDictionary())!)
            }
            
            database.close()
            return resultArray
        }
        
        database.close()
        return nil
    }
    
    func saveNewTimer(timer: Timer) -> Bool {
        if !database.open(){
            print("Unable To Open Database")
        }else {
            let rs = try? database.executeQuery("SELECT * FROM timers WHERE identifier = ?;", values: [timer.identifier])
            if rs!.next() {
                database.close()
                return false
            }
            
            database.close()
        }
        
        databaseQueue.inDatabase { (database) -> Void in
            _ = try? database.executeUpdate("INSERT INTO timers (identifier, name, durationTime, state) VALUES (?,?,?,?)", values: [timer.identifier, timer.name, timer.durationTime, timer.state.rawValue])
            
        }
        
        return true
    }
    
    func deleteTimerWithIdentifier(identifier: String) -> Bool{
        if !database.open(){
            print("Unable To Open Database")
        }else {
            let rs = try? database.executeQuery("SELECT * FROM timers WHERE identifier = ?;", values: [identifier])
            if !rs!.next() {
                database.close()
                return false
            }
            
            database.close()
        }
        
        databaseQueue.inDatabase { (database) -> Void in
            _ = try? database.executeUpdate("DELETE FROM timers WHERE identifier = ?;", values: [identifier])
        }
        
        return true
    }
    
    func updateInfoOfTimerWithIdentifier(identifier: String, newName: String?, newDurationTime: NSTimeInterval?) -> Bool {
        if !database.open() {
            print("Unable To Open Database")
        }else {
            let rs = try? database.executeQuery("SELECT * FROM timers WHERE identifier = ?", values: [identifier])
            
            if !(rs!.next()) {
                database.close()
                return false
            }
            
            database.close()
        }
        
        var attr: String!
        var valueToSet: AnyObject!
        
        if let name = newName {
            attr = "name"
            valueToSet = name
        }
        
        if let durationTime = newDurationTime {
            attr = "durationTime"
            valueToSet = durationTime
        }
        
        databaseQueue.inDatabase { (database) -> Void in
            _ = try? database.executeUpdate("UPDATE timers SET \(attr) = ? WHERE identifier = ?", values: [valueToSet, identifier])
        }
        
        return true
    }
    
    func updateTimeOfTimer(timer:Timer) -> Bool {
        if !database.open() {
            print("Unable To Open Database")
        }else {
            let rs = try? database.executeQuery("SELECT * FROM timers WHERE identifier = ?", values: [timer.identifier])
            
            if !(rs!.next()) {
                database.close()
                return false
            }
            
            database.close()
        }
        
        databaseQueue.inDatabase { (database) -> Void in
            _ = try? database.executeUpdate("UPDATE timers SET state = ?, timeStarted = ?, timeShouldEnd = ? WHERE identifier = ?", values: [timer.state.rawValue, timer.timeStarted!,timer.timeShouldEnd!, timer.identifier])
        }
        
        return true
    }
}
