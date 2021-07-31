class CategoryArea {
  int percent;
  String category;
  CategoryArea(this.percent, this.category);

  CategoryArea.fromJson(String k, int v) {
    percent = v;
    category = k;
  }
}
