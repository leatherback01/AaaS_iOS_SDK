# LAAS

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then input your LeatherBack public key to be able to test

## Requirements

- Xcode 11.0 or greater
- iOS 10 or greater


## Installation

LAAS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LAAS'
```

## Usage

#### Import LAAS
```swift
import LAAS
```

```swift
let param = LeatherBackTransactionParam(amount: 10.00, currencyCode: .GBP, showPersonalInformation: true, reference: "your unique reference number", key: "your public key")
let paymentVC = LeatherBackViewController(delegate: self, param: param)
present(paymentVC, animated: true)

```

```swift
let param = LeatherBackTransactionParam(amount: 10.00, currencyCode: .GBP, showPersonalInformation: false, reference:  "your unique reference number", customerEmail: "johndoe@leatherback.co", customerName: "John Doe", key: "your public key")
let paymentVC = LeatherBackViewController(delegate: self, param: param)
present(paymentVC, animated: true)

```

To receive events from the `LeatherBackViewController` your presenting viewcontroller will need to conform to the `LeatherBackDelegate`

```swift
class ViewController: UIViewController, LeatherBackDelegate {

    func onLeatherBackError(error: LeatherBackErrorResponse) {
        print("error \(error.localizedDescription)")
    }
    
    func onLeatherBackSuccess(response: LeatherBackResponse) {
        //Use this reference to verify payment/transaction with LeatherBack
        print("success \(response.reference)")
    }
    
    func onLeatherBackDimissal() {
        print("dismissed")
    }
}
```

## LeatherBackTransactionParam

if `showPersonalInformation` is set to `false`, merchants are to provide the Customer's Name and Email address but if  `showPersonalInformation` is set to `true`, LeatherBack will collect this information from the customer during checkout.

if `reference` is set to an empty string, it defaults to `nil` but `onLeatherBackSuccess delegate method` will return a reference that can be used for verifying transaction/payment

if `isProducEnv` is set to true, it you are to pass the production key while if it is set false, you are to pass the test keys

if `channels` is set to nil, the checkout will return all payment collection options

```swift
amount: Double // required
currencyCode: Currency // required
key: String // required
showPersonalInformation: Bool // required
isProducEnv: Bool // required
channels:[PaymentChannels] // optional
reference: String // optional
customerEmail: String // optional
customerName: String // optional
```

## License

LAAS is available under the MIT license. See the LICENSE file for more info.
