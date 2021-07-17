//
//  DataModel.swift
//  SwiftUI Beauty
//
//  Created by Nelson on 2018/8/3.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation

struct Post: Identifiable, Equatable {
    var id: String { url.absoluteString }

    let title: String
    let coverURL: URL
    let url: URL
}
