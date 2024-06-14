import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ulimagym/configs/constants.dart';
import 'package:ulimagym/models/entities/Exercise.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/entities/BodyPart.dart';
import 'exercise_controller.dart';

class ExercisePage extends StatelessWidget {
  ExerciseController control = Get.put(ExerciseController());

  void _showBottomSheet(BuildContext context, Exercise exercise) {
    print("https://www.youtube.com/embed/${exercise.videoUrl.split('?v=')[1]}");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text(
                  exercise.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(exercise.description),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: WebView(
                    initialUrl:
                        'https://www.youtube.com/embed/${exercise.videoUrl.split('?v=')[1]}',
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _exerciseGrid(BuildContext context) {
    return Expanded(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0),
                itemCount: control.exercises.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        // print("exercise id: ${this.control.exercises.value[index].id}");
                        _showBottomSheet(
                            context, this.control.exercises.value[index]);
                      },
                      child: GridTile(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                              child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                    "${BASE_URL}${this.control.exercises.value[index].imageUrl}",
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                this.control.exercises.value[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12, // Tamaño de fuente deseado
                                ),
                              )
                            ],
                          )),
                        ),
                      ));
                }))));
  }

  Widget _selectBodyPart(BuildContext context, double screenWith) {
    return Obx(() => SizedBox(
          width: screenWith - 70,
          child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Partes del cuerpo',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<BodyPart>(
                isDense: true,
                isExpanded: true,
                value: null,
                onChanged: (BodyPart? bodyPart) {
                  control.bodyPartSelected(context, bodyPart!);
                },
                items: [
                  DropdownMenuItem<BodyPart>(
                      value: null,
                      child: Text(control.bodyPartSelectedText.value,
                          style: TextStyle(color: Colors.black))),
                  ...control.bodyParts.value
                      .map<DropdownMenuItem<BodyPart>>((BodyPart item) {
                    return DropdownMenuItem<BodyPart>(
                        value: item, child: Text(item.name));
                  }).toList(),
                ],
              ))),
        ));
  }

  Widget _resetButton(BuildContext context) {
    return Container(
        width: 40,
        child: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            control.resetBodyPartSeleccion();
          },
        ));
  }

  Widget _buildBody(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.all(12.0), // Ajusta el valor según sea necesario
            child: Row(children: [
              _selectBodyPart(context, screenWidth),
              _resetButton(context)
            ]),
          ),
          _exerciseGrid(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    control.fetchBodyParts();
    control.fetchExercises();

    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: _buildBody(context),
    ));
  }
}
