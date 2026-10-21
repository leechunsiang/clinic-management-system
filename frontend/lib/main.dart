import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ClinicApp());
}

class ClinicApp extends StatelessWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PatientPage(),
    );
  }
}

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  // Update this URL based on what your .NET backend outputs when running (e.g., localhost port)
  final String apiUrl = "https://localhost:5001/api/patients"; 

  List<dynamic> patients = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ailmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          patients = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching patients: $e");
    }
  }

  Future<void> addPatient() async {
    if (nameController.text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": nameController.text,
          "phone": phoneController.text,
          "ailment": ailmentController.text,
        }),
      );

      if (response.statusCode == 201) {
        nameController.clear();
        phoneController.clear();
        ailmentController.clear();
        fetchPatients(); // Refresh list
      }
    } catch (e) {
      debugPrint("Error adding patient: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinic Management System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Add Patient Form
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Register New Patient', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Patient Name')),
                      TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
                      TextField(controller: ailmentController, decoration: const InputDecoration(labelText: 'Ailment / Symptoms')),
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: addPatient, child: const Text('Save Patient')),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Right Column: Patient List
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return ListTile(
                              title: Text(patient['name'] ?? ''),
                              subtitle: Text("Phone: ${patient['phone']} | Ailment: ${patient['ailment']}"),
                              leading: const Icon(Icons.person),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
