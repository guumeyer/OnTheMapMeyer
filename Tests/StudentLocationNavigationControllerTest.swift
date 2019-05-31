//
//  StudentInformationNavigationControllerTest.swift
//  OnTheMapMeyerTests
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import XCTest
@testable import OnTheMapMeyer

class StudentLocationNavigationControllerTest: XCTestCase {

    func test_viewDidLoad_rendersTitle() {
        XCTAssertEqual(makeSUT().title, "On The Map")
    }

    func test_viewDidLoad_rendersLogoutLetfButton() {
        let navigationItem = makeSUT().viewControllers.first?.navigationItem

        XCTAssertNotNil(navigationItem)
        XCTAssertEqual(navigationItem?.leftBarButtonItem?.title, "LOGOUT")
    }

    func test_viewDidLoad_rendersRefreshAndAddRigghtButtons() {

        let rightBarButtonItems = makeSUT().viewControllers.first?.navigationItem.rightBarButtonItems

        XCTAssertNotNil(rightBarButtonItems)
        XCTAssertEqual(rightBarButtonItems?[0].image?.pngData(), UIImage(named: "icon_addpin")?.pngData())
        XCTAssertEqual(rightBarButtonItems?[1].image?.pngData(), UIImage(named: "icon_refresh")?.pngData())
    }

    // HELPER
    private func makeSUT(authentication: Authenticaticaion = AuthenticationStub(),
                         loader: StudentLocationLoader = StudentLocationLoaderStub(),
                         selection: @escaping SelectionHandler = {_ in },
                         alertView: @escaping AlerViewHandler = {_,_,_  in },
                         informations: [StudentInformation] = []) -> StudentLocationNavigationController {

        let sut = StudentLocationNavigationController(user: User(key: "0", firstName: "Bob", lastName: "O"),
                                                      authentication: authentication,
                                                      loader: loader,
                                                      selection: selection,
                                                      alertView: alertView)
        _ = sut.view

        return sut
    }
}

class StudentLocationLoaderStub: StudentLocationLoader {

    func save(objectId: String?, location: StudentInformation, completionHandler: @escaping (LoadStudentLocationResult<StudentInformationSavable>) -> Void) {
        completionHandler(.success(StudentInformationSavable(objectId: "", createdAt: Date(), updatedAt: Date()) ))
    }

    func load(completionHandler: @escaping (LoadStudentLocationResult<[StudentInformation]>) -> Void) {
        completionHandler(.success([]))
    }
}

class AuthenticationStub: Authenticaticaion {


    var authorizeResult: AuthenticaticaionResult?
    var logoffResult: LogoffResult?

    init(authorizeResult: AuthenticaticaionResult? = nil,  logoffResult: LogoffResult? = nil ) {
        self.authorizeResult = authorizeResult
        self.logoffResult = logoffResult
    }

    func authorize(credential: UserCredential, completion: @escaping (AuthenticaticaionResult) -> Void) {

        guard let authorizeResult = authorizeResult  else {
            return completion(.failure(UdacityApiLoader.Error.connectivity))
        }

        completion(authorizeResult)
    }

    func logoff(completion: @escaping (LogoffResult) -> Void) {
        guard let logoffResult = logoffResult  else {
            return completion(.failure(UdacityApiLoader.Error.connectivity))
        }

        completion(logoffResult)
    }

    func userDetail(_ userDetail: UserSession, completion: @escaping (UserDetailResult) -> Void) {

    }
}
