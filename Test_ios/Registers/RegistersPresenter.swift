//
//  RegistersPresenter.swift
//  Test_ios
//
//  Created udom on 20/6/2562 BE.
//  Copyright © 2562 udom Neakaew. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class RegistersPresenter: RegistersPresenterProtocol {

    weak private var view: RegistersViewProtocol?
    var interactor: RegistersInteractorProtocol?
    private let router: RegistersWireframeProtocol

    init(interface: RegistersViewProtocol, interactor: RegistersInteractorProtocol?, router: RegistersWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func confirmSuccess() {
        
    }
}
