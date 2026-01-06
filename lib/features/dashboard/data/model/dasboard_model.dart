// features/dashboard/data/model/dashboard_model.dart

class DashboardModel {
  final String userName;        
  final String greetingText;    
  final int totalPanenTahunIni; 

  final LahanStatistikModel potensiLahan; // Card 1
  final LahanStatistikModel lahanTanam;   // Card 2
  final LahanStatistikModel lahanPanen;   // Card 3
  
  final List<HarvestChartModel> chartData;

  DashboardModel({
    required this.userName,
    required this.greetingText,
    required this.totalPanenTahunIni,
    required this.potensiLahan,
    required this.lahanTanam,
    required this.lahanPanen,
    required this.chartData,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      userName: json['user_name'] ?? 'User',
      greetingText: json['greeting_text'] ?? '',
      totalPanenTahunIni: json['total_panen_year'] ?? 0,
      
      potensiLahan: LahanStatistikModel.fromJson(json['potensi_lahan'] ?? {}),
      lahanTanam: LahanStatistikModel.fromJson(json['lahan_tanam'] ?? {}),
      lahanPanen: LahanStatistikModel.fromJson(json['lahan_panen'] ?? {}),
      
      chartData: (json['chart_data'] as List? ?? [])
          .map((item) => HarvestChartModel.fromJson(item))
          .toList(),
    );
  }
}

class LahanStatistikModel {
  final double totalLuas;  
  final double produktif;
  final double perhutanan;
  final double luasBakuSawah; 
  final double pesantren;
  final double percentage;   

  LahanStatistikModel({
    required this.totalLuas,
    required this.produktif,
    required this.perhutanan,
    required this.luasBakuSawah,
    required this.pesantren,
    required this.percentage,
  });

  factory LahanStatistikModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return LahanStatistikModel(
      totalLuas: toDouble(json['total_luas']),
      produktif: toDouble(json['produktif']),
      perhutanan: toDouble(json['perhutanan']),
      luasBakuSawah: toDouble(json['lbs']),
      pesantren: toDouble(json['pesantren']),
      percentage: toDouble(json['percentage']),
    );
  }
}

class HarvestChartModel {
  final String month; 
  final double value; 

  HarvestChartModel({required this.month, required this.value});

  factory HarvestChartModel.fromJson(Map<String, dynamic> json) {
    return HarvestChartModel(
      month: json['month'] ?? '',
      value: (json['value'] is int) 
          ? (json['value'] as int).toDouble() 
          : double.tryParse(json['value'].toString()) ?? 0.0,
    );
  }
}