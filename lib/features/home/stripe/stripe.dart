import 'package:flutter/material.dart';
import 'package:scanner/features/home/providers/document_provider.dart';
import 'package:scanner/features/home/providers/scanning_user_provider.dart';
import 'package:scanner/features/home/stripe/api_services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:scanner/features/widgets/snack_bar.dart';

Future<void> init({
  required String name,
  required String email,
  required BuildContext context,
}) async {
  // create customer
  Map<String, dynamic>? customer = await createCustomer(
    name: name,
    email: email,
  );

  if (customer == null || customer["id"] == null) {
    throw Exception("Fail to create customer");
  }

  // create payment intent
  Map<String, dynamic>? paymentIntent = await createPaymentIntent(
    customerId: customer["id"],
  );

  if (paymentIntent == null || paymentIntent["client_secret"] == null) {
    throw Exception("Fail to create payment intent");
  }

  // create credit card
  await creditCard(
    customerId: customer["id"],
    clientSecret: paymentIntent["client_secret"],
  );

  // retrieve customer payment method
  Map<String, dynamic>? customerPaymentMethods = await fetchCardDetails(
    customerId: customer["id"],
  );

  if (customerPaymentMethods == null) {
    throw Exception("Fail to fetch customer payment methods");
  }

  //  create subscription
  Map<String, dynamic>? subscription = await createSubscription(
    customerId: customer["id"],
    paymentId: customerPaymentMethods["data"][0]["id"],
  );

  if (subscription == null || subscription["id"] == null) {
    throw Exception("Fail to create subscription");
  } else {
    // successfully subscribed
    await ScanningUserProvider().updateUserPlan("pro");
    DocumentProvider().notify();
    if (context.mounted) {
      CustomSnackBar.showSuccess(context, "Active subscription");
    }
  }
}

Future<Map<String, dynamic>?> createCustomer({
  required String name,
  required String email,
}) async {
  final customersCreationResponse = await stripeApiServices(
    requestMethod: ApiServicesMethodType.post,
    requestBody: {
      "name": name,
      "email": email,
      "description": "Doc scanner Premium plan",
    },
    endpoint: "customers",
  );
  return customersCreationResponse;
}

Future<Map<String, dynamic>?> createPaymentIntent({
  required String customerId,
}) async {
  final paymentIntentsCreationResponse = await stripeApiServices(
    requestMethod: ApiServicesMethodType.post,
    requestBody: {
      "customer": customerId,
      'automatic_payment_methods[enabled]': 'true',
    },
    endpoint: "setup_intents",
  );
  return paymentIntentsCreationResponse;
}

Future<void> creditCard({
  required String customerId,
  required String clientSecret,
}) async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      primaryButtonLabel: "Subscribe \$4.99/month",
      style: ThemeMode.dark,
      merchantDisplayName: 'Doc Scanner',
      customerId: customerId,
      setupIntentClientSecret: clientSecret,
    ),
  );

  await Stripe.instance.presentPaymentSheet();
}

// fetch user entered card details
Future<Map<String, dynamic>?> fetchCardDetails({
  required String customerId,
}) async {
  final customerPaymentMethodsResponse = await stripeApiServices(
    requestMethod: ApiServicesMethodType.get,
    endpoint: 'customers/$customerId/payment_methods',
  );

  return customerPaymentMethodsResponse;
}

Future<Map<String, dynamic>?> createSubscription({
  required String customerId,
  required String paymentId,
}) async {
  final subscriptionsCreationResponse = await stripeApiServices(
    requestMethod: ApiServicesMethodType.post,
    requestBody: {
      "customer": customerId,
      'items[0][price]': "price_1QdS6WLJiqbazoHkxLxbdAHi",
      'default_payment_method': paymentId,
    },
    endpoint: "subscriptions",
  );

  return subscriptionsCreationResponse;
}
