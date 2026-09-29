import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BFiOdishaApp());
}

class BFiOdishaApp extends StatelessWidget {
  const BFiOdishaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BFi Odisha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PartnerDashboardScreen(),
    );
  }
}

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  final List<Map<String, dynamic>> _leads = [
    {
      'customerName': 'Ramesh Chandra Sahoo',
      'type': 'Commercial Vehicle Loan',
      'amount': 1800000.0,
      'status': 'Disbursed',
      'partnerPayout': 22226.4,
      'date': '28 Sep 2026'
    },
    {
      'customerName': 'Kalinga Traders',
      'type': 'Business Loan',
      'amount': 2500000.0,
      'status': 'Submitted to Bank',
      'partnerPayout': 0.0,
      'date': '29 Sep 2026'
    },
    {
      'customerName': 'Priyanka Dash',
      'type': 'Vehicle Insurance (New Car)',
      'amount': 32000.0,
      'status': 'Approved',
      'partnerPayout': 3500.0,
      'date': '25 Sep 2026'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BFi Odisha Partner Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Balugaon Partner Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormat.format(25726.40),
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStat('Active Leads', '8 Cases'),
                      _buildMiniStat('Disbursed Vol.', '₹43.0 Lakhs'),
                      _buildMiniStat('TDS Deducted', '₹525 (2%)'),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('Services & New Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    context,
                    title: 'Loan Services',
                    subtitle: 'Personal, Business, CV, Cars',
                    icon: Icons.account_balance,
                    color: Colors.blue.shade800,
                    onTap: () => _openNewLeadModal(context, 'Loan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildServiceCard(
                    context,
                    title: 'General Insurance',
                    subtitle: 'Vehicle, Property, Health',
                    icon: Icons.verified_user,
                    color: Colors.teal.shade700,
                    onTap: () => _openNewLeadModal(context, 'Insurance'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Applications & CRM', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _leads.length,
              itemBuilder: (context, index) {
                final lead = _leads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(lead['customerName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${lead['type']} • ${lead['date']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(currencyFormat.format(lead['amount']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(lead['status']).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lead['status'],
                            style: TextStyle(color: _getStatusColor(lead['status']), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  static Widget _buildServiceCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disbursed':
        return Colors.green.shade700;
      case 'Submitted to Bank':
        return Colors.orange.shade800;
      case 'Approved':
        return Colors.blue.shade700;
      default:
        return Colors.grey;
    }
  }

  void _openNewLeadModal(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New $type Submission', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Customer Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Required Loan / Policy Amount', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Attach Documents (PAN, Aadhaar, Bank Stmt)'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: Colors.grey.shade800, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
              child: const Text('Submit Application to Bank Site'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
