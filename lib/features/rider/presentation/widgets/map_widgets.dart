import 'package:flutter/material.dart';

// --- MOCK DATA ---
const Map<String, dynamic> kMockDeliveryDetails = {
  'orderId': '#WGO-4532',
  'estimatedTime': 'N/A (Pending location data)', // Updated for current state
  'customerName': 'Emmanuel Adebayo',
  'customerPhone': '+234 809 876 5432',
  'pickupLocation': 'Pending: Ask client for API spec',
  'deliveryLocation': 'Pending: Ask client for API spec',
  'deliveryFee': '1,200',
};

// --- 1. Find Destination Card Widget (Search Input) ---
class FindDestinationCard extends StatelessWidget {
  const FindDestinationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Choose Destination',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }
}

// --- 2. Delivery Details Card Widget ---
class DeliveryDetailsCard extends StatelessWidget {
  const DeliveryDetailsCard({super.key, this.isMobileDetails = false});

  final bool isMobileDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            isMobileDetails
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                kMockDeliveryDetails['orderId'] as String,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEstimatedTime(kMockDeliveryDetails['estimatedTime'] as String),
          const Divider(height: 24),
          _buildSection('Customer Information', [
            Text(
              kMockDeliveryDetails['customerName'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(kMockDeliveryDetails['customerPhone'] as String),
                _buildCallButton(),
              ],
            ),
          ]),
          const Divider(height: 24),
          _buildSection('Delivery Details', [
            _buildLocationRow(
              'Pickup Location',
              kMockDeliveryDetails['pickupLocation'] as String,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildLocationRow(
              'Delivery Location',
              kMockDeliveryDetails['deliveryLocation'] as String,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildFeeRow(
              'Delivery Fee',
              kMockDeliveryDetails['deliveryFee'] as String,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEstimatedTime(String time) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.orange, size: 20),
        const SizedBox(width: 8),
        Text(
          'Estimated delivery: $time',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF5B7E2E),
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildLocationRow(String label, String address, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(address, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String fee) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(
          '#$fee',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildCallButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFEEFC3), // Light yellow background
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.call, color: Color(0xFF5B7E2E), size: 16),
          SizedBox(width: 4),
          Text(
            'Call this customer',
            style: TextStyle(color: Color(0xFF5B7E2E), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
