import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Configurações',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26)),
              SizedBox(height: 20),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Notificações',
                          style: TextStyle(color: Colors.white)),
                      trailing: Switch(
                        value: true, // Replace with your state management
                        onChanged: (bool value) {
                          // Handle the switch change
                        },
                      ),
                    ),
                    ListTile(
                      title:
                          Text('Tema', style: TextStyle(color: Colors.white)),
                      trailing: DropdownButton<String>(
                        value: 'Claro', // Replace with your state management
                        onChanged: (String? newValue) {
                          // Handle the dropdown change
                        },
                        items: <String>['Claro', 'Escuro']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
