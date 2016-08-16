//
//  ReceiptValidatingProductPurchaseEventTargetTests.swift
//  Telephone
//
//  Copyright (c) 2008-2016 Alexey Kuznetsov
//  Copyright (c) 2016 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import XCTest
import UseCases
import UseCasesTestDoubles

final class ReceiptValidatingProductPurchaseEventTargetTests: XCTestCase {
    func testCallsDidPurchaseOnOriginWhenReceiptIsValidOnDidPurchase() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: ValidReceipt())

        sut.didPurchaseProducts()

        XCTAssertTrue(origin.didCallDidPurchase)
    }

    func testCallsDidFailPurchasingOnOriginWhenReceiptIsNotValidOnDidPurchase() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: InvalidReceipt())

        sut.didPurchaseProducts()

        XCTAssertTrue(origin.didCallDidFailPurchasing)
        XCTAssertFalse(origin.invokedError.isEmpty)
    }

    func testCallsDidFailPurchasingOnOriginWhenPurchaseIsNotActiveOnDidPurchase() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: NoActivePurchasesReceipt())

        sut.didPurchaseProducts()

        XCTAssertTrue(origin.didCallDidFailPurchasing)
        XCTAssertFalse(origin.invokedError.isEmpty)
    }

    func testCallsDidStartPurchasingOnOriginOnDidStartPurchasing() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: InvalidReceipt())
        let identifier = "any"

        sut.didStartPurchasingProduct(withIdentifier: identifier)

        XCTAssertTrue(origin.didCallDidStartPurchasing)
        XCTAssertEqual(origin.invokedIdentifier, identifier)
    }

    func testCallsDidFailPurchasingWithErrorOnOriginOnDidFailPurchasingWithError() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: InvalidReceipt())
        let error = "any"

        sut.didFailPurchasingProducts(error: error)

        XCTAssertTrue(origin.didCallDidFailPurchasing)
        XCTAssertEqual(origin.invokedError, error)
    }

    func testCallsDidFailPurchasingOnOriginOnDidFailPurchasing() {
        let origin = ProductPurchaseEventTargetSpy()
        let sut = ReceiptValidatingProductPurchaseEventTarget(origin: origin, receipt: InvalidReceipt())

        sut.didFailPurchasingProducts()

        XCTAssertTrue(origin.didCallDidFailPurchasing)
        XCTAssertTrue(origin.invokedError.isEmpty)
    }
}

private func createProduct() -> Product {
    return Product(identifier: "1", name: "product", price: NSDecimalNumber(integer: 1), localizedPrice: "$1")
}
