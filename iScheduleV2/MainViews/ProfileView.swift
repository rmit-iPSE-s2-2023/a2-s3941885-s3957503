import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel = ProfileViewModel()
    @State private var editingMode = false
    @State private var newName: String = ""
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""

    var body: some View {
        
        Form {
            Section(header: Text("Profile Information")) {
                
                if editingMode {
                    TextField("Name", text: $newName)
                    TextField("Email", text: $newEmail)
                    SecureField("Password", text: $newPassword)
                } else {
                    Text("Name: \(profileViewModel.name)")
                    Text("Email: \(profileViewModel.email)")
                    Text("Password: \(profileViewModel.password)")
                }
            }
            
            Section {
                Button("Log Out") {
                    // Handle log out logic here
                    print("Logged out.")
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarItems(trailing: Button(action: {
            if editingMode {
                profileViewModel.name = newName.isEmpty ? profileViewModel.name : newName
                profileViewModel.email = newEmail.isEmpty ? profileViewModel.email : newEmail
                profileViewModel.password = newPassword.isEmpty ? profileViewModel.password : newPassword
            } else {
                newName = profileViewModel.name
                newEmail = profileViewModel.email
                newPassword = profileViewModel.password
            }
            editingMode.toggle()
        }) {
            Text(editingMode ? "Save" : "Edit")
        })
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

