import 'package:get/get.dart';
import 'package:gasman4u/data/api_services/wallet_api_services.dart';
import 'package:gasman4u/data/models/wallet/wallet_model.dart';
import 'package:gasman4u/data/models/wallet/wallet_history_model.dart';

class WalletController extends GetxController {
  final WalletApiServices _apiServices = WalletApiServices();
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxList<WalletHistoryModel> walletHistory = <WalletHistoryModel>[].obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxString inputAmount = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      final walletData = await _apiServices.getWallet();
      wallet.value = walletData;
      walletBalance.value = walletData.walletBalance?.toDouble() ?? 0.0;
      walletHistory.assignAll(walletData.walletHistory ?? []);
    } catch (e) {
      print('Error fetching wallet data: $e');
    }
  }

  Future<void> addMoneyToWallet() async {
    if (inputAmount.value.isEmpty) return;

    final amount = double.tryParse(inputAmount.value);
    if (amount == null || amount <= 0) return;

    try {
      await _apiServices.addMoneyToWallet(
          amount, 'TRANS${DateTime.now().millisecondsSinceEpoch}');
      await fetchWalletData();
      inputAmount.value = '';
    } catch (e) {
      print('Error adding money to wallet: $e');
    }
  }

  void updateInputAmount(String value) {
    inputAmount.value = value;
  }

  void selectSuggestedAmount(double amount) {
    inputAmount.value = amount.toString();
  }
}
