//
//  CoreDataController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 16.09.2023.
//

import Foundation
import CoreData

final class CoreDataController: FetchData {
    
    // MARK: - Singleton
    static let shared = CoreDataController()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: Constants.coreDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[PostFeed], Error>) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<PostFeedCD>(entityName: Constants.postFeedEntityName)
        
        do {
            let postObjects = try context.fetch(request)
            let posts = postObjects.map { post in
                PostFeed(
                    postId: Int(post.postId),
                    timeshamp: Int(post.timeshamp),
                    title: post.title ?? "",
                    previewText: post.previewText ?? "",
                    likesCount: Int(post.likesCount)
                )
            }
            
            if posts.isEmpty {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
    }
    
    func storePosts(posts: [PostFeed]) {
        let context = persistentContainer.newBackgroundContext()
        
        context.perform {
            posts.forEach { post in
                let postFeedCD = PostFeedCD(context: context)
                postFeedCD.postId = Int32(post.postId)
                postFeedCD.timeshamp = Int32(post.timeshamp)
                postFeedCD.title = post.title
                postFeedCD.previewText = post.previewText
                postFeedCD.likesCount = Int32(post.likesCount)
            }
            try? context.save()
        }
    }
    
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostFeedDetail, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<PostFeedDetailCD>(entityName: Constants.postFeedDetailEntityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let postDetailObjecs = try context.fetch(request)
            let postDetail = postDetailObjecs.filter({$0.postId == postId}).map { data in
                PostFeedDetail(
                    postId: Int(data.postId),
                    timeshamp: Int(data.timeshamp),
                    title: data.title ?? "",
                    text: data.text ?? "",
                    postImage: data.postImage ?? "",
                    likesCount: Int(data.likesCount)
                )
            }
            
            if postDetail.isEmpty {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            
            completion(.success(postDetail.first!))
        } catch {
            completion(.failure(error))
        }
    }
    
    func storeDetailPost(post: PostFeedDetail) {
        let context = persistentContainer.newBackgroundContext()
        let entity = NSEntityDescription.entity(forEntityName: Constants.postFeedDetailEntityName, in: context)
        
        guard let entity = entity else {
            return
        }
        
        let newPost = NSManagedObject(entity: entity, insertInto: context)
        
        context.perform {
            newPost.setValue(post.postId, forKey: "postId")
            newPost.setValue(post.timeshamp, forKey: "timeshamp")
            newPost.setValue(post.title, forKey: "title")
            newPost.setValue(post.text, forKey: "text")
            newPost.setValue(post.postImage, forKey: "postImage")
            newPost.setValue(post.likesCount, forKey: "likesCount")
        }
        try? context.save()
    }
}
