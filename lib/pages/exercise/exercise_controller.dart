import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulimagym/services/body_part_service.dart';
import '../../models/entities/Exercise.dart';
import '../../models/entities/BodyPart.dart';
import '../../services/exercise_service.dart';

class ExerciseController extends GetxController {
  RxList<BodyPart> bodyParts = <BodyPart>[].obs;
  RxString bodyPartSelectedText = "Seleccione una parte del cuerpo".obs;
  RxList<Exercise> exercises = <Exercise>[].obs;
  List<Exercise> exercisesOriginal = <Exercise>[];
  BodyPartService bodyPartService = BodyPartService();
  ExerciseService exerciseService = ExerciseService();

  ExerciseController() {}

  void fetchBodyParts() async {
    List<BodyPart>? bodyParts = await bodyPartService.fetchAll();
    if (bodyParts == null) {
      print('Hubo un error en traer los datos del servidor');
    } else if (bodyParts.isEmpty) {
      print('No hay datos en la respuesta');
    } else {
      this.bodyParts.value = bodyParts;
    }
  }

  void fetchExercises() async {
    List<Exercise>? exercises = await exerciseService.fetchAll(null);
    if (exercises == null) {
      print('Hubo un error en traer los datos del servidor');
    } else if (exercises.isEmpty) {
      print('No hay datos en la respuesta');
    } else {
      this.exercises.value = exercises;
      if (this.exercisesOriginal.isEmpty) {
        this.exercisesOriginal = exercises;
      }
    }
  }

  void bodyPartSelected(BuildContext context, BodyPart selectedBodyPart) async {
    this.bodyPartSelectedText.value = selectedBodyPart.name;
    this.exercises.clear();
    List<Exercise>? exercises =
        await exerciseService.fetchAll(selectedBodyPart.id);
    if (exercises == null) {
      print('Hubo un error en traer los datos del servidor');
    } else if (exercises.isEmpty) {
      print('No hay datos en la respuesta');
    } else {
      this.exercises.value = exercises;
    }
  }

  void resetBodyPartSeleccion() {
    this.exercises.clear();
    this.fetchExercises();
    this.bodyPartSelectedText.value = "Seleccione una parte del cuerpo";
  }
}
