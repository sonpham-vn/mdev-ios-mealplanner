//
//  HomeViewController.swift
//  meal planner
//
//  Created by SonPT on 2021-08-15.
//

import UIKit

class HomeViewController: UIViewController,
                          UITableViewDataSource, UITableViewDelegate {
    // MARK: -IBOutlet
    @IBOutlet weak var TableView: UITableView!
    
    // MARK: -Variables
    var tableData = [PlannerData] ()
    var dayId = [String] ()
    var dbHandler = DatabaseHandler()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "background").cgImage
        view.layer.contentsGravity = .right
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        formatter.dateFormat = "yyyyMMdd"
        tableData = dbHandler.getPlannerList(
            plannerId: formatter.string(from:Date()))
        TableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
            //this method is giving the row count of table view
        return tableData.count
    }
     
     
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                                   reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont (name:"Snell Roundhand Bold",size:20)
        cell.detailTextLabel?.font = UIFont (name:"Noteworthy Light",size:14)
        var period = ""
        switch (Array(tableData[indexPath.row].plannerId)[8]) {
            case "1": period = "Breakfast"
            case "2": period = "Lunch"
            case "3": period = "Dinner"
            default: period = ""
        }
        cell.textLabel?.text = period
        cell.detailTextLabel?.text = tableData[indexPath.row].mealName

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
