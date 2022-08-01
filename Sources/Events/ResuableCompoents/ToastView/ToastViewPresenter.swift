//
//  File.swift
//
//
//  Created by Amway on 28/06/22.
//

import Combine
import Foundation

public final class ToastViewPresenter: ObservableObject {
    private var interactor: ToastViewBusinessLogic
    private var cancellables = Set<AnyCancellable>()

    @Published var state = State.loading

    init(interactor: ToastViewBusinessLogic) {
        self.interactor = interactor
    }

    enum State {
        case loading
        case failure
        case success(ToastError.StaticData)
    }

    func fetchToastErrorData() {
        interactor.fetchToastError()
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .failure
                }
            } receiveValue: { [weak self] data in
                self?.state = .success(data)
            }
            .store(in: &cancellables)
    }
}
