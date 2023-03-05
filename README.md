# Stripe card payment with custom Ui in flutter

[![stripe](https://github.com/rp3110/stripe-payment-with-customiui/blob/main/screenshot/stripe_logo.png "stripe")

With the use of ***[flutter_stripe](https://pub.dev/packages/flutter_stripe)*** we can easily implement ***Stripe Payment***  with the default UI. But what if we want to use it in a different style? So, in this flutter app, I have implemented Stripe with a custom UI.

- Flutter App
- Using Bloc
- Stripe payments
- Custom Ui
- WebViewX


# Features
- Stripe payment gateway with custom ui.
- Save cards for future payment.
- Payment without saving cards.


# Setup stripe account
1. Login on [Stripe](https://stripe.com/in"Stripe").
2. Open Dashboard.
3. Enable test mode.
4. Here you can find the ***secret_key*** and ***publishable_key***.


# Let's Code
- Add these dependencies in **pubspec.yaml** and hit **Pub Get**

|     dependencies      |
|-----------------------|
|     flutter_bloc      |
|       equatable       |
|         http          |
|       provider        |
|         intl          |
|  shared_preferences   |
|       webviewx        |

- Setup Bloc for api calls as per the code.
- ***Important!!!!***  You have to replace ***Authorization*** field with your secret key in ```getHeaderValue()``` located in **api_provider.dart**.
    ```
    Future<Map<String, String>> getHeaderValue() async {
        Map<String, String> header = {
            'Content-Type': 'application/x-www-form-urlencoded',
            "Authorization": "Bearer  ***Your secret Key***",
        };
        return header;
    }
    ```
  
- Next, we need to create a customer before we can add and save cards. In order to create a customer, I made an API call after clicking **Continue**. If the user opens the application for the first time and saves it to the shared preferences, it will be called (in this case, I used a separate preference helper.dart class for the shared preferences). For storing customer ID, you are free to choose your own method.
- The *Add a new card* button is used to add a card on the following screen. After filling out the information, two apis are called in this screen.
  1. for producing tokens
  2. for using the customer id and token to add the card to an existing customer
- To get the list of saved cards, I called an api in the **initState** from the saved cards screen.
- If the card is a **3DS**, the dialogue will pop-up for the verification in the **initState** of the payment screen to confirm the **Payment Intent**.
- The user will be directed to the next screen after verifying the payment intent. The current payment status will be displayed after the payment status has been verified.

> use card number **4242 4242 4242 4242** for a successful payment.
> use these [Cards](https://stripe.com/docs/testing?testing-method=card-numbers#declined-payments"Cardss") for testing declined payment.

# References
- [Stripe Docs](https://stripe.com/docs"StripeDocs")
- [Flutter Credit Card Input Form](https://itnext.io/flutter-credit-card-input-form-1a1e0b1ec040"CreditCard")

# Creator
- [Rutu Hirapara](https://github.com/rp3110"Rutu")

# Demo

[![Image](https://bitbucket.org/rutu31/stripe_payment_with_custom_ui/raw/23fc0b79acf2c3987d3e592d4934b0ce07ddcb65/screenshot/app_demo.png "Image")](https://bitbucket.org/rutu31/stripe_payment_with_custom_ui/raw/23fc0b79acf2c3987d3e592d4934b0ce07ddcb65/screenshot/app_demo.png "Image")
[![image2](https://bitbucket.org/rutu31/stripe_payment_with_custom_ui/raw/23fc0b79acf2c3987d3e592d4934b0ce07ddcb65/screenshot/stripe_payment.png "image2")](https://bitbucket.org/rutu31/stripe_payment_with_custom_ui/raw/23fc0b79acf2c3987d3e592d4934b0ce07ddcb65/screenshot/stripe_payment.png "image2")