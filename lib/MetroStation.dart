import 'package:flutter/material.dart';

class MetroStation {
  final String name;
  final String line;
  final Color color;

  const MetroStation({
    required this.name,
    required this.line,
    required this.color,
  });
}
const List<MetroStation> allStations = [
  MetroStation(name: "Киевская", line: "Арбатско-Покровская", color: Colors.blue),
  MetroStation(name: "Киевская", line: "Кольцевая", color: Colors.brown),
  MetroStation(name: "Киевская", line: "Филёвская", color: Colors.lightBlueAccent),
  MetroStation(name: "Окружная", line: "МЦК", color: Color(0xFFB1B1B1)),
  MetroStation(name: "Окружная", line: "МЦД-1", color: Color(0xFF7D3C98)),
];
MetroStation? getStationByName(String name) {
  return allStations.firstWhere(
        (station) => station.name == name,
  );
}


