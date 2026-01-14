//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Oschepkov Aleksandr on 12.01.2026.
//

import XCTest // не забывайте импортировать фреймворк для тестирования
@testable import MovieQuiz // импортируем наше приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
          let array = [1, 1, 2, 3, 5]
          let value = array[safe: 2]
          XCTAssertNotNil(value)
          XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}
