class DateFunctions {
  String currentData() {
    DateTime now = DateTime.now();
    String diaDaSemana = _getDiaDaSemana(now.weekday);
    String formattedDate =
        "$diaDaSemana, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(4, '0')}";
    return formattedDate;
  }

  String _getDiaDaSemana(int dayNumber) {
  List<String> weekDays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];
  return weekDays[dayNumber - 1];
}

}
