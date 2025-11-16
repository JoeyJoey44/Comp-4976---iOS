//
//  HomeView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-14.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewViewModel
    
    @MainActor
    init(viewModel: HomeViewViewModel? = nil) {
        let vm = viewModel ?? HomeViewViewModel()
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                // MARK: DMA Picker
                Picker("City", selection: $viewModel.selectedDMA) {
                    ForEach(viewModel.dmaOptions, id: \.code) { dma in
                        Text(dma.name).tag(dma.code)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedDMA) { _ in
                    Task { await viewModel.fetchEvents() }
                }
                
                // MARK: Loading
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                        .foregroundColor(.white)
                        .padding()
                }
                
                // MARK: Error
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // MARK: Events List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        
                        ForEach(viewModel.eventsByDate.keys.sorted(), id: \.self) { date in
                            Section(header: Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.top)) {
                                    
                                    ForEach(viewModel.eventsByDate[date] ?? []) { event in
                                        NavigationLink(destination: EventDetailView(event: event)) {
                                            EventRowView(event: event)
                                                .padding(.horizontal)
                                        }
                                        
                                    }
                                }
                        }
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Events")
            .onAppear {
                Task { await viewModel.fetchEvents() }
            }
        }
    }
}



#Preview {
    // Use the generic preview wrapper (we pass a dummy Bool and ignore it in the closure)
    // so we can reuse the same helper used elsewhere in the project.
    StatefulPreviewWrapper(true) { _ in
        HomeView(viewModel: HomeViewViewModel.mock())
    }
}
