import SwiftUI
import CocoaLumberjackSwift

struct ContentView: View {
    @ObservedObject var contentViewModel: ContentViewModel
    @State var isOpened = false
    @State var itemId = ""
    @State var showAllItems = true
    @State private var showingCustomCategory = false

    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Выполнено - \(contentViewModel.doneItemsCount)")
                        Spacer()
                        Button(action: {
                            showAllItems.toggle()
                        }, label: {
                            Text(showAllItems ? "Скрыть" : "Показать")
                                .foregroundColor(.blue)
                                .padding(.trailing)
                                .fontWeight(.semibold)
                        })
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal)
                    todoList
                }
                VStack {
                    Spacer()
                    addButton
                }
                .navigationTitle("Мои дела")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: calendar) {
                           Image(systemName: "calendar")
                               .imageScale(.large)
                       }
                   }

                    ToolbarItem(placement: .navigationBarLeading) {
                       Image(systemName: "plus")
                           .imageScale(.large)
                           .foregroundColor(.blue)
                           .onTapGesture {
                               showingCustomCategory.toggle()
                           }
                    }
                }
                .sheet(isPresented: $isOpened) {
                    TaskDetailsView(
                        taskDetailsViewModel: TaskDetailsViewModel(
                            fileCache: contentViewModel.fileCache, id: itemId
                        )
                    )
                }
                .sheet(isPresented: $showingCustomCategory) {
                    CustomCategoryView()
                }
            }
            .onDisappear {
                contentViewModel.saveItems()
            }
            .background(Color("backgroundColor"))
        }
        .onAppear {
            DDLogInfo("Opened main screen")
        }
        .scrollContentBackground(.hidden)
    }

    private var calendar: some View {
        ZStack {
            CalendarSUIView(viewModel: contentViewModel)
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline)
            VStack {
                Spacer()
                addButton
            }
        }
    }

    private var todoList: some View {
        List {
            ForEach($contentViewModel.items) { $item in
                if showAllItems || !item.isDone {
                    TodoRow(item: $item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openItem(by: item.id)
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                withAnimation {
                                    contentViewModel.updateItemStatus(id: item.id)
                                }
                            }, label: {
                                Image(systemName: "checkmark.circle")
                            })
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                contentViewModel.deleteTodoItem(by: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                openItem(by: item.id)
                            } label: {
                                Image(systemName: "info.circle.fill")
                            }
                            .tint(.gray)
                        }
                }
            }
            Text("Новое")
                .foregroundStyle(Color.gray)
                .padding(.leading, 40)
                .onTapGesture {
                    isOpened.toggle()
                }
        }
        .background(Color("backgroundColor"))
    }

    private var addButton: some View {
        Button(action: addItem) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding()
    }

    private func addItem() {
        itemId = ""
        isOpened.toggle()
    }

    private func openItem(by id: String) {
        itemId = id
        isOpened.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contentViewModel: .init(fileCache: .init(), filename: "test.json"))
    }
}
