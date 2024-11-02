import SwiftUI
import Supabase

struct ContentView: View {
   
    let supabaseURL = URL(string: "https://yildhmlzhwjgxpnyqryn.supabase.co")!
    let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpbGRobWx6aHdqZ3hwbnlxcnluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA1NTQyOTMsImV4cCI6MjA0NjEzMDI5M30.Sep8Qyl4uf1J7Mbr9kltG7bzfAJG-OOJ8J14LPLg034"
    
    @State private var client: SupabaseClient? = nil
    
    var body: some View {
        VStack {
            Text("Supabase Test")
                .font(.title)
                .padding()

            Button(action: addDataToSupabase) {
                Text("Add Sample Data")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: fetchDataFromSupabase) {
                Text("Fetch Data")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Button(action: testConnection) {
                Text("Test Connection")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            
            client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
            print("Supabase client initialized: \(client != nil)")
        }
    }

   
    func addDataToSupabase() {
        guard let client = client else { return }
        
        let newPatient: [String: AnyEncodable] = [
            "name": AnyEncodable("Sample Patient"),
            "age": AnyEncodable(30),
            "symptoms": AnyEncodable("bloating, pain")
        ]
        
        Task {
            do {
                let result = try await client
                    .from("patients")
                    .insert(newPatient)
                    .execute()
                print("Data added successfully! Result: \(result)")
            } catch let error as HTTPError {
                let responseData = error.data
                let errorString = String(data: responseData, encoding: .utf8) ?? "Unknown error"
                print("Error adding data: \(errorString)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

   
    func fetchDataFromSupabase() {
        guard let client = client else { return }

        Task {
            do {
                let response = try await client
                    .from("patients")
                    .select()
                    .execute()
                print("Data fetched: \(response)")
            } catch let error as HTTPError {
                let responseData = error.data
                let errorString = String(data: responseData, encoding: .utf8) ?? "Unknown error"
                print("Error fetching data: \(errorString)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }

    
    func testConnection() {
        guard let client = client else {
            print("Client not initialized")
            return
        }
        
        Task {
            do {
                let response = try await client
                    .from("patients")
                    .select()
                    .limit(1)
                    .execute() 
                print("Connection successful: \(response)")
            } catch let error as HTTPError {
                let responseData = error.data
                let errorString = String(data: responseData, encoding: .utf8) ?? "Unknown error"
                print("Error testing connection: \(errorString)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
