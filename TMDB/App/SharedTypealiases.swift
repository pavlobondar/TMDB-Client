//
//  SharedTypealiases.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

typealias TypeClosure<T> = (T) -> Void
typealias VoidClosure = () -> Void
typealias ErrorClosure = (Error) -> Void
typealias ResultClosure<T> = (Result<T, Error>) -> Void
