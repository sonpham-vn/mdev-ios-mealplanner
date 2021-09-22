//
//  MealViewController.swift
//  meal planner
//
//  Created by SonPT on 2021-08-15.
//

import UIKit

class MealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -IBOutlet
    var tableData = [MealData] ()
    var dbHandler = DatabaseHandler()
    var plannerId : String = ""
    var isFromPlanner : Bool = false
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "calendar").cgImage
        view.layer.contentsGravity = .left
        self.navigationItem.title = "Meal List"
        tableData = dbHandler.getMealList()
        print ("id: "+plannerId)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableData = dbHandler.getMealList()
        TableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let mealCellData = tableData[indexPath.row]
        cell.textLabel?.text = mealCellData.mealName
        cell.backgroundColor = UIColor.systemOrange
        cell.textLabel?.font = UIFont (name:"Noteworthy Bold",size:15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealCellData = tableData[indexPath.row]
        
        if (isFromPlanner){
            dbHandler.createPlannerTable()
            print ("insert:"+plannerId)
            dbHandler.insertPlannerData(plannerId: plannerId, mealId: mealCellData.mealId!)
            navigationController?.popViewController(animated: true)
            
        } else {
            let alert = UIAlertController(title: "", message: "Show recipe detail! COMING SOON", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
