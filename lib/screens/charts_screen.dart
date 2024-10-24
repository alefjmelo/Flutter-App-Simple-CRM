import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartScreen {
  final int currentYear = DateTime.now().year;
  final List<String> _yearOptions;

  ChartScreen() : _yearOptions = _generateYearOptions();

  static List<String> _generateYearOptions() {
    int currentYear = DateTime.now().year;
    return List.generate(
        currentYear - 2023 + 1, (index) => (2023 + index).toString());
  }
}

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _selectedChart = 'Vendas';
  String _selectedPeriod = 'Semana';
  String _selectedPeriodItem = '1ª Semana';
  final int currentYear = DateTime.now().year;
  static const _chartOptions = ['Vendas', 'Receitas'];
  static const _periodOptions = ['Semana', 'Mês', 'Ano'];

  final List<String> _weekOptions = [
    '1ª Semana',
    '2ª Semana',
    '3ª Semana',
    '4ª Semana'
  ];

  final List<String> _monthOptions = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  List<String> get _currentPeriodItems {
    switch (_selectedPeriod) {
      case 'Semana':
        return _weekOptions;
      case 'Mês':
        return _monthOptions;
      case 'Ano':
        return ChartScreen()._yearOptions;
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedPeriodItem = _currentPeriodItems.first; // Initialize correctly
  }

  List<BarChartGroupData> _generateBarChartData() {
    return [
      BarChartGroupData(
          x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.yellow)]),
      BarChartGroupData(
          x: 1, barRods: [BarChartRodData(toY: 6, color: Colors.yellow)]),
      BarChartGroupData(
          x: 2, barRods: [BarChartRodData(toY: 8, color: Colors.yellow)]),
      BarChartGroupData(
          x: 3, barRods: [BarChartRodData(toY: 7, color: Colors.yellow)]),
      BarChartGroupData(
          x: 4, barRods: [BarChartRodData(toY: 10, color: Colors.yellow)]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.grey[800],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSelectPeriodRange(),
                const SizedBox(height: 10),
                _buildChartTypeSelector(),
                const SizedBox(height: 10),
                _buildChart(_selectedChart),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectPeriodRange() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Selecionar $_selectedPeriod: ',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        DropdownButton<String>(
          value: _selectedPeriodItem,
          dropdownColor: Colors.grey[700],
          items: _currentPeriodItems.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPeriodItem = newValue!;
            });
          },
          borderRadius: BorderRadius.circular(8),
          menuMaxHeight: 150,
        ),
      ],
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.grey[700]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Relatórios',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            _buildPeriodSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._periodOptions.map((period) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 40),
                backgroundColor: _selectedPeriod == period
                    ? Colors.yellow[700]
                    : Colors.yellow[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => setState(() {
                _selectedPeriod = period;
                _selectedPeriodItem = _currentPeriodItems.first;
              }),
              child: Text(
                period,
                style: TextStyle(
                  color:
                      _selectedPeriod == period ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Icon(Icons.more_horiz, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildChartTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          _chartOptions.map((option) => _buildChartTypeButton(option)).toList(),
    );
  }

  Widget _buildChartTypeButton(String label) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedChart = label),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(180, 40),
        backgroundColor:
            _selectedChart == label ? Colors.grey[600] : Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildChart(String chartLabel) {
    const titleStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chartLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Período: $_selectedPeriod',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _generateBarChartData(),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4.0,
                              child: Text(
                                value.toInt().toString(),
                                style: titleStyle,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            Widget text;
                            switch (value.toInt()) {
                              case 0:
                                text = const Text('Seg', style: titleStyle);
                                break;
                              case 1:
                                text = const Text('Ter', style: titleStyle);
                                break;
                              case 2:
                                text = const Text('Qua', style: titleStyle);
                                break;
                              case 3:
                                text = const Text('Qui', style: titleStyle);
                                break;
                              case 4:
                                text = const Text('Sex', style: titleStyle);
                                break;
                              default:
                                text = const Text('', style: titleStyle);
                                break;
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4.0,
                              child: text,
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total de $chartLabel ($_selectedPeriod): ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'R\$ 0,00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
