//
//  MealContentModel.swift
//  meal planner
//
//  Created by SonPT on 2021-08-16.
//

import Foundation

struct IngData {
    var ingId: Int? = nil
    var ingOnlId: String
    var ingName: String
}

struct MealData {
    var mealId: Int? = nil
    var mealOnlId: String
    var mealName: String
    var mealMemo: String
    var ingList: [IngData]? = nil
}

struct PlannerData {
    var plannerId: String
    var mealId: Int? = nil
    var mealName: String? = nil
}

struct PlannerIngData {
    var plannerId: String
    var mealId: Int
    var mealName: String
    var ingId: Int
    var ingName: String
    var quantity: Int
}

struct GroceryData {
    var ingId: Int
    var ingName: String
    var totalQuantity: Int
}


class MealContentModel {
    
    func getOnlineMealList (completionBlock: @escaping ([MealData]) -> Void) -> Void {
        var onlineMealList = [MealData]()
        let url = URL(string: "https://zjil8ive37.execute-api.ca-central-1.amazonaws.com/dev/recipes")!
        let session = URLSession.shared
        let request = URLRequest(url: url)

        //fetch data
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

           do {
            guard let onlineMealListJson = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                            print("Error when parse json online meal list")
                            return
                        }
            for i in 0..<onlineMealListJson.count{
                var ingredientList = [IngData]()
                let ingredientListObject : NSArray = onlineMealListJson[i]["IngredientList"] as! NSArray
                for j in 0..<ingredientListObject.count {
                    let ingredientObject:AnyObject = ingredientListObject[j] as AnyObject
                    ingredientList.append(IngData(
                        ingOnlId:  ingredientObject["IngOnlId"] as! String,
                        ingName: ingredientObject["IngName"] as! String
                    ))
                }
                
                onlineMealList.append(MealData(
                                        mealOnlId: onlineMealListJson[i]["MealOnlId"] as! String,
                                        mealName : onlineMealListJson[i]["MealName"] as! String,
                                        mealMemo: onlineMealListJson[i]["MealMemo"] as! String,
                                        ingList: ingredientList
                    ))
            }
            print("finish json")
            print(onlineMealList)
            completionBlock(onlineMealList);
           } catch let error {
             print(error.localizedDescription)
           }
        })
        task.resume()
    }
    
    
    
}
