import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:payment/bloc/blocs/user_bloc_provider.dart';
import 'package:payment/bloc/resources/injection.dart';
//import 'package:todolist/models/global.dart';

class AddSubtask extends StatefulWidget {


  @override
  _AddSubtaskState createState() => _AddSubtaskState();
}

class _AddSubtaskState extends State<AddSubtask> {
  TextEditingController controller = new TextEditingController();
  FocusNode textfieldFocus = new FocusNode();
  late double unitHeightValue,
      unitWidthValue,
      height,
      defaultWidth,
      focusWidth,
      marginH;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    unitHeightValue = size.height * 0.001;
    unitWidthValue = size.width * 0.001;
    focusWidth = unitWidthValue * 900;
    defaultWidth = unitWidthValue * 500;
    height = unitHeightValue * 60;
    double width = (textfieldFocus.hasPrimaryFocus) ? focusWidth : defaultWidth;
    marginH = (size.width - width) / 2;
    return Consumer<ScreenHeight>(builder: (context, _res, child) {
      return Positioned(
        bottom: 0,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: marginH, vertical: 25 * unitHeightValue),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                offset: Offset(0, 12),
              ),
            ],
          ),
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              vertical: 12.0 * unitHeightValue,
              horizontal: 20.0 * unitWidthValue),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  focusNode: textfieldFocus,
                  controller: controller,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  style: TextStyle(fontSize: 16 * unitHeightValue),
                  onTap: () {
                    setState(() {});
                  },
                  onSubmitted: (_) {
                    setState(() {
                      addSubtask();
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: textfieldFocus.hasPrimaryFocus
                        ? IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0 * unitWidthValue),
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                addSubtask();
                              });
                            })
                        : SizedBox.shrink(),
                    border: InputBorder.none,
                    hintText: "Add Subtask",
                    hintStyle: TextStyle(
                        color: Colors.black54, fontSize: 16 * unitHeightValue),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> addSubtask() async {
    if (controller.text.isNotEmpty) {
      String title = controller.text;
      controller.clear();
      textfieldFocus.unfocus();
      await locator<SubtaskBloc>().addSubtask(title);
    }
  }
}
