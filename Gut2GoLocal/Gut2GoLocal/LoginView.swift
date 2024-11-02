import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var isNewUser = true
    @State private var isLoggedIn = false
    @State private var loggedInUser: User?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(isNewUser ? "Register" : "Login")
                    .font(.largeTitle)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if isNewUser {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: handleAuthentication) {
                    Text(isNewUser ? "Register" : "Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isNewUser.toggle()
                }) {
                    Text(isNewUser ? "Already have an account? Login" : "Don't have an account? Register")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                NavigationLink(destination: WelcomeView(user: loggedInUser), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    private func handleAuthentication() {
        if isNewUser {
            registerUser()
        } else {
            loginUser()
        }
    }
    
    private func registerUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if existingUsers.isEmpty {
                // No existing user found, proceed with registration
                let newUser = User(context: viewContext)
                newUser.email = email
                newUser.password = password
                newUser.name = name
                
                try viewContext.save()
                loggedInUser = newUser
                isLoggedIn = true
            } else {
                print("User already exists with this email.")
            }
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
        }
    }
    
    private func loginUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                loggedInUser = user
                isLoggedIn = true
            } else {
                print("Invalid email or password.")
            }
        } catch {
            print("Failed to log in user: \(error.localizedDescription)")
        }
    }
}
