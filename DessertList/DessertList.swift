//
//  DessertList.swift
//  DessertExplorer
//
//  Created by Daniel Peterson on 6/1/24.
//

import SwiftUI

struct DessertList: View {
    
    @EnvironmentObject var mealServices: MealServices
    @ObservedObject var viewModel = DessertListViewModel()
    
    var body: some View {
        List(viewModel.meals, id: \.id) { meal in
            MealRow(meal: meal)
        }
        .onAppear { // TODO:  Improve fetching to only happen as needed, look into caching images.
            viewModel.fetchDesserts {
                print("view Model fetched.")
            }
        }
    }
}

#Preview {
    DessertList()
        .environmentObject(MealServices())
}
