//
//  DataPersistanceManager.swift
//  NetflixApp
//
//  Created by Stefan Boblic on 14.12.2022.
//

import UIKit
import CoreData

class DataPersistanceManager {

    private enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }

    static let shared = DataPersistanceManager()

    func downloadTitleWith(model: Title, resultHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let item = TitleItem(context: context)

        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.release_date = item.release_date

        do {
            try context.save()
            resultHandler(.success(()))
        } catch {
            resultHandler(.failure(DatabaseError.failedToSaveData))
        }
    }

    func fetchingTitlesFromDataBase(resultHandler: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()

        do {
            let titles = try context.fetch(request)
            resultHandler(.success(titles))
        } catch {
            resultHandler(.failure(DatabaseError.failedToFetchData))
        }
    }

    func deleteTitleWith(model: TitleItem, resultHandeler: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        context.delete(model)

        do {
            try context.save()
            resultHandeler(.success(()))
        } catch {
            resultHandeler(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
