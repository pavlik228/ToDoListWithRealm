//
//  TasksTableViewController.swift
//  ToDoListWithRealm
//
//  Created by Pavel Aushev on 09.01.2020.
//  Copyright © 2020 Павел Аушев. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentTasksList: TasksList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        filteringTasks()

    }
    
    @IBAction func editButton(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isComplete = false")
        completedTasks = currentTasksList.tasks.filter("isComplete = true")
        
        tableView.reloadData()
    }
}

extension TasksViewController {
    
    private func alertForAddAndUpdateList(_ task: Task? = nil ) {
        var title = "New task"
        
        if task != nil {
            title = "Edit task"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTaskTextField: UITextField!
        var alertNoteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let taskName = alertTaskTextField.text, !taskName.isEmpty else { return }
            
            if let task = task {
                if let note = alertNoteTextField.text, !note.isEmpty {
                    StorageManager.editTask(task, newTaskName: taskName, newTaskNote: note)
                } else {
                    StorageManager.editTask(task, newTaskName: taskName, newTaskNote: "")
                }
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = taskName
                
                if let note = alertNoteTextField.text, !note.isEmpty {
                    
                    task.note = note
                }
                
                StorageManager.saveTask(tasksList: self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            alertTaskTextField = textField
            textField.placeholder = "Task name"
            
            if let task = task {
                alertTaskTextField.text = task.name
            }
        }
        
        alert.addTextField { textField in
            alertNoteTextField = textField
            textField.placeholder = "Note"
            
            if let task = task {
                alertNoteTextField.text = task.note
            }
        }
        
        present(alert, animated: true)
    }
}

extension TasksViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task: Task!
        var title: String!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {_,_,_ in
            self.alertForAddAndUpdateList(task)
            self.filteringTasks()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        title = task.isComplete ? "Undone" : "Done"
        
        let doneAction = UIContextualAction(style: .normal, title: title) {_,_,_ in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        doneAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
}
