import SwiftUI
import CocoaLumberjackSwift
import FileCache

@main
struct ToDoYandexApp: App {
    init() {
        configureLog()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: .init(fileCache: .init(), filename: "test.json"))
        }
    }

    private func configureLog() {
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
