import 'package:dsd_pcm_mobile/model/intake/pcm_order_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/order_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/recommendations_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/recommendation_drawer.dart';
import 'package:dsd_pcm_mobile/service/pcm/recommendations_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late RecommendationDto recommendationDto = RecommendationDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _recommendationServiceClient = RecommendationsService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<OrderDto> orderDto = [];
  late List<PcmOrderDto> pcmOrderDto = [];

  ExpandableController captureOrderPanelController = ExpandableController();
  ExpandableController viewOrdersInfoPanelController = ExpandableController();
  final TextEditingController reasonForOrderController =
      TextEditingController();

  int? orderId;
  int? orderDropdownButtonFormField;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureOrderPanelController = ExpandableController(initialExpanded: false);
    viewOrdersInfoPanelController = ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Order';
    orderId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          recommendationDto =
              ModalRoute.of(context)!.settings.arguments as RecommendationDto;
          loadLookUpTransformer();
          loadOrdersByRecommendationId(recommendationDto.recommendationId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    pcmOrderDto = await _lookupTransform.transformOrderDto();
    overlay.hide();
  }

  loadOrdersByRecommendationId(int? recommendationId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _recommendationServiceClient
        .getOrderByRecommendationId(recommendationId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        orderDto = (apiResponse.Data as List<OrderDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateOrder() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    OrderDto requestAddOrderDto = OrderDto(
      orderId: orderId ?? _randomGenerator.getRandomGeneratedNumber(),
      recommendationId: recommendationDto.recommendationId,
      recomendationOrderId: orderDropdownButtonFormField,
      pcmOrderDto: orderDropdownButtonFormField != null
          ? pcmOrderDto
              .where(
                  (o) => o.recomendationOrderId == orderDropdownButtonFormField)
              .single
          : null,
      orderReason: reasonForOrderController.text,
      createdBy: preferences!.getInt('userId')!,
      modifiedBy: preferences!.getInt('userId')!,
      dateCreated: _randomGenerator.getCurrentDateGenerated(),
    );

    apiResponse =
        await _recommendationServiceClient.addUpdateOrder(requestAddOrderDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const OrderDetailPage()),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  newOrderDetail() {
    setState(() {
      labelButtonAddUpdate = 'Add Order';
      reasonForOrderController.clear();
      orderDropdownButtonFormField = null;
      orderId = null;
    });
  }

  populateHealthDetailForm(OrderDto orderDto) {
    setState(() {
      orderId = orderDto.orderId;
      captureOrderPanelController = ExpandableController(initialExpanded: true);
      viewOrdersInfoPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Order';
      reasonForOrderController.text = orderDto.orderReason!;
      orderDropdownButtonFormField =
          orderDto.pcmOrderDto!.recomendationOrderId!;
    });
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  showSuccessMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    reasonForOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text("Order Details"),
              leading: IconButton(
                icon: const Icon(Icons.offline_pin_rounded),
                onPressed: () {
                  if (scaffoldKey.currentState!.isDrawerOpen) {
                    scaffoldKey.currentState!.closeDrawer();
                    //close drawer, if drawer is open
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                    //open drawer, if drawer is closed
                  }
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  tooltip: 'Accepted Worklist',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AcceptedWorklistPage()),
                    );
                  },
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AssessmentDetailPage(),
                            settings: RouteSettings(
                              arguments: acceptedWorklistDto,
                            ),
                          ),
                        );*/
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                  FloatingActionButton(
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EducationPage(),
                            settings: RouteSettings(
                              arguments: acceptedWorklistDto,
                            ),
                          ),
                        );*/
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ),
          drawer:
                GoToRecommendationDrawer(recommendationDto: recommendationDto),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller: captureOrderPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Order",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize: const Size
                                                            .fromHeight(10),
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                244, 248, 246),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        newOrderDetail();
                                                      },
                                                      child: const Text('New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        orderDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Order(s)',
                                                      labelText:
                                                          '-Please select-',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: pcmOrderDto
                                                        .map((pcmOders) {
                                                      return DropdownMenuItem(
                                                          value: pcmOders
                                                              .recomendationOrderId,
                                                          child: Text(pcmOders
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      orderDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Order required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      reasonForOrderController,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Reason for order',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Reason for Order Required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 10, 2),
                                            )),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                23, 22, 22),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        if (_loginFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          addUpdateOrder();
                                                        }
                                                      },
                                                      child: Text(
                                                          labelButtonAddUpdate!),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                      ]),
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller: viewOrdersInfoPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Order Details",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (orderDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: orderDto.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (orderDto.isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No order Details Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Order : ${orderDto[index].pcmOrderDto?.description}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Reason for oder : ${orderDto[index].orderReason}. ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                                                          IconButton(
                                                              onPressed: () {
                                                                populateHealthDetailForm(
                                                                    orderDto[
                                                                        index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue)),
                                                          /*IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red)),*/
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                        thickness: 1);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
                      ]),
                    ],
                  ),
                ))));
  }
}
