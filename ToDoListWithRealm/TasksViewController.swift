//
//  TasksTableViewController.swift
//  ToDoListWithRealm
//
//  Created by Pavel Aushev on 09.01.2020.
//  Copyright © 2020 Павел Аушев. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
    
    var currentTasksList: TasksList!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
