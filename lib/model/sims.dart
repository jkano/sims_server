class Sims {
  final int id;
  final String serial;
  int out1;
  int out2;
  int out3;
  int out4;
  int out5;
  int out6;

  Sims({
    required this.id,
    required this.serial,
    required this.out1,
    required this.out2,
    required this.out3,
    required this.out4,
    required this.out5,
    required this.out6,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial': serial,
      'out1': out1,
      'out2': out2,
      'out3': out3,
      'out4': out4,
      'out5': out5,
      'out6': out6,
    };
  }

  Map toJson() => {
        'serial': serial,
        'out1': out1,
        'out2': out2,
        'out3': out3,
        'out4': out4,
        'out5': out5,
        'out6': out6,
      };

  @override
  String toString() {
    return 'Sims{id: $id, serial: $serial, outputs: [$out1, $out2, $out3, $out4, $out5, $out6]}';
  }
}
