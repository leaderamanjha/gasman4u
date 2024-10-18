class Endpoints {
  //send , login , register , getProfile , update profile
  static const String sendOtp = "/auth/send-otp";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String getProfile = '/get-profile';
  static const String updateProfile = '/update-profile';

  // home , fetch category , fetch product
  static const String getHome = '/get-home';
  static const String getCategory = '/get-category';
  static const String getProductByCategory = '/category';
  static const String getProductByProductId = '/product';

  //cart fetch , add , update , remove , empty
  static const String getCart = '/get-cart';
  static const String addToCart = '/add-to-cart';
  static const String updateItem = '/update-item';
  static const String removeItem = '/remove-item';
  static const String emptyCart = '/empty-cart';

  // Address Fetch , Add , delete
  static const String getAddress = '/get-address';
  static const String addAddress = '/add-address';
  static const String deleteAddress = '/delete-address';

  //place order , update order , get order , get order by order id , cancel order by orderId
  static const String placeOrder = '/place-order';
  static const String updateOrderPaymemt = '/update-order-payment';
  static const String getOrders = '/get-orders';
  static const String getOrderByOrderId = '/order';
  static const String cancelOrderByOrderId = '/cancel-order';

  // Get wallet , Add money to wallet ,
  static const String getWallet = '/get-wallet';
  static const String addMoneyToWallet = '/add-money-to-wallet';
}
