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
    
    static func deleteTasksList(_ tasksList: TasksList) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func editTasksListName(_ tasksList: TasksList, newTasksListName: String) {
        try! realm.write {
            tasksList.name = newTasksListName
        }
    }
    
    static func makeAllDone(_ tasksList: TasksList) {
        try! realm.write {
            tasksList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func editTask(_ task: Task, newTaskName: String, newTaskNote: String) {
        try! realm.write {
            task.name = newTaskName
            task.note = newTaskNote
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isComplete.toggle()
        }
    }
}
