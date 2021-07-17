//
//  ForumsView.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/17.
//

import SwiftUI

struct ForumsView: View {
    let forums: [Fetcher]
    var body: some View {
        NavigationView {
            List(forums, id: \.name, rowContent: { forum in
                Text(forum.name)
                    .font(.title)
                    .frame(height: 50.0)
            })
            .navigationTitle("Forum List")
        }
    }
}

struct ForumsView_Previews: PreviewProvider {
    static var previews: some View {
        let forums: [Fetcher] = [
            TimLiaoFetcher(),
            JKForum(forum: .western),
            JKForum(forum: .asian),
            JKForum(forum: .amateur),
            JKForum(forum: .jkfGirl)
        ]

        ForumsView(forums: forums)
    }
}
