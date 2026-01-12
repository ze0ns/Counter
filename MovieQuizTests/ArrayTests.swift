//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 12.01.2026.
//
import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
