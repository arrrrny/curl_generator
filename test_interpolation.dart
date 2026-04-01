import 'dart:convert';

void main() {
  final bodyMap = {"customer": {"tags": []}, "key": "value"};
  final jsonString = jsonEncode(bodyMap);
  
  print('JSON string value:');
  print(jsonString);
  print('');
  
  print('String interpolation in single quotes:');
  final result1 = '  --data-raw \'$jsonString\' \\';
  print(result1);
  print('');
  
  print('What we actually want:');
  print('  --data-raw \'{"customer":{"tags":[]},"key":"value"}\' \\');
}
