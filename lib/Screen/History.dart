import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

class History extends StatelessWidget {
   History({Key? key}) : super(key: key);

   DateTime? _selected;

   Future pickDate(BuildContext context) async {
     final _selected = await showMonthYearPicker(
       context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime(2019),
       lastDate: DateTime(2024),

     );

     if (_selected != null){
       print(DateUtils.dateOnly(_selected));
       print(_selected.runtimeType);

     }
   }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(

        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text('select month'),
                  
                  GestureDetector(
                    onTap: (){
                      pickDate(context);


                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue
                      ),
                      child: Row(
                        children: [
                          Text('march 2023'),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  )
                  
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Allowance'),
                  Text('amount'),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListView.builder(itemBuilder: (BuildContext context, int index) {
              return historylist();
            },

            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
            )
          ],
        ),
      ),
    );
  }
}

class historylist extends StatelessWidget {
  const historylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (dissm){

      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.black,
          size: 10,
        ),
      ),
      child: ListTile(
        title: Text('Date'),
        subtitle: Text('Notes'),
        trailing: Text('ammount'),
      ),
    );
  }
}
