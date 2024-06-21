import SwiftUI

struct ContentView: View {
    func printJson(item: TodoItem) -> Any {
        return item.json
    }
    let item = TodoItem(text: "Поспать", priority: .high)
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
//            Button("Print JSON and item") {
//                print(self.item)
//                let json = printJson(item: self.item)
//                print(json)
//                guard let item = TodoItem.parse(json: json) else {
//                    print("suiii")
//                    return
//                }
//                print(item)
//            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
