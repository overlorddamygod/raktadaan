import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

call(number) async {
  final url = 'tel:$number';
  try {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: "Error",
        message: "Something went wrong",
        duration: Duration(seconds: 2),
      ));
    }
  } catch (err) {
    Get.showSnackbar(const GetSnackBar(
      title: "Error",
      message: "Something went wrong",
      duration: Duration(seconds: 2),
    ));
  }
}
