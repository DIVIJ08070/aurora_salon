import 'package:get/get.dart';
import '../model/stylist_model.dart';
import '../repository/stylist_service.dart';

class StylistController extends GetxController {
  final StylistService _service = StylistService();

  var stylists = <StylistModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStylists();
  }

  Future<void> fetchStylists() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedStylists = await _service.fetchStylists();
      stylists.assignAll(fetchedStylists);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
