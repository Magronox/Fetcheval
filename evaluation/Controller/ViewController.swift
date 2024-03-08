//
//  ViewController.swift
//  evaluation
//
//  Created by Amir Bas on 3/6/24.
//

import UIKit


class ViewController: UITableViewController {
    
    let reuseID = "Table View Cell"
    
    
    var things_: [DataModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        let modelManager = ModelManager()
        modelManager.fetchData { [weak self] (things) in
            self?.things_ = things
        }

        
    }
    
    func configTable(){
        tableView.backgroundColor = .lightGray
        tableView.tableFooterView = UIView()
    }
}

extension ViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return things_?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        guard let thing = things_?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(thing.name ?? "") - \(thing.id)-\(thing.listId)"
        
        return cell
    }
}
