//
//  MealRow.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import SwiftUI

struct MealRow: View {
    var meal: Meal
    
    var body: some View {
        
        HStack {
            AsyncImage(url: URL(string: meal.imageUrlString)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.pink, lineWidth: 3)
            }
            .shadow(radius: 7)
            Text(meal.name)
            
            Spacer()
        }
    }
}

#Preview {
    MealRow(meal: Meal(id: "0001", name: "Dessert Name", imageUrlString: "https://www.nope.com"))
}
