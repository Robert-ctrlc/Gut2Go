import SwiftUI

struct WelcomeView: View {
    var user: User?
    
    var body: some View {
        VStack {
            if let userName = user?.name {
                Text("Hi \(userName)!")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("Welcome!")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}
