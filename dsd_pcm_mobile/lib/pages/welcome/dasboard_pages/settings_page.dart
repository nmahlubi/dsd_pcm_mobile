import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  /*
  final LinkedDeviceService linkedDeviceServiceClient = LinkedDeviceService();
  late ApiResponse apiResponse = ApiResponse();
  late List<LinkedDeviceDto> linkedDeviceDto = [];
  */

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        //loadUserDevices();
      });
    });
  }

  /*
  loadUserDevices() async {
    final overlay = LoadingOverlay.of(context);
    final messageDialog = ScaffoldMessenger.of(context);
    overlay.show();

    apiResponse = await linkedDeviceServiceClient
        .getLinkedDevicesByUserId(Prefs.getInt('userId')!.toString());

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        linkedDeviceDto = (apiResponse.Data as List<LinkedDeviceDto>);
      });
    } else {
      overlay.hide();
      messageDialog.showSnackBar(
        SnackBar(
            content: Text((apiResponse.ApiError as ApiError).error!),
            backgroundColor: Colors.red),
      );
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        const Text('My Devices', textAlign: TextAlign.center)),
              )
            ],
          ),
          /*Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: linkedDeviceDto.length,
              itemBuilder: (context, int index) {
                if (linkedDeviceDto.isEmpty) {
                  return const Center(child: Text('No device Found.'));
                }
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 194, 191, 199),
                    child: Text(''),
                  ),
                  title: Text(linkedDeviceDto[index].name.toString()),
                  subtitle: Text(linkedDeviceDto[index].dateCreated.toString(),
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.favorite)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(thickness: 1);
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
