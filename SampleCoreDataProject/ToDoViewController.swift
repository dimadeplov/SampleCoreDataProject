//
//  ToDoViewController.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 18/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let toDoCellIdentifier = "ToDoCell"
    weak var folder:Folder!
    weak var dataManager:DataManager!    
    
    @IBOutlet weak var todosTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = folder.name
        
    }
    
    //MARK: - Actions
    
    @IBAction func addNewTodo(_ sender: Any) {
        showAddToDoUI()
    }
    //MARK: - Private
    
    private func updateTableView() {
        todosTableView.reloadData()
    }
    
    
    private func showAddToDoUI() {
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Add ToDo with name \(alertController.textFields?.first?.text ?? "")")
            guard let folderName = alertController.textFields?.first?.text else { return }
            self.dataManager.createNewToDo(name: folderName, inFolder: self.folder)
            self.updateTableView()

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: toDoCellIdentifier, for: indexPath)
    
        let toDo = folder.getToDoAt(index: indexPath.item)
        cell.textLabel?.text = toDo?.name
        cell.accessoryType = (toDo?.done ?? false) ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toDo = folder.getToDoAt(index: indexPath.item) else {return}
        toDo.done = !toDo.done
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
