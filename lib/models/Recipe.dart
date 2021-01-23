import 'package:cookit/models/IngridientCounts.dart';

class Recipe {
  String id;
  String title;
  String about;
  String photo;
  String videoLink;
  List<double> rating;
  List<IngridientCounts> ingridientCounts;
  List<dynamic> steps;
  String category;
  double kcal;

  Recipe(
      {this.id,
      this.title,
      this.about,
      this.photo,
      this.videoLink,
      this.rating,
      this.ingridientCounts,
      this.steps,
      this.category});
}
