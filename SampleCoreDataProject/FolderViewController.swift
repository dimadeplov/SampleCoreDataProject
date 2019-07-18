//
//  FolderViewController.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 18/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let folderCellIdentifier = "FolderCell"

    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    //MARK: - Actions
    
    @IBAction func addNewFolder(_ sender: Any) {        
        showAddFolderUI()
    }
    //MARK: - Private
    
    private func showAddFolderUI() {
        
        let alertController = UIAlertController(title: "Add Folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
        
            print("Add Folder with name \(alertController.textFields?.first?.text ?? "")")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        //alertController.preferredAction = addAction

        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: folderCellIdentifier, for: indexPath)
        return cell
    }

    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

