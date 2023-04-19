import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/victim_organisation_detail_dto.dart';

class ViewVictimOrganisationDetailPage extends StatelessWidget {
  final VictimOrganisationDetailDto? victimOrganisationDetailDto;
  final List<VictimOrganisationDetailDto>? victimOrganisationDetailsDto;
  const ViewVictimOrganisationDetailPage(
      {super.key,
      this.victimOrganisationDetailsDto,
      this.victimOrganisationDetailDto});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
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
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Veiw All Victim Organisations",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                collapsed: const Text(
                  '',
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (victimOrganisationDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: victimOrganisationDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (victimOrganisationDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No Victim Organisation Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Name : ${victimOrganisationDetailsDto![index].organisationName}'),
                                    subtitle: Text(
                                        'Contact Person : ${victimOrganisationDetailsDto![index].contactPersonFirstName} ${victimOrganisationDetailsDto![index].contactPersonLastName}.'
                                        'Address : ${victimOrganisationDetailsDto![index].addressLine1} ${victimOrganisationDetailsDto![index].addressLine2} ${victimOrganisationDetailsDto![index].postalCode}',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: const Icon(Icons.edit,
                                        color: Colors.green));
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(thickness: 1);
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
