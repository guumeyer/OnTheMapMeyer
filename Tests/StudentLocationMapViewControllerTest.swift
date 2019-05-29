//
//  StudentInformationMapViewControllerTest.swift
//  OnTheMapMeyerTests
//
//  Created by Meyer, Gustavo on 5/15/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import XCTest
import MapKit
@testable import OnTheMapMeyer

class StudentLocationMapViewControllerTest: XCTestCase {

    func test_viewDidLoad_rendersStudentInformation() {
        let informations1 = [StudentInformation.makeMock()]
        let informations2 = [StudentInformation.makeMock(), StudentInformation.makeMock()]

        XCTAssertEqual(makeSUT(locations: []).mapView.annotations.count, 0)
        XCTAssertEqual(makeSUT(locations: informations1).mapView.annotations.count, 1)
        XCTAssertEqual(makeSUT(locations: informations2).mapView.annotations.count, 2)
    }

    func test_viewDidLoad_withStudentInformation_configuresPin(){
        let studentInformation = StudentInformation.make(firstName: "Jarrod",
                                                         lastName: "Parkes",
                                                         mediaURL: "https://www.linkedin.com/in/jarrodparkes",
                                                         latitude: 34.7303688,
                                                         longitude: -86.5861037)

        let sut = makeSUT(locations: [studentInformation])

        let marker = sut.mapView.delegate?.mapView?(sut.mapView,
                                                    viewFor: sut.mapView.annotations[0]) as? MKMarkerAnnotationView
        let annotation = marker?.annotation

        XCTAssertNotNil(marker)
        XCTAssertNotNil(annotation)
        XCTAssertEqual(annotation?.title, "Jarrod Parkes")
        XCTAssertEqual(annotation?.subtitle, "https://www.linkedin.com/in/jarrodparkes")
        XCTAssertEqual(annotation?.coordinate.latitude, 34.7303688)
        XCTAssertEqual(annotation?.coordinate.longitude, -86.5861037)
    }

    func test_selectStudentInformation_notifiesDelegateSelectionAndDeselectMarkerAnnotationView(){
        var countCallback = 0
        let sut = makeSUT(locations: [StudentInformation.makeMock()], selection: {_ in countCallback += 1 })
        let marker = MKMarkerAnnotationView(annotation: sut.mapView.annotations[0], reuseIdentifier: "marker")

        sut.mapView.delegate?.mapView?(sut.mapView,
                                     annotationView: marker,
                                     calloutAccessoryControlTapped: UIControl())

        XCTAssertEqual(countCallback, 1)
    }

    func test_updateWillBegin_activityIndicatorHidden_showsActivityIndicator() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        sut.updateWillBegin()

        XCTAssertFalse(sut.activityIndicator.isHidden)
    }

    func test_update_withEmptyResult_doesNotRenderStudentInformation() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        StudentLocationManager.shared.locations = []
        sut.update()

        XCTAssertEqual(sut.mapView.annotations.count, 0)
        XCTAssertTrue(sut.activityIndicator.isHidden)
    }

    func test_update_withTowResult_rendersTwoStudentInformation() {
        let sut = makeSUT(locations: [StudentInformation.makeMock()])

        StudentLocationManager.shared.locations = [StudentInformation.makeMock(), StudentInformation.makeMock()]
        sut.update()

        XCTAssertEqual(sut.mapView.annotations.count, 2)
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
    func makeSUT(locations: [StudentInformation] = [],
                 selection: @escaping SelectionHandler = { _ in },
                 alertView: @escaping AlerViewHandler = { _ ,_ ,_ in }) -> StudentLocationMapViewController {
        StudentLocationManager.shared.locations = locations
        let sut = StudentLocationMapViewController(selection: selection, alertView: alertView)

        _ = sut.view

        return sut
    }

    
}
