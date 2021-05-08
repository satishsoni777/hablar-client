class Endpoints {
  static const String addAddress = "/cards/address/add";
  static const String editAddress = "/cards/address/edit/";
  static const String selectAddress = "/cards/address/select/";
  static const String initiate = "/cards/initiate";
  static const String activateCard = "/cards/activate";
  static const String changeCardPin = "/cards/activate?pinSet=true";
  static const String customerData =
      '/cards/customer-data?sections=customerInfo,cardInfo,addresses,transactions,priceGrids';
  static const String getVirtualCard = "/cards/image";
  static const String cardControl = '/cards/config';
  static const String blockCard = "/cards/block?";
  static const String getLoanPlans = "/cards/plans/loan/";
  static const String evaluateLoan = "/cards/evaluate/loan/";
  static const String convertToLoan = "/cards/convert/loan/";
  static const String getTxnDetails = "/cards/transaction/details/";
}
