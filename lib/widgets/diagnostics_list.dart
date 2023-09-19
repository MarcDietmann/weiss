import 'package:flutter/material.dart';
import 'package:weiss_app/2022/constants.dart';

class DiagnosticsList extends StatelessWidget {
  final List? errorList;

  const DiagnosticsList({Key? key, required this.errorList,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    errorList?.sort((a, b) => b["level"].compareTo(a["level"]));
    return Container(
        child: errorList == null
            ? Center(
          child: Text(
            "No Errors received yet",
          ),
        )
            : errorList!.isEmpty
            ? Center(
          child: Text(
            "no_errors_machine_fine",
            style: TextStyle(color: Colors.green),
          ),
        )
            : Column(
          children: List.generate(errorList!.length, (int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text(errorList![index]["name"],
                    style: TextStyle(decorationColor: Colors.yellow)),
                subtitle: Text(errorList![index]["message"],
                    style: TextStyle(decorationColor: Colors.yellow)),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: errorCodeColors[errorList![index]["level"]]),
                  child: Center(
                    child: Icon([
                      Icons.check_circle,
                      Icons.warning,
                      Icons.error,
                      Icons.pause_circle,
                    ][errorList![index]["level"]],color: Colors.black,),
                  ),
                ),
                visualDensity: VisualDensity.compact,
              ),
            );
            /*
              return Container(
                  margin: EdgeInsets.all(2),
                  color: index % 2 == 0 ? Colors.blue : Colors.red,
                  child: Text(error_list[index]));

               */
          }),
        ));
  }
}
