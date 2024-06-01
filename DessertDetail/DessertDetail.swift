//
//  DessertDetail.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import SwiftUI

struct DessertDetail: View {
    @EnvironmentObject var mealServices: MealServices
    @ObservedObject var viewModel = DessertDetailViewModel()
    var mealMeta: Meal
    
    var body: some View {
    
        if let meal = viewModel.meal {
            ScrollView {
                AsyncImage(url: URL(string: meal.imageUrlString)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                VStack(alignment: .leading) {
                    Text(meal.name)
                        .font(.title)
                    HStack {
                        Text(meal.area)
                        Spacer()
                        Text(meal.category)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    Divider()
                    Text(meal.getIngredientsString())
                    Divider()
                    Text(meal.getInstructionsText())
                }
                .padding()
            }
        } else {
            ProgressView()
                .onAppear {
                    viewModel.fetchMeal(with: mealMeta.id) {
                        print("Meal detail for \(mealMeta.name) fetched.")
                    }
                }
        }
    }
}

#Preview {
    DessertDetail(mealMeta: Meal(id: "52793", name: "Sticky Toffee Pudding Ultimate", imageUrlString: "https://www.themealdb.com/images/media/meals/xrptpq1483909204.jpg"))
        .environmentObject(MealServices())
}
