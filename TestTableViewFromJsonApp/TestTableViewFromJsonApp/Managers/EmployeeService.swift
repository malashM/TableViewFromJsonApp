//
//  EmployeeService.swift
//  TestTableViewFromJsonApp
//
//  Created by Mikhail Malaschenko on 16.06.23.
//

import RxSwift

typealias EmployeeResult = Result<EmployeeResponseModel?, NetworkError>

final class EmployeeService {
    private let networkManager = NetworkManager.shared
    private let context = CoreDataStorageManager.shared.context
    private let storage: CoreDataStorage<Employee, EmployeeModel> = CoreDataStorageManager.shared.storage()
    
    private let disposeBag = DisposeBag()
    
    func fetchFromRemote() -> Single<[EmployeeModel]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let url = Constants.Url.loadEmployees
            let task = Task {
                let result: EmployeeResult = await self.networkManager.fetchData(from: url)
                switch result {
                case .success(let data):
                    let employees = data?.data ?? []
                    single(.success(employees))
                case.failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    func updateLocal(_ models: [EmployeeModel]) {
        storage.addAll(models)
    }
    
    func fetchFromLocal() -> [EmployeeModel] {
        storage.getAll()
    }
    
    func deleteFromLocal(_ model: EmployeeModel) {
        storage.remove(model)
    }
}
