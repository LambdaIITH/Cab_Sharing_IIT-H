import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPosting extends StatefulWidget {
  const NewPosting({super.key});

  @override
  State<NewPosting> createState() => _NewPostingState();
}

const List<String> locations = ['IITH', 'RGIA', 'Lingampally', 'Miyapur'];

class _NewPostingState extends State<NewPosting> {
  final _formKey = GlobalKey<FormState>();
  String source = locations[0];
  String destination = locations[1];
  DateTime datetime = DateTime.now();
  int seats = 4;

  String _getDateString() {
    const List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[datetime.weekday-1]}, ${datetime.day} ${months[datetime.month-1]} ${datetime.year}';
  }

  String _getTimeString() {
    if (datetime.minute < 10) {
      return '${datetime.hour}:0${datetime.minute}';
    } else {
      return '${datetime.hour}:${datetime.minute}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Posting'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'From',
                    border: OutlineInputBorder(),
                  ),
                  value: source,
                  items: locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      source = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  value: destination,
                  items: locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == source) {
                      return 'To and From cannot be the same location';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      destination = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Number of passengers',
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  initialValue: seats.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (String? value) {
                    if (value == '') {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      if (value != '') {
                        seats = int.parse(value);
                      }
                    });
                  },
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: const Text('Date:'),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: datetime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              datetime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                datetime.hour,
                                datetime.minute,
                              );
                            });
                          }
                        },
                        child: Text(_getDateString()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: const Text('Time:'),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(datetime),
                          );
                          if (picked != null) {
                            setState(() {
                              datetime = DateTime(
                                datetime.year,
                                datetime.month,
                                datetime.day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          }
                        },
                        child: Text(_getTimeString()),
                      ),
                    ),
                  ]
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Now we need a backend to post to'), duration: Duration(seconds: 2)),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Submit'),
                  ),
                ),
              ].map((Widget child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: child,
                );
              }).toList(),
              // submit button
            )
          )
        )
      )
    );
  }
}
