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
    
    weak var dataManager = (UIApplication.shared.delegate as? AppDelegate)!.dataManager
    var fetchResultsFolderController:NSFetchedResultsController<Folder>!
    
    
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
        showAddFolderUI()
    }
    //MARK: - Private
    
    private func prepareFetchedResultController() {
        
        fetchResultsFolderController = dataManager?.fetchResultControllerForFolders()
        fetchResultsFolderController.delegate = self
        
        do {
            try fetchResultsFolderController.performFetch()
        }
        catch {
            print("Failed to fetch with fetchResultsFolderCotnroller: \(error)")
        }
    }
    
    
    
    private func updateFodlers() {
        //folders = dataManager.getFolders()
        foldersTableView.reloadData()
    }
    
    
    private func showAddFolderUI() {
        
        let alertController = UIAlertController(title: "Add Folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] (action) in
            print("Add Folder with name \(alertController.textFields?.first?.text ?? "")")
            guard let folderName = alertController.textFields?.first?.text else { return }
            self.dataManager?.createNewFolder(name: folderName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsFolderController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: folderCellIdentifier, for: indexPath)
        
        let folder = fetchResultsFolderController.object(at: indexPath)
        cell.textLabel?.text = folder.name
        
        return cell
    }

    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: todosSegueID, sender: self)
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
            toDoVC?.folder = fetchResultsFolderController.object(at: foldersTableView.indexPathForSelectedRow!)

        }
    }
}

