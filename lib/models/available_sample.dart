class AvailableSample {
  final String name;
  final String label;

  AvailableSample(this.name, this.label);

  factory AvailableSample.fromJson(Map<String, dynamic> json) {
    return AvailableSample(json['name'], json['label']);
  }
}

class AvailableSamplesList {
  final List<AvailableSample> samples;

  AvailableSamplesList(this.samples);

  factory AvailableSamplesList.fromJson(Map<String, dynamic> json) {
    final names = json['names'] as List;
    return AvailableSamplesList(names.map((e) => AvailableSample.fromJson(e)).toList());
  }
}