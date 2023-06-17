import 'package:hive_flutter/adapters.dart';

import '../../../model/pcm/mobile_dashboard_dto.dart';
import '../../db_model_hive/dashboard/mobile_dashboard.model.dart';

const String _mobileDashboardBox = 'mobileDashboardBox';

class DashboardRepository {
  DashboardRepository._constructor();

  static final DashboardRepository _instance =
      DashboardRepository._constructor();

  factory DashboardRepository() => _instance;

  late Box<MobileDashboardModel> _mobileDashboardsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<MobileDashboardModel>(MobileDashboardModelAdapter());
    _mobileDashboardsBox =
        await Hive.openBox<MobileDashboardModel>(_mobileDashboardBox);
  }

  Future<void> saveMobileDashboard(
      MobileDashboardDto mobileDashboardDto, int id) async {
    await _mobileDashboardsBox.put(
        id,
        (MobileDashboardModel(
            newPropationOfficerInbox:
                mobileDashboardDto.newPropationOfficerInbox,
            newWorklist: mobileDashboardDto.newWorklist,
            reAssignedCases: mobileDashboardDto.reAssignedCases)));
  }

  Future<void> deleteMobileDashboard(int id) async {
    await _mobileDashboardsBox.delete(id);
  }

  Future<void> deleteAllMobileDashboards() async {
    await _mobileDashboardsBox.clear();
  }

  MobileDashboardDto getMobileDashboard() {
    return _mobileDashboardsBox.values.map(_dashboardFromDb).single;
  }

  List<MobileDashboardDto> getAllMobileDashboards() {
    return _mobileDashboardsBox.values.map(_dashboardFromDb).toList();
  }

  MobileDashboardDto? getMobileDashboardById(int id) {
    final bookDb = _mobileDashboardsBox.get(id);
    if (bookDb != null) {
      return _dashboardFromDb(bookDb);
    }
    return null;
  }

  MobileDashboardDto _dashboardFromDb(
          MobileDashboardModel mobileDashboardModel) =>
      MobileDashboardDto(
          newPropationOfficerInbox:
              mobileDashboardModel.newPropationOfficerInbox,
          newWorklist: mobileDashboardModel.newWorklist,
          reAssignedCases: mobileDashboardModel.reAssignedCases);
}
