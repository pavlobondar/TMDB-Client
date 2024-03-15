//
//  FlowEvent.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

protocol FlowEvent {}

typealias FlowResult<T: FlowEvent> = TypeClosure<T>
