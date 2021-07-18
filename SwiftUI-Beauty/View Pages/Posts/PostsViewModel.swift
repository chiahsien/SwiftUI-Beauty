//
//  PostsViewModel.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/17.
//

import Foundation
import Combine

final class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var error: CustomError? = nil
    @Published var isFetchingPosts: Bool = false
    let forumName: String
    let fetcher: Fetcher

    private var cancellables = Set<AnyCancellable>()
    private var page: UInt = 0

    init(fetcher: Fetcher) {
        self.fetcher = fetcher
        forumName = fetcher.name
    }

    func fetchMorePosts() {
        fetchPosts(at: page + 1)
    }

    private func fetchPosts(at page: UInt) {
        guard !isFetchingPosts else { return }

        error = nil
        isFetchingPosts = true

        fetcher.fetchPosts(at: page)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
                self.isFetchingPosts = false
            } receiveValue: { [unowned self] posts in
                self.posts.append(contentsOf: posts)
                self.page = page
            }
            .store(in: &cancellables)
    }
}
