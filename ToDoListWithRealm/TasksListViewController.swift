
import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var tasksLists : Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksLists = realm.objects(TasksList.self)
        
//        let shopingList = TasksList()
//        shopingList.name = "ShopingList"
//
//        let milk = Task()
//        milk.name = "Milk"
//        milk.note = "2l"
//
//        shopingList.tasks.append(milk)
//
//        let bread = Task(value: ["Bread"])
//
//        shopingList.tasks.append(bread)
//
//        let moviesList = TasksList(value: ["MoviesList", Date(), [["John Weak"], ["Tor"]]])
//
//        DispatchQueue.main.async {
//            StorageManager.saveTasksList([shopingList, moviesList])
//        }
        
    }
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    @IBAction func addButtonPressed(_ sender: Any) {
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
