import 'package:flutter/material.dart';

class ShartnomaDetailsScreen extends StatelessWidget {
  final Function(Map<String, String>) onSave;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'Maxsulot Nomi': TextEditingController(),
    'F.I.SH': TextEditingController(),
    'Shartnoma muddati': TextEditingController(),
    'Maxsulot narxi': TextEditingController(),
    'Oylik to\'lov': TextEditingController(),
    'Telefon raqami': TextEditingController(),
    'Qolgan qarzdorlik': TextEditingController(),
    'To\'lov Sanasi': TextEditingController(),
  };

  final List<String> _months = [
    '1 oy',
    '2 oy',
    '3 oy',
    '4 oy',
    '5 oy',
    '6 oy',
    '7 oy',
    '8 oy',
    '9 oy',
    '10 oy',
    '11 oy',
    '12 oy',
  ];

  ShartnomaDetailsScreen(
      {required this.onSave, required Map<String, String> shartnoma}) {
    // Shartnoma ma'lumotlarini olib, mavjud bo'lgan shartnomani yuqoridagi TextEditingController'larga yozamiz
    _controllers.forEach((key, controller) {
      if (shartnoma.containsKey(key)) {
        controller.text = shartnoma[key]!;
      }
    });

    // Shartnoma imzolangan vaqtini avtomatik qo'shamiz
    _controllers['To\'lov Sanasi']!.text = DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shartnoma tafsilotlari'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ..._controllers.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: key == 'Shartnoma muddati'
                      ? DropdownButtonFormField<String>(
                          value: _controllers[key]!.text.isNotEmpty
                              ? _controllers[key]!.text
                              : null,
                          onChanged: (value) {
                            _controllers[key]!.text = value!;
                          },
                          items: _months.map((month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          decoration: InputDecoration(labelText: key),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Maydonni tanlash kerak';
                            }
                            return null;
                          },
                        )
                      : TextFormField(
                          readOnly: key == "To\'lov Sanasi" ? true : false,
                          controller: _controllers[key],
                          decoration: InputDecoration(labelText: key),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Maydonni to\'ldirish kerak';
                            }
                            return null;
                          },
                          keyboardType: key == 'Maxsulot narxi' ||
                                  key == 'Oylik to\'lov' ||
                                  key == 'Telefon raqami' ||
                                  key == 'Qolgan qarzdorlik'
                              ? TextInputType.numberWithOptions(decimal: true)
                              : TextInputType.text,
                        ),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final data = _controllers.map((key, controller) {
                      return MapEntry(key, controller.text);
                    });
                    onSave(data);
                    Navigator.pop(context);
                  }
                },
                child: Text('Saqlash'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
