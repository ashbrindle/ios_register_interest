//
//  AdminViewController.swift
//  Register Interest
//
//  Created by Brindle A P (FCES) on 18/02/2020.
//  Copyright © 2020 Ashley Brindle. All rights reserved.
//

import UIKit

class TableViewCellAdapter: UITableViewCell {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txt_Subject: UILabel!
    
}

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableview: UITableView!
    
        var data_set : Array<Subject> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_set.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_cell", for: indexPath) as! TableViewCellAdapter
        cell.txtName?.text = data_set[indexPath.item].Name
        cell.txt_Subject?.text = data_set[indexPath.item].SubjectArea
        return cell
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
