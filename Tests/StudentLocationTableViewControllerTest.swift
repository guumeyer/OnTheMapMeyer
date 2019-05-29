//
//  StudentLocationTableViewControllerTest.swift
//  OnTheMapMeyerTests
//
//  Created by Meyer, Gustavo on 5/14/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import XCTest
@testable import OnTheMapMeyer

class StudentLocationTableViewControllerTest: XCTestCase {

    func test_viewDidLoad_rendersStudentInformation() {
        let student = StudentInformation.make()
        XCTAssertEqual(makeSUT(locations: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(locations: [student]).tableView.numberOfRows(inSection: 0), 1)
    }

    func test_viewDidLoad_withStudentInformation_configuresCell() {
        let student = StudentInformation.make(firstName: "Name1",
                                              lastName: "LastName",
                                              mediaURL: "Link1")
        let sut = makeSUT(locations: [student])

        let cell = sut.tableView.cell(at: 0)

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.imageView?.image?.pngData(), UIImage(named: "icon_pin")?.pngData())
        XCTAssertEqual(cell?.textLabel?.text, "Name1 LastName")
        XCTAssertEqual(cell?.detailTextLabel?.text, "Link1")
    }

    func test_selectStudentInformation_notifiesDelegateSelection(){
        var countCallback = 0
        let sut = makeSUT(locations: [StudentInformation.makeMock()], selection: {_ in countCallback += 1 })

        sut.tableView.select(row: 0)

        XCTAssertEqual(countCallback, 1)
    }

    func test_updateWillBegin_activityIndicatorHidden_showsActivityIndicator() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        sut.updateWillBegin()

        XCTAssertFalse(sut.activityIndicator.isHidden)
    }

    func test_update_withEmptyResult_doesNotRenderStudentInformation() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        StudentLocationManager.shared.locations =  []
        sut.update()

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func test_update_withTowResult_rendersTwoStudentInformation() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        StudentLocationManager.shared.locations = [StudentInformation.makeMock(), StudentInformation.makeMock()]
        sut.update()

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func test_showAlert_withTitleAndMessage_notifiesDelegateAlertView() {
        var countCallback = 0
        let sut = makeSUT(locations: [StudentInformation.makeMock()], alertView: { _ , _, _ in  countCallback += 1 })

        sut.showAlert(title: "title", message: "message")

        XCTAssertEqual(countCallback, 1)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    override func tearDown() {
        StudentLocationManager.shared.locations = []
    }

    // MARK: Helpers
    func makeSUT(locations: [StudentInformation],
                 selection: @escaping SelectionHandler = { _ in },
                 alertView: @escaping AlerViewHandler = { _ ,_ ,_ in })
        -> StudentLocationTableViewController {
            StudentLocationManager.shared.locations = locations
            let sut = StudentLocationTableViewController(selection: selection,
                                                         alertView: alertView)
            _ = sut.view
            return sut
    }
}
