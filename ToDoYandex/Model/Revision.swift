import Foundation

@MainActor
class Revision {

    static let shared = RevisionValue()
    private init () {}

    private var revision: Int = 0

    func getRevision() -> Int {
        return self.revision
    }

    func setRevision(_ newRevision: Int) {
        self.revision = newRevision
    }

    func incrementRevision() {
        self.revision = self.revision + 1
    }
}
