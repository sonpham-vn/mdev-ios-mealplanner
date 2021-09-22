//
//  GroceryViewController.swift
//  meal planner
//
//  Created by SonPT on 2021-08-18.
//

import UIKit

class GroceryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -BOutlet
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var BtnPurchase: UIButton!
    
    
    var weekDayList = [String] ()
    var plannerIngList = [PlannerIngData] ()
    var tableData = [GroceryData] ()
    var dbHandler = DatabaseHandler ()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "green").cgImage
        view.layer.contentsGravity = .left
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
        
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
    
    @objc func share(sender:UIView){
        
        var textToShare = "Grocery list: \n"
        
        for i in 0..<tableData.count {
            textToShare = textToShare + tableData[i].ingName + " x" + String(tableData[i].totalQuantity) + "\n"
        }
        
        let objectsToShare = [textToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func generateWeekPlaner() {
        var dayPlanner = [PlannerIngData] ()
        for i in 0..<weekDayList.count {
            dayPlanner = [PlannerIngData] ()
            dayPlanner = dbHandler.getPlannerIngList(plannerId: weekDayList[i])
            if (dayPlanner.count > 0) {
                for j in 0..<dayPlanner.count {
                    plannerIngList.append(dayPlanner[j])
                }
            } 
        }
        let grouped = Dictionary(grouping: plannerIngList, by:{$0.ingId})
        tableData = grouped.keys.map { (key) -> GroceryData in
            let value = grouped[key]!
            return GroceryData(
                ingId:key,
                ingName:value[0].ingName,
                totalQuantity:value.map{$0.quantity}.reduce(0, +))
        }
        
        print("group")
        print(tableData)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.systemGreen
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.font = UIFont (name:"Noteworthy Light",size:15)
        cell.textLabel?.text = tableData[indexPath.row].ingName + " x" + String(tableData[indexPath.row].totalQuantity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("select")
    }
    
    
    @IBAction func purchaseTouched(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Purchase online! COMING SOON", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
