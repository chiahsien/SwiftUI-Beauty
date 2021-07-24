//
//  PhotosViewModel.swift
//  SwiftUI-Beauty
//
//  Created by Nelson on 2021/7/18.
//

import Foundation
import Combine

final class PhotosViewModel: ObservableObject {
    @Published var urls: [URL] = []
    @Published var error: CustomError? = nil
    @Published var isFetchingPhotos: Bool = false
    
    @Published var isPresented = false
    @Published var selectedIndex = 0

    var postTitle: String {
        post.title
    }

    private var cancellables = Set<AnyCancellable>()
    private let fetcher: Fetcher
    private let post: Post

    init(fetcher: Fetcher, post: Post) {
        self.fetcher = fetcher
        self.post = post
    }

    func fetchPhotos() {
        guard !isFetchingPhotos else { return }

        error = nil
        isFetchingPhotos = true

        fetcher.fetchPhotos(at: post.url)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
                self.isFetchingPhotos = false
            } receiveValue: { [unowned self] urls in
                self.urls = urls
            }
            .store(in: &cancellables)
    }
}
