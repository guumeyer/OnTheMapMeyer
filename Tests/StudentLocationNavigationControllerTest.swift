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
    private func makeSUT(loader: StudentLocationLoader = StudentLocationLoaderStub(),
                         selection: @escaping SelectionHandler = {_ in },
                         alertView: @escaping AlerViewHandler = {_,_,_  in },
                         informations: [StudentLocation] = []) -> StudentLocationNavigationController {
        let sut = StudentLocationNavigationController(loader: StudentLocationLoaderStub(),
                                                   selection: selection,
                                                   alertView: alertView,
                                                   informations: informations)
        _ = sut.view

        return sut
    }
}

class StudentLocationLoaderStub: StudentLocationLoader {
    func load(completionHandler: @escaping (LoadStudentLocationResult<[StudentLocation]>) -> Void) {
        completionHandler(.success([]))
    }
}
