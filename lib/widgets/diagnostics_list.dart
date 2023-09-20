import 'package:flutter/material.dart';
import 'package:weiss_app/2022/constants.dart';
import 'package:weiss_app/utils/diagnostics_provider.dart';

class DiagnosticsList extends StatelessWidget {
  final List<MachineStatus>? errorList;

  const DiagnosticsList({Key? key, required this.errorList,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    errorList?.sort((MachineStatus a, MachineStatus b) => b.level.index.compareTo(a.level.index));
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
                title: Text(errorList![index].title,
                    style: TextStyle(decorationColor: Colors.yellow)),
                subtitle: Text(errorList![index].help,
                    style: TextStyle(decorationColor: Colors.yellow)),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: errorCodeColors[errorList![index].level.index]),
                  child: Center(
                    child: Icon([
                      Icons.check_circle,
                      Icons.warning,
                      Icons.error,
                      Icons.pause_circle,
                    ][errorList![index].level.index],color: Colors.black,),
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
