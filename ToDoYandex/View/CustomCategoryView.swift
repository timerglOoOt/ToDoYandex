import SwiftUI
import CocoaLumberjackSwift

struct CustomCategoryView: View {
    @State private var categoryName = ""
    @State private var selectedColor = Color.blue
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории")) {
                    TextField("Введите название", text: $categoryName)
                }

                Section(header: Text("Цвет категории")) {
                    ColorPicker("Выберите цвет", selection: $selectedColor)
                }
            }
            .navigationBarTitle("Новая категория", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Отмена") {
                    dismiss()
                },
                trailing: Button("Сохранить") {
                    if !categoryName.isEmpty {
                        TodoItemCategory.addCustomCategory(
                            name: categoryName,
                            color: UIColor(
                                cgColor:
                                    selectedColor.cgColor ??
                                CGColor(red: 255, green: 255, blue: 255, alpha: 1)
                            )
                        )
                        DDLogInfo("Added new category with name: \(categoryName)")
                        dismiss()
                    }
                }
            )
        }
        .onAppear {
            DDLogInfo("Opened custom category screen")
        }
    }
}
