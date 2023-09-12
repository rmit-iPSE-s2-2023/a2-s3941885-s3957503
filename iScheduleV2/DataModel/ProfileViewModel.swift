//
//  ProfileViewModel.swift
//  iScheduleV2
//
//  Created by Edward on 27/8/2023.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user_id: UUID = UUID()  // Added UUID
    @Published var name: String = "John Smith"
    @Published var email: String = "veryreal@gmail.com"
    @Published var password: String = "password123"
}
