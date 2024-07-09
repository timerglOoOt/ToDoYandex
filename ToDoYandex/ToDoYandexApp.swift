import SwiftUI

@main
struct ToDoYandexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: .init(fileCache: .init(), filename: "test.json"))
        }
    }
}
