//
//  FolderViewController.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 18/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit
import CoreData

class FolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    weak var dataManager = (UIApplication.shared.delegate as? AppDelegate)?.dataManager
    var fetchResultsFolderController:NSFetchedResultsController<Folder>?
    
    
    private let folderCellIdentifier = "FolderCell"
    private let todosSegueID = "ShowTodos"
    
    
    @IBOutlet weak var foldersTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //folders = dataManager.getFolders()
        
        prepareFetchedResultController()
    }

    
    //MARK: - Actions
    
    @IBAction func addNewFolder(_ sender: Any) {        
        showToDoListUpdateUI(option: .new)
    }
    //MARK: - Private
    
    private func prepareFetchedResultController() {
        
        fetchResultsFolderController = dataManager?.fetchResultControllerForFolders()
        fetchResultsFolderController?.delegate = self
        
        do {
            try fetchResultsFolderController?.performFetch()
        }
        catch {
            print("Failed to fetch with fetchResultsFolderCotnroller: \(error)")
        }
    }
    
    
    
    private func updateFodlers() {
        //folders = dataManager.getFolders()
        foldersTableView.reloadData()
    }
    

    private func showToDoListUpdateUI(option: UpdateUIOption, folder:Folder? = nil) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let alertTitle:String
        let defaultAction: UIAlertAction
        switch option {
        case .new:
            alertTitle = "Add Folder"
            defaultAction = UIAlertAction(title: "Add", style: .default) { [unowned self, unowned alertController](action) in
                
                guard let textfields = alertController.textFields, let name = textfields[0].text, !name.isEmpty else {return}
                
                let description = textfields[1].text
                self.dataManager?.createNewFolder(name: name, description: description)
            }
            
        case .edit:
            alertTitle = "Edit Folder"
            defaultAction = UIAlertAction(title: "Save", style: .default) { [unowned self, unowned alertController](action) in
                guard let folder = folder, let folderName = alertController.textFields?[0].text, !folderName.isEmpty  else {return}

                self.dataManager?.updateFolder(folder, newName: folderName, newFolderDescription: alertController.textFields?[1].text)
            }
        }
        
        alertController.title = alertTitle
        alertController.addTextField { [weak folder](textfield) in
            textfield.placeholder = "Name"
            if let folder = folder {
                textfield.text = folder.name
            }
        }
        
        alertController.addTextField { [weak folder](textfield) in
            textfield.placeholder = "Description"
            if let folderDescription = folder?.folderDescription {
                textfield.text = folderDescription
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    //MARK: - UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsFolderController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: folderCellIdentifier, for: indexPath)
        
        let folder = fetchResultsFolderController?.object(at: indexPath)
        cell.textLabel?.text = folder?.name
        cell.detailTextLabel?.text = folder?.folderDescription
        return cell
    }

    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: todosSegueID, sender: self)
    }
    
    //MARK: Edit, Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (actionView:UITableViewRowAction,indexPath:IndexPath) in
            
            if let folder = self.fetchResultsFolderController?.object(at: indexPath) {
                self.dataManager?.deleteFolder(folder)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (actionView:UITableViewRowAction,indexPath:IndexPath) in
            
            if let folder = self.fetchResultsFolderController?.object(at: indexPath){
                self.showToDoListUpdateUI(option: .edit, folder: folder)
            }
        }
        
        return [deleteAction, editAction]
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Fetched Results Controller Delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        foldersTableView.reloadData()
    }
    
    
    //MARK: -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == todosSegueID) {
            let toDoVC = (segue.destination as? ToDoViewController)
            toDoVC?.dataManager = self.dataManager
            toDoVC?.folder = fetchResultsFolderController?.object(at: foldersTableView.indexPathForSelectedRow!)

        }
    }
}

