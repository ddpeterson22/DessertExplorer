//
//  DessertDetail.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import SwiftUI

struct DessertDetail: View {
    @StateObject private var viewModel = DessertDetailViewModel(mealService: MealServiceProvider())
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
                    //  Todo:  research best practices on swiftUI data flows to child views, specifically around retrieval.; Should data retrieval be initiated from 1. parent (faster but breaks encapsulation), or should this be handled in 2. fully encapsulated child (it knows what it needs and retrieves it when it needs it, less handoff in parent).  What pattern is most maintainable and testable?
                    viewModel.fetchMeal(with: mealMeta.id) {
                        print("Meal detail for \(mealMeta.name) fetched.")
                    }
                    //viewModel.fetchMealUsingCombine(with: mealMeta.id)
                }
        }
    }
}

#Preview {
    DessertDetail(mealMeta: Meal(id: "52793", name: "Sticky Toffee Pudding Ultimate", imageUrlString: "https://www.themealdb.com/images/media/meals/xrptpq1483909204.jpg"))
}
