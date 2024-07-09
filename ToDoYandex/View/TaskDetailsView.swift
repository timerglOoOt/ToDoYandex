import SwiftUI

struct TaskDetailsView: View {
    @ObservedObject private var taskDetailsViewModel: TaskDetailsViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var isExpanded = false
    @State var showingEmptyTextAlert = false
    @State var showingCalendar = false
    @State var color = Color.clear
    @FocusState private var isTextEditorFocused: Bool

    init(taskDetailsViewModel: TaskDetailsViewModel) {
        self.taskDetailsViewModel = taskDetailsViewModel
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if  horizontalSizeClass == .compact && verticalSizeClass == .compact {
                    horizontalView
                } else {
                    verticalView
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Готово") {
                        isTextEditorFocused = false
                    }
                }
            }
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Отменить") {
                dismiss()
            }, trailing: Button("Сохранить") {
                if taskDetailsViewModel.taskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showingEmptyTextAlert = true
                } else {
                    let item = TodoItem(
                        id: taskDetailsViewModel.id,
                        text: taskDetailsViewModel.taskText,
                        priority: taskDetailsViewModel.priority,
                        deadline: taskDetailsViewModel.deadlineEnabled ? taskDetailsViewModel.deadline : nil,
                        isDone: false,
                        createdDate: .now,
                        hexColor: color.toHex(),
                        category: taskDetailsViewModel.category
                    )
                    taskDetailsViewModel.addTodoItem(item)
                    dismiss()
                }
            })
            .alert(isPresented: $showingEmptyTextAlert) {
                Alert(
                    title: Text("Пустой текст"),
                    message: Text("Введите текст задачи перед сохранением."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .background(Color("backgroundColor"))
        }
    }

    private var deleteButton: some View {
        Button(action: {
            taskDetailsViewModel.deleteTodoItem(by: taskDetailsViewModel.id)
            dismiss()
        }, label: {
            Text("Удалить")
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("detailColor"))
                .cornerRadius(10)
                .padding(.horizontal)
        })
    }

    private var horizontalView: some View {
        HStack(spacing: 0) {
            VStack {
                CustomTextEditor(text: $taskDetailsViewModel.taskText, placeholder: "Что надо сделать?")
                    .focused($isTextEditorFocused)
                    .frame(maxWidth: isExpanded ? .infinity : UIScreen.main.bounds.width / 2)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = true
                        }
                    }

                if isExpanded {
                    controlsView
                        .transition(.opacity)
                }
            }

            if !isExpanded {
                controlsView
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .transition(.opacity)
            }
        }
    }

    private var verticalView: some View {
        VStack {
            CustomTextEditor(text: $taskDetailsViewModel.taskText, placeholder: "Что надо сделать?")
                .focused($isTextEditorFocused)
                .padding(.horizontal)
            controlsView
                .padding()
                .background(Color("detailColor"))
                .cornerRadius(10)
                .padding(.horizontal)
            Spacer()
            deleteButton
                .padding(.bottom)
        }
    }

    private var controlsView: some View {
        VStack {
            priorityPicker
            Divider()
            categoryPicker
            Divider()
            colorPicker
            Divider()
            deadlineToggle
            if showingCalendar {
                DatePicker("", selection: $taskDetailsViewModel.deadline, in: Date.now..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                    .environment(\.locale, Locale.init(identifier: "ru"))
            }
        }
    }

    private var priorityPicker: some View {
        HStack {
            Text("Важность")
                .padding(.horizontal)
            Spacer()
            Picker("Priority", selection: $taskDetailsViewModel.priority) {
                Text("\u{2193}").tag(Priority.low)
                Text("нет").tag(Priority.normal)
                Text("\u{203C}").tag(Priority.high)
            }
            .pickerStyle(.segmented)
            .frame(width: 140)
            .padding(.horizontal)
        }
    }

    private var categoryPicker: some View {
        HStack {
            Text("Категория")
            Spacer()
            Picker("Категория", selection: $taskDetailsViewModel.category) {
                ForEach(TodoItemCategory.allCases) { category in
//                    HStack {
                        Text(category.name)
                            .foregroundStyle(Color(category.color))
//                    }
                            .tag(category)
                }
            }
        }
        .padding(.horizontal)
    }

    private var colorPicker: some View {
        VStack {
            ColorPicker(selection: $color) {
                Text(color.toHex())
                    .padding(.horizontal, 6)
                    .background(Color(uiColor: UIColor.systemGray4))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }

    private var deadlineToggle: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if taskDetailsViewModel.deadlineEnabled {
                    Text(taskDetailsViewModel.deadline.toString(
                        with:
                            Constant.DateFormate.dayWithFullMonthAndYear.rawValue
                        )
                    )
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.4)) {
                                if taskDetailsViewModel.deadlineEnabled {
                                    showingCalendar.toggle()
                                }
                            }
                        }
                }
            }
            .padding(.horizontal)
            Spacer()
            Toggle(isOn: $taskDetailsViewModel.deadlineEnabled) {
            }.onTapGesture {
                withAnimation(.easeIn(duration: 0.4)) {
                    taskDetailsViewModel.deadlineEnabled.toggle()
                    showingCalendar = false
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(taskDetailsViewModel: .init(fileCache: FileCache(), id: ""))
    }
}
