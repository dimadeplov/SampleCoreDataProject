//
//  FolderViewController.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 18/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataManager = (UIApplication.shared.delegate as? AppDelegate)!.dataManager

    private let folderCellIdentifier = "FolderCell"

    private var folders:[Folder] = []
    
    @IBOutlet weak var foldersTableView: UITableView!
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        folders = dataManager.getFolders()
    }

    
    //MARK: - Actions
    
    @IBAction func addNewFolder(_ sender: Any) {        
        showAddFolderUI()
    }
    //MARK: - Private
    
    private func updateFodlers() {
        folders = dataManager.getFolders()
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
            self.dataManager.createNewFolder(name: folderName)
            self.updateFodlers()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: folderCellIdentifier, for: indexPath)
        let folder = folders[indexPath.item]
        cell.textLabel?.text = folder.name
        
        return cell
    }

    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }

}

