import 'package:flutter/material.dart';
import 'package:payment/ui/todo/title_card.dart';
import 'package:payment/widgets/global_widgets/background_color_container.dart';
import 'package:payment/widgets/group_widgets/group_list_widget.dart';

class ListGroupsTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double height = mediaQuery.height * 0.17;
    return Stack(children: [
      BackgroundColorContainer(
        startColor: Colors.white,
        endColor: Colors.white,
        widget: TitleCard(
            title: "Groups",
            child: GroupList(top: height)),
      )
    ]);
  }
}
