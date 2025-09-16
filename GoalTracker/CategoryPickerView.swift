//
//  CategoryPickerView.swift
//  GoalTracker
//
//  Created by AJ on 2025/08/28.
//

import SwiftUI

struct CategoryPickerView: View {
    @ObservedObject var viewModel: AddGoalViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(GoalLibrary.categories) { category in
                Button {
                    viewModel.selectedCategoryID = category.id
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: category.iconName)
                            .renderingMode(.original)
                            .foregroundStyle(viewModel.appSettings.themeColor(for: category.colorName))
                        Text(LocalizedStringKey(category.name))
                        Spacer()
                        if viewModel.selectedCategoryID == category.id {
                            Image(systemName: "checkmark")
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("addGoal.picker.category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
            }
        }
    }
}
