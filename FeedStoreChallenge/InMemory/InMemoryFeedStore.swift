//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Aaron Huánuco on 17/09/2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class InMemoryFeedStore: FeedStore {
    private var cache: (feed: [LocalFeedImage], timestamp: Date)?
    private let queue = DispatchQueue(label: "\(type(of: InMemoryFeedStore.self))Queue", attributes: .concurrent)

    public init() { }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        queue.async(flags: .barrier) {
            self.cache = nil
            completion(nil)
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        queue.async(flags: .barrier) {
            self.cache = (feed, timestamp)
            completion(nil)
        }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async {
            if let cache = self.cache {
                completion(.found(feed: cache.feed, timestamp: cache.timestamp))
            } else {
                completion(.empty)
            }
        }
    }
}
