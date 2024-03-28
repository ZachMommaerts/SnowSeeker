//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Zach Mommaerts on 3/24/24.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    let sortOptions = ["Default", "Alphabetical", "Country"]
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    @State private var sortOption = "default"
    
    var sortedResorts: [Resort] {
        var sortedResortArray = [Resort]()
    
        switch sortOption {
        case "Alphabetical":
            sortedResortArray = resorts.sorted { $0.name < $1.name }
        case "Country":
            sortedResortArray = resorts.sorted { $0.country < $1.country }
        case "Default":
            sortedResortArray = resorts
        default:
            sortedResortArray = resorts
        }
        
        return sortedResortArray
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            sortedResorts
        } else {
            sortedResorts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundStyle(.secondary)
                    }
                    
                    if favorites.contains(resort) {
                        Spacer()
                        
                        Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar{
                Picker("Sort by", selection: $sortOption) {
                    ForEach(sortOptions, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
