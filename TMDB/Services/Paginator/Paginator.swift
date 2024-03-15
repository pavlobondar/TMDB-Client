//
//  Paginator.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import Foundation

final class Paginator {
    private var threshold: Int
    private var currentPage: Int
    private var totalPages: Int
    private var isLoading: Bool
    private var paginationClosure: TypeClosure<Int>?
    
    init(threshold: Int, totalPages: Int) {
        self.threshold = threshold
        self.currentPage = 1
        self.totalPages = totalPages
        self.isLoading = false
    }

    func setPaginationClosure(_ closure: @escaping TypeClosure<Int>) {
        self.paginationClosure = closure
    }

    func reset() {
        currentPage = 1
        isLoading = false
    }

    func updateThreshold(_ newThreshold: Int) {
        threshold = newThreshold
    }

    func scrollViewDidScroll(currentIndex: Int, totalItems: Int) {
        guard !isLoading, totalPages > 0, currentPage <= totalPages else { return }

        let remainingItems = totalItems - currentIndex
        if remainingItems <= threshold {
            isLoading = true
            currentPage += 1
            paginationClosure?(currentPage)
        }
    }

    func didFinishLoading() {
        isLoading = false
    }
}
