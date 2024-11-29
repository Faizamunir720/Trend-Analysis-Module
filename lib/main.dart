import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: TrendAnalysisModule(),
  ));
}

class TrendAnalysisModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trend Analysis Module"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionCard(
              title: "Pattern Detection",
              child: PatternDetectionCheckbox(),
            ),
            const SizedBox(height: 24),
            SectionCard(
              title: "Abandonment Insights",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cart Abandonment Reasons",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(height: 200, child: PieChartWidget()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionCard(
              title: "Impact of Shipping Costs on Abandonment",
              child: SizedBox(
                height: 200,
                child: BarChartWidget(
                  title: "Shipping Costs Impact",
                  data: [25, 40, 15],
                  colors: [Colors.blue, Colors.orange, Colors.red],
                  categories: ['Low', 'Medium', 'High'],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SectionCard(
              title: "Weekly Cart Abandonment Trends",
              child: SizedBox(
                height: 200,
                child: BarChartWidget(
                  title: "Weekly Abandonments",
                  data: [50, 70, 80, 60, 90, 120, 110],
                  colors: [
                    Colors.blue,
                    Colors.green,
                    Colors.purple,
                    Colors.orange,
                    Colors.red,
                    Colors.yellow,
                    Colors.blueAccent,
                  ],
                  categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class PatternDetectionCheckbox extends StatefulWidget {
  @override
  _PatternDetectionCheckboxState createState() =>
      _PatternDetectionCheckboxState();
}

class _PatternDetectionCheckboxState extends State<PatternDetectionCheckbox> {
  bool productPageViews = true;
  bool addToCartActions = true;
  bool viewCartButNoCheckout = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text("Product Page Views"),
          value: productPageViews,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                productPageViews = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product Page Views ${value ? 'Enabled' : 'Disabled'}")),
              );
            }
          },
        ),
        CheckboxListTile(
          title: const Text("Add to Cart Actions"),
          value: addToCartActions,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                addToCartActions = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Add to Cart Actions ${value ? 'Enabled' : 'Disabled'}")),
              );
            }
          },
        ),
        CheckboxListTile(
          title: const Text("View Cart but No Checkout"),
          value: viewCartButNoCheckout,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                viewCartButNoCheckout = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("View Cart but No Checkout ${value ? 'Enabled' : 'Disabled'}")),
              );
            }
          },
        ),
      ],
    );
  }
}

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 50,
            color: Colors.blue,
            title: "Shipping Costs",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.red,
            title: "Long Checkout Process",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.green,
            title: "Product Unavailable",
            radius: 50,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
        sectionsSpace: 4,
        centerSpaceRadius: 30,
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final String title;
  final List<double> data;
  final List<Color> colors;
  final List<String> categories;

  const BarChartWidget({
    required this.title,
    required this.data,
    required this.colors,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data
            .asMap()
            .map((index, value) {
          return MapEntry(
            index,
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: colors[index],
                  width: 16,
                )
              ],
            ),
          );
        })
            .values
            .toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  categories[value.toInt()],
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}






