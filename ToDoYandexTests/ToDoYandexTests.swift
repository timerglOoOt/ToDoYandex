import XCTest
@testable import ToDoYandex

final class ToDoYandexTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

//   MARK: Тесты для проверки работы CSV

    func test_convert_to_csv_text_format() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let itemToCsv = item.csv
        XCTAssertTrue(itemToCsv.contains(testText), "Строка, полученная из конвертера отличается от ожидаемой")
    }

    func test_convert_from_csv_true() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let itemToCsv = item.csv
        guard let itemFromCsv = TodoItem.parseCsv(csv: itemToCsv) else { return }
        XCTAssertEqual(item, itemFromCsv, "Конвертер отработал неверно")
    }

    func test_convert_from_csv_false() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let anotherItem = TodoItem(text: testText, priority: .high)
        let itemToCsv = item.csv
        guard let itemFromCsv = TodoItem.parseCsv(csv: itemToCsv) else { return }
        XCTAssertNotEqual(anotherItem, itemFromCsv, "Конвертер отработал неверно")
    }
    
//    MARK: Тесты для проверки работы JSON

    func test_json_contains_priority_normal_false() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let json = item.json as? [String: Any]
        XCTAssertTrue(json?["priority"] == nil, "Найдена недопустимая степень важности")
    }

    func test_json_contains_priority_not_normal() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .high)
        let json = item.json as? [String: Any]
        XCTAssertTrue(json?["priority"] != nil, "Не найдена степень важности")
    }

    func test_json_contains_empty_deadline_false() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let json = item.json as? [String: Any]
        XCTAssertTrue(json?["deadline"] == nil, "Найден несуществующий срок сдачи")
    }

    func test_json_contains_deadline_true() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal, deadline: .now)
        let json = item.json as? [String: Any]
        XCTAssertTrue(json?["deadline"] != nil, "Отсутствует срок сдачи")
    }

    func test_convert_from_json_true() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let itemToJson = item.json
        guard let itemFromCsv = TodoItem.parseJson(json: itemToJson) else { return }
        XCTAssertEqual(item, itemFromCsv, "Конвертер отработал неверно")
    }

    func test_convert_from_json_false() throws {
        let testText = "Всем привет, всем пока"
        let item = TodoItem(text: testText, priority: .normal)
        let anotherItem = TodoItem(text: testText, priority: .high)
        let itemToJson = item.json
        guard let itemFromCsv = TodoItem.parseJson(json: itemToJson) else { return }
        XCTAssertNotEqual(anotherItem, itemFromCsv, "Конвертер отработал неверно")
    }

//    MARK: Тесты для проверки работы equal

    func test_compare_equal_items() throws {
        let testText = "Всем привет, всем пока"
        let item1 = TodoItem(text: testText, priority: .normal)
        let item2 = item1
        XCTAssertEqual(item1, item2, "Неправильно работает операция сравнения экземпляров структуры")
    }

    func test_compare_not_equal_items() throws {
        let testText = "Всем привет, всем пока"
        let item1 = TodoItem(text: testText, priority: .normal)
        let item2 = TodoItem(text: testText, priority: .high)
        XCTAssertNotEqual(item1, item2, "Неправильно работает операция сравнения экземпляров структуры")
    }

    func test_save_to_file() throws {
        let fileCache = FileCache()

        let task1 = TodoItem(id: "1", text: "Complete assignment", priority: .high)
        let task2 = TodoItem(id: "2", text: "Prepare presentation", priority: .normal)
        fileCache.addTask(task1)
        fileCache.addTask(task2)

        Task {
            try await fileCache.save(to:"test.json")
        }
    }
}
