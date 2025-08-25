//
//  IconPickerView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/07.
//

import SwiftUI

struct Icon: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let accessibilityKey: String
}
    // Binding here connects to state variable in the Add/Edit goal view
struct IconPickerView: View {
    @Binding var selectedIconName: String?
    @Environment(\.dismiss) var dismiss
    
    // A list of relevant SF symbols for goal tracking use
    let icons: [Icon] = [
           Icon(name: "target", accessibilityKey: "icon.target"),
           Icon(name: "flag.fill", accessibilityKey: "icon.flag"),
           Icon(name: "star.fill", accessibilityKey: "icon.star"),
           Icon(name: "heart.fill", accessibilityKey: "icon.heart"),
           Icon(name: "flame.fill", accessibilityKey: "icon.flame"),
           Icon(name: "book.fill", accessibilityKey: "icon.book"),
           Icon(name: "pencil", accessibilityKey: "icon.pencil"),
           Icon(name: "graduationcap.fill", accessibilityKey: "icon.graduationCap"),
           Icon(name: "dollarsign.circle.fill", accessibilityKey: "icon.dollarSign"),
           Icon(name: "chart.bar.fill", accessibilityKey: "icon.chartBar"),
           Icon(name: "calendar", accessibilityKey: "icon.calendar"),
           Icon(name: "figure.walk", accessibilityKey: "icon.walk"),
           Icon(name: "dumbbell.fill", accessibilityKey: "icon.dumbbell"),
           Icon(name: "airplane", accessibilityKey: "icon.airplane"),
           Icon(name: "house.fill", accessibilityKey: "icon.house"),
           Icon(name: "lightbulb.fill", accessibilityKey: "icon.lightbulb")
       ]
    
    // Set up grid layout for 3 columns
    let columns = [
        GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
    ]
    
    var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        Button {
                            selectedIconName = nil
                            dismiss()
                        } label: {
                            VStack {
                                Image(systemName: "xmark.circle")
                                    .font(.largeTitle)
                                Text("iconPicker.noIconButton") // ✅ LOCALIZED
                                    .font(.caption)
                            }
                        }
                        .tint(.gray)
                        .accessibilityLabel("iconPicker.noIconButton") // ✅ ACCESSIBILITY
                        
                        // ✅ 3. Loop over the new 'icons' array
                        ForEach(icons) { icon in
                            Button {
                                selectedIconName = icon.name
                                dismiss()
                            } label: {
                                Image(systemName: icon.name)
                                    .font(.largeTitle)
                            }
                            // ✅ 4. Add the accessibility label using the key from our struct
                            .accessibilityLabel(LocalizedStringKey(icon.accessibilityKey))
                        }
                    }
                    .padding()
                }
                .navigationTitle("iconPicker.title") // ✅ LOCALIZED
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("common.close") { dismiss() } // ✅ LOCALIZED
                    }
                }
            }
        }
    }

