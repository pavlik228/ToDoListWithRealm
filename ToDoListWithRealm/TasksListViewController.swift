
import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var tasksLists : Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksLists = realm.objects(TasksList.self)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    @IBAction func sortingList(_ sender: UISegmentedControl) {
    }
}

extension TasksListViewController {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksListCell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = String(tasksList.tasks.count)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
    }
}

extension TasksListViewController {
    
    private func alertForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        var title = "New List"
        
        if listName != nil {
            title = "Edit List"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alertTextField.text, !text.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editTasksListName(listName, newTasksListName: text)
                if complition != nil { complition!() }
            } else {
                let tasksList = TasksList()
                tasksList.name = text
                
                StorageManager.saveTasksList(tasksList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count-1, section: 0)], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "List name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}

extension TasksListViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            StorageManager.deleteTasksList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {_,_,_ in
            self.alertForAddAndUpdateList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") {_,_,_ in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        doneAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
}
