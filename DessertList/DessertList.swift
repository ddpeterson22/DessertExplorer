//
//  DessertList.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import SwiftUI

// TODO:  Improve fetching data to only as needed, look into caching images.

struct DessertList: View {
    
    @EnvironmentObject var mealServices: MealServices
    @ObservedObject var viewModel = DessertListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.meals, id: \.id) { meal in
                NavigationLink {
                    DessertDetail(mealMeta: meal)
                } label: {
                    MealRow(meal: meal)
                }
            }
            .navigationTitle("Desserts")
        }
    }
}

#Preview {
    DessertList()
        .environmentObject(MealServices())
}
