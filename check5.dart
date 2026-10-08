import 'dart:convert';
import 'dart:io';
void main() {
  final content = File('C:\\Users\\aseer\\.gemini\\antigravity-ide\\brain\\3ac9ef95-7312-4f93-bfc7-73001456abbf\\.system_generated\\steps\\443\\content.md').readAsStringSync();
  final jsonString = '{' + content.split('---').last.substring(content.split('---').last.indexOf('{') + 1);
  final map = jsonDecode(jsonString) as Map<String, dynamic>;
  print(jsonEncode(map['components']['schemas']['CreateDirectBookingDto']));
}
