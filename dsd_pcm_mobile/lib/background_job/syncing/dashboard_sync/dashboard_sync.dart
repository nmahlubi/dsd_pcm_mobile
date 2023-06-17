import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../domain/repository/dashboard/dashboard_repository.dart';
import '../../../model/pcm/mobile_dashboard_dto.dart';
import '../../../service/pcm/mobile_dasboard_service.dart';
import '../../../util/shared/apiresponse.dart';

class DashboardSync {
  final _dashboardRepository = DashboardRepository();
  final _mobileDashboardService = MobileDashboardService();
  late ApiResponse apiResponse = ApiResponse();
  late MobileDashboardDto mobileDashboardDto = MobileDashboardDto();

  Future<void> syncDashboard(int? userId) async {
    try {
      apiResponse =
          await _mobileDashboardService.getMobileDashboardByUserOnline(userId);
      if ((apiResponse.ApiError) == null) {
        mobileDashboardDto = (apiResponse.Data as MobileDashboardDto);
        await _dashboardRepository.deleteMobileDashboard(userId!);
        await _dashboardRepository.saveMobileDashboard(
            mobileDashboardDto, userId);
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print(
            'Unable to access _mobileDashboardService.getMobileDashboardByUserOnline endpoint');
      }
    }
  }
}
