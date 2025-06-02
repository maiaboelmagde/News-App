class OnboardingModel {
  String image;
  String title;
  String desc;

  OnboardingModel({required this.image, required this.title, required this.desc});

  @override
  String toString() {
    return ' img: $image, title : $title, desc : $desc';
  }
}