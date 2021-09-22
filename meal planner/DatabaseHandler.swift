//
//  DatabaseHandler.swift
//  meal planner
//
//  Created by SonPT on 2021-08-16.
//

import Foundation
import SQLite3

class DatabaseHandler {
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Meal2.sqlite")
        
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        return db
    }
    
    func createMealTable() {
        let db = openDatabase()
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Meal4(
        MealId INTEGER PRIMARY KEY AUTOINCREMENT,
        MealOnlId TEXT UNIQUE,
        MealName TEXT,
        MealMemo TEXT
        );
        """
        
        
        // 1
        var createTableStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nContact table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE IF NOT EXISTS statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func createPlannerTable() {
        let db = openDatabase()
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Planner5(
        PlannerId TEXT PRIMARY KEY,
        MealId INT,
        FOREIGN KEY (MealId) REFERENCES Meal4(MealId)
        );
        """
        
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nContact table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE IF NOT EXISTS statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createRecipeTable() {
        let db = openDatabase()
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Recipe2(
        RecipeId INTEGER PRIMARY KEY AUTOINCREMENT,
        MealId INT,
        IngId INT,
        FOREIGN KEY (MealId) REFERENCES Meal4(MealId),
        FOREIGN KEY (IngId) REFERENCES Ingredient(IngId),
        UNIQUE (MealId, IngId)
        );
        """
        
        
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nRecipe table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE IF NOT EXISTS statement is not prepared.")
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    func createIngredientTable() {
        let db = openDatabase()
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Ingredient(
        IngId INTEGER PRIMARY KEY AUTOINCREMENT,
        IngOnlId TEXT UNIQUE,
        IngName TEXT
        );
        """
        
        
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nIng table created.")
            } else {
                print("\nIng table is not created.")
            }
        } else {
            print("\nCREATE TABLE IF NOT EXISTS statement is not prepared.")
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    func insertData(mealOnlId: String, mealName: String, mealMemo: String){
        let db = openDatabase()
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Meal4 (MealOnlId, MealName, MealMemo) VALUES (?,?,?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, mealOnlId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, mealName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, mealMemo, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Herro saved successfully")
    }
    
    func insertIngData(ingOnlId: String, ingName: String){
        let db = openDatabase()
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Ingredient (IngOnlId, IngName) VALUES (?,?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, ingOnlId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, ingName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Ing saved successfully")
    }
    
    func insertPlannerData(plannerId: String, mealId: Int){
        let db = openDatabase()
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = """
        INSERT INTO Planner5 (PlannerId, MealId) VALUES (?,?)
        ON CONFLICT(PlannerId) DO UPDATE SET MealId = ?;
        """
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, plannerId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(mealId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 3, Int32(mealId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Planner saved successfully")
    }
    
    func insertRecipeData(mealId: Int, ingId: Int){
        let db = openDatabase()
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Recipe2 (MealId, IngId) VALUES (?,?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(mealId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(ingId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        //displaying a success message
        print("Recipe saved successfully")
    }
    
    
    func getMealId(mealOnlId:String) -> Int{
        let db = openDatabase()
        var mealId : Int = -1
 
        //this is our select query
        let queryString = "SELECT * FROM Meal4 WHERE MealOnlId = ?;"
        //statement pointer
        var stmt:OpaquePointer?
    
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return mealId
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, mealOnlId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return mealId
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            mealId = Int(sqlite3_column_int(stmt, 0))
  
        }
        print ("return mealid: " + String(mealId))
        return mealId
    }
    
    func getIngId(ingOnlId:String) -> Int{
        let db = openDatabase()
        var ingId : Int = -1
 
        let queryString = "SELECT * FROM Ingredient WHERE IngOnlId = ?;"
        //statement pointer
        var stmt:OpaquePointer?
    
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return ingId
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, ingOnlId, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return ingId
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            ingId = Int(sqlite3_column_int(stmt, 0))
        }
        print ("return ingid: " + String(ingId))
        return ingId
    }
    
    func getMealList() -> [MealData] {
        var mealList = [MealData]()
        let db = openDatabase()
 
        let queryString = "SELECT * FROM Meal4;"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return mealList
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            mealList.append(MealData(
                mealId: Int(sqlite3_column_int(stmt, 0)),
                mealOnlId : String(cString: sqlite3_column_text(stmt, 1)),
                mealName :String(cString: sqlite3_column_text(stmt, 2)),
                mealMemo: String(cString: sqlite3_column_text(stmt, 3))
            ))
        }
        return mealList
        
    }
    
    
    
    func getPlannerList(plannerId:String) -> [PlannerData] {
        var plannerList = [PlannerData]()
        let db = openDatabase()
  
        let queryString = """
        SELECT Planner5.PlannerId, Planner5.MealId, Meal4.MealName
        FROM Planner5
        INNER JOIN Meal4 ON Planner5.MealId = Meal4.MealId
        WHERE Planner5.PlannerId LIKE ?;
        """
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return plannerList
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, plannerId + "%", -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return plannerList
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            plannerList.append(PlannerData(
                plannerId : String(cString: sqlite3_column_text(stmt, 0)),
                mealId: Int(sqlite3_column_int(stmt, 1)),
                mealName:String(cString: sqlite3_column_text(stmt, 2))
            )
            )
        }
        return plannerList
        
    }
    
    func getPlannerIngList(plannerId:String) -> [PlannerIngData] {
        var plannerIngList = [PlannerIngData]()
        let db = openDatabase()
  
        let queryString = """
        SELECT Planner5.PlannerId, Planner5.MealId, Meal4.MealName, Recipe2.IngId, Ingredient.IngName
                FROM Ingredient INNER JOIN (Recipe2
                left outer join (Planner5
                INNER JOIN Meal4
                ON Planner5.MealId = Meal4.MealId)
                ON Recipe2.MealId = Planner5.MealId)
                ON Recipe2.IngId = Ingredient.IngId
                WHERE Planner5.PlannerId LIKE ?;
        """
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return plannerIngList
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, plannerId + "%", -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return plannerIngList
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            plannerIngList.append(PlannerIngData(
                plannerId : String(cString: sqlite3_column_text(stmt, 0)),
                mealId: Int(sqlite3_column_int(stmt, 1)),
                mealName:String(cString: sqlite3_column_text(stmt, 2)),
                ingId: Int(sqlite3_column_int(stmt, 3)),
                ingName:String(cString: sqlite3_column_text(stmt, 4)),
                quantity:1
            )
            )
        }
        return plannerIngList
        
    }
    
}
