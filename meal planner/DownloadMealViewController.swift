//
//  DownloadMealViewController.swift
//  meal planner
//
//  Created by SonPT on 2021-08-15.
//

import UIKit
import SQLite3



class DownloadMealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -IBOutlet
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var ButtonDownload: UIButton!
    
    
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var tableData = [MealData] ()
    var selectedData = [MealData] ()
    var mealContentModel = MealContentModel()
    var dbHandler = DatabaseHandler()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "snack").cgImage
        view.layer.contentsGravity = .topLeft
        self.navigationItem.title = "Download Meal"
        
        TableView.allowsMultipleSelection = true
        mealContentModel.getOnlineMealList() {(response) in
            self.tableData = response
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        }
        
        
    }
    
    @IBAction func buttonDownloadTouched(_ sender: UIButton) {
        let selectedRows = TableView.indexPathsForSelectedRows
        dbHandler.createMealTable()
        dbHandler.createIngredientTable()
        dbHandler.createRecipeTable()
        if (selectedRows != nil) {
            // insert meal
            for i in 0..<selectedRows!.count {
                print(tableData[selectedRows![i].row])
                dbHandler.insertData(mealOnlId: tableData[selectedRows![i].row].mealOnlId,
                                     mealName: tableData[selectedRows![i].row].mealName,
                                     mealMemo: tableData[selectedRows![i].row].mealMemo)
                tableData[selectedRows![i].row].mealId = dbHandler.getMealId(
                    mealOnlId: tableData[selectedRows![i].row].mealOnlId)
            // insert ingredients
                for j in 0..<tableData[selectedRows![i].row].ingList!.count {
                    dbHandler.insertIngData(
                        ingOnlId: tableData[selectedRows![i].row].ingList![j].ingOnlId,
                        ingName: tableData[selectedRows![i].row].ingList![j].ingName
                    )
                    let ingId = dbHandler.getIngId(ingOnlId: tableData[selectedRows![i].row].ingList![j].ingOnlId)
                    tableData[selectedRows![i].row].ingList![j].ingId = ingId
                // insert recipe
                    dbHandler.insertRecipeData(
                        mealId: tableData[selectedRows![i].row].mealId!,
                        ingId: tableData[selectedRows![i].row].ingList![j].ingId!)
                }
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let mealCellData = tableData[indexPath.row]
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.systemOrange
        cell.backgroundColor = UIColor.systemGray
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.font = UIFont (name:"Noteworthy Bold",size:15)
        cell.textLabel?.text = mealCellData.mealName
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
