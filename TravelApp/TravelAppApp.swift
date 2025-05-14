import SwiftUI

@main
struct TravelAppApp: App {
    @StateObject var viewModel: TravelAppViewModel = TravelAppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
