//
//  StorageManager.swift
//  ToDoListWithRealm
//
//  Created by Pavel Aushev on 09.01.2020.
//  Copyright © 2020 Павел Аушев. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func saveTask(tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
}
