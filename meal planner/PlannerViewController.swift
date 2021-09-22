//
//  PlannerViewController.swift
//  meal planner
//
//  Created by SonPT on 2021-08-15.
//

import UIKit

class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: -IBOutlet
    @IBOutlet weak var TableView: UITableView!
    
    var weekDayList = [String] ()
    var tableData = [PlannerData] ()
    var dbHandler = DatabaseHandler ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "calendar2").cgImage
        view.layer.contentsGravity = .left
        self.navigationItem.title = "Meal Planner"
        generateWeekDay()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("reload")
        tableData.removeAll()
        generateWeekPlaner()
        TableView.reloadData()
    }
    
    func generateWeekDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        for i in 0...6 {
            let nextDay = Calendar.current.date(byAdding: .day, value: i, to: Date())
            for j in 1...3 {
                weekDayList.append(formatter.string(from:nextDay!)+String(j))
            }
        }
        print(weekDayList)
        
    }
    
    func generateWeekPlaner() {
        var dayPlanner = [PlannerData] ()
        for i in 0..<weekDayList.count {
            dayPlanner = [PlannerData] ()
            dayPlanner = dbHandler.getPlannerList(plannerId: weekDayList[i])
            if (dayPlanner.count > 0) {
                for j in 0..<dayPlanner.count {
                    tableData.append(dayPlanner[j])
                }
            } else {
                tableData.append(PlannerData(
                plannerId: weekDayList[i]
                ))
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //this method is giving the row count of table view
        return tableData.count
    }
     
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "plannerCell",for: indexPath) as! PlannerTableViewCell
        var period = ""
        let plannerId = tableData[indexPath.row].plannerId
        let indexY = plannerId.index(plannerId.startIndex, offsetBy: 4)
        let indexM = plannerId.index(plannerId.startIndex, offsetBy: 6)
        let indexD = plannerId.index(plannerId.startIndex, offsetBy: 8)
        
        switch (Array(plannerId)[8]) {
            case "1": period = "Breakfast"
            case "2": period = "Lunch"
            case "3": period = "Dinner"
            default: period = ""
        }
        
        cell.LbDate?.text = String(plannerId[indexY..<indexM])+"/"+String(plannerId[indexM..<indexD])
        cell.LbPeriod?.text = period
        cell.LbMealName?.text = tableData[indexPath.row].mealName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("select")
        //tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier:"showMealVC",sender:indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print ("sid:" + segue.identifier!)
        if segue.identifier == "showMealVC", let indexPath = sender as? IndexPath{
            let destination = segue.destination as! MealViewController
            let productName = tableData[indexPath.row].plannerId
                     destination.plannerId = productName
            destination.isFromPlanner = true
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
