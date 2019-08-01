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
        showToDoListUpdateUI(option: .new)
    }
    //MARK: - Private
    
    private func updateTableView() {
        todosTableView.reloadData()
    }
    
    private enum UpdateUIOption {
        case new, edit
    }
    
    private func showToDoListUpdateUI(option: UpdateUIOption, todo:ToDo? = nil) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        let alertTitle:String
        let defaultAction: UIAlertAction
        switch option {
        case .new:
            alertTitle = "Add Task"
            defaultAction = UIAlertAction(title: "Add", style: .default) { [unowned self, unowned alertController](action) in
                guard let todoName = alertController.textFields?.first?.text else { return }
                self.dataManager.createNewToDo(name: todoName, inFolder: self.folder)
                self.updateTableView()
            }
            
        case .edit:
            alertTitle = "Edit Task"
            defaultAction = UIAlertAction(title: "Save", style: .default) { [unowned self, unowned alertController](action) in
                
                guard let todo = todo, let todoName = alertController.textFields?.first?.text else { return }
                self.dataManager.updateToDo(todo, newName: todoName)
                self.updateTableView()
            }
        }
     
        alertController.title = alertTitle
        alertController.addTextField { [weak todo](textfield) in
            textfield.placeholder = "Name"
            if let todo = todo {
                textfield.text = todo.name
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //Edit, Delete Actions Support
    private func deleteActionHandler(actionView:UITableViewRowAction, indexPath:IndexPath) -> Void {
        guard let todo = folder.getToDoAt(index: indexPath.item) else { return }
        folder = self.dataManager.deleteToDo(todo)
        todosTableView.deleteRows(at: [indexPath], with: .automatic)

    }
    
    private func editActionHandler(actionView:UITableViewRowAction, indexPath:IndexPath) -> Void {
        
        guard let todo = folder.getToDoAt(index: indexPath.item) else { return }
        showToDoListUpdateUI(option: .edit, todo: todo)
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
        tableView.reloadData()//.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    //MARK: Edit, Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (actionView:UITableViewRowAction,indexPath:IndexPath) in
            
            guard let todo = self.folder.getToDoAt(index: indexPath.item) else { return }
            self.folder = self.dataManager.deleteToDo(todo)
            self.todosTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (actionView:UITableViewRowAction,indexPath:IndexPath) in
            guard let todo = self.folder.getToDoAt(index: indexPath.item) else { return }
            self.showToDoListUpdateUI(option: .edit, todo: todo)
        }
        
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }



}
