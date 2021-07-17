//
//  AppContentView.swift
//  SwiftUI Beauty
//
//  Created by Nelson on 2021/7/17.
//

import SwiftUI

struct AppContentView: View {
    let forums: [Fetcher] = [
        TimLiaoFetcher(),
        JKForum(forum: .western),
        JKForum(forum: .asian),
        JKForum(forum: .amateur),
        JKForum(forum: .jkfGirl)
    ]

    var body: some View {
        ForumsView(forums: forums)
    }

}

struct AppContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
    }
}
