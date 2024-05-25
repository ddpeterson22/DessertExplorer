//
//  MealDetail.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 5/25/24.
//

import Foundation

struct MealDetail: Decodable, Hashable {
  let id: String
  let name: String
  let imageUrlString: String
  let category: String
  let area: String
  let instructions: String
  let tagsString: String?
  let youtubeUrlString: String
  
  let ing1: String?
  let ing2: String?
  let ing3: String?
  let ing4: String?
  let ing5: String?
  let ing6: String?
  let ing7: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "idMeal"
    case name = "strMeal"
    case imageUrlString = "strMealThumb"
    case category = "strCategory"
    case area = "strArea"
    case instructions = "strInstructions"
    case tagsString = "strTags"
    case youtubeUrlString = "strYoutube"
    case ing1 = "strIngredient1"
    case ing2 = "strIngredient2"
    case ing3 = "strIngredient3"
    case ing4 = "strIngredient4"
    case ing5 = "strIngredient5"
    case ing6 = "strIngredient6"
    case ing7 = "strIngredient7"
  }
  
  func getIngredients() -> [String] {
    var ingredients = [String]()
    
    ingredients.append(ing1 ?? "")
    ingredients.append(ing2 ?? "")
    ingredients.append(ing3 ?? "")
    ingredients.append(ing4 ?? "")
    ingredients.append(ing5 ?? "")
    ingredients.append(ing6 ?? "")
    ingredients.append(ing7 ?? "")
    
    return ingredients
    
  }
  
  func getIngredientsString() -> String {
    var text = "Ingredients: "
    
    for ingredient in getIngredients() {
      text.append("\(ingredient), ")
    }
    
    return String(String(text.dropLast()).dropLast())
  }
  
  func getTags() -> [String] {
    return self.tagsString?.components(separatedBy: ",") ?? []
  }
  
  func getTagsString() -> String {
    var text = "Tags: "
    
    for tag in getTags() {
      text.append("\(tag), ")
    }
    
    return String(String(text.dropLast()).dropLast())
  }
  
  func getInstructionsText() -> String {
    return instructions.replacingOccurrences(of: "\n", with: "\n\n")
  }
}

struct MealDetailResponse: Decodable {
  let meals: [MealDetail]
}
