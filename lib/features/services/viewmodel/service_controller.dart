import 'package:get/get.dart';
import '../model/service_model.dart';
import '../repository/service_repository.dart';

class ServiceController extends GetxController {
  final ServiceRepository _repository = ServiceRepository();

  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedServices = await _repository.fetchServices();
      services.assignAll(fetchedServices);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
