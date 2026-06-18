import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/repositories/order_management_repository.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/localization/app_localizations.dart';

class GarageOrdersPage extends StatefulWidget {
  const GarageOrdersPage({super.key});

  @override
  State<GarageOrdersPage> createState() => _GarageOrdersPageState();
}

class _GarageOrdersPageState extends State<GarageOrdersPage> {
  final OrderManagementRepository _orderRepository =
      OrderManagementRepository();

  String selectedFilter = 'All';
  String searchQuery = '';
  List<Map<String, dynamic>> orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> filters = [
    'All',
    'Pending',
    'Accepted',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await _orderRepository.getOrders();
      debugPrint('Garage orders list response: $result');
      if (!mounted) return;
      setState(() {
        orders = result.map(_normalizeOrder).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _friendlyOrderError(e);
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredOrders {
    return orders.where((order) {
      final query = searchQuery.trim().toLowerCase();
      final items = order['items'] as List<Map<String, dynamic>>;
      final matchesSearch =
          query.isEmpty ||
          order['id'].toString().toLowerCase().contains(query) ||
          order['orderNumber'].toString().toLowerCase().contains(query) ||
          order['distributorName'].toString().toLowerCase().contains(query) ||
          items.any(
            (item) => item['name'].toString().toLowerCase().contains(query),
          );

      if (!matchesSearch) return false;
      if (selectedFilter == 'All') return true;
      return _statusBucket(order['status']) == selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffold,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadOrders,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? _buildErrorState(_errorMessage!)
                  : filteredOrders.isEmpty
                  ? _buildEmptyOrders()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 7),
                      itemCount: filteredOrders.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) return _buildOrdersOverview();
                        return _buildOrderCard(filteredOrders[index - 1]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trText('Garage Orders'),
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      context.trText(
                        'Track distributor orders and item delivery',
                      ),
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loadOrders,
                icon: const Icon(Icons.refresh_rounded),
                color: AppColors.primary,
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: context.trText('Search order, distributor, product...'),
              prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: AppColors.lightGrey,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: GoogleFonts.lato(fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedFilter = filter),
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: GoogleFonts.lato(
                    fontSize: 12,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersOverview() {
    final pending = orders
        .where((item) => _statusBucket(item['status']) == 'pending')
        .length;
    final accepted = orders
        .where((item) => _statusBucket(item['status']) == 'accepted')
        .length;
    final shipped = orders
        .where((item) => _statusBucket(item['status']) == 'shipped')
        .length;
    final delivered = orders
        .where((item) => _statusBucket(item['status']) == 'delivered')
        .length;
    final totalAmount = orders.fold<int>(
      0,
      (sum, item) => sum + _asInt(item['amount']),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14, top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.16),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.trText('Order Summary'),
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                'Rs ${_formatAmount(totalAmount)}',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _overviewItem('Total', orders.length.toString()),
              _overviewDivider(),
              _overviewItem('Pending', pending.toString()),
              _overviewDivider(),
              _overviewItem('Accepted', accepted.toString()),
              _overviewDivider(),
              _overviewItem('Shipped', shipped.toString()),
              _overviewDivider(),
              _overviewItem('Done', delivered.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          Text(
            context.trData(label),
            style: GoogleFonts.lato(
              fontSize: 10,
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewDivider() {
    return Container(
      width: 1,
      height: 38,
      color: AppColors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final items = order['items'] as List<Map<String, dynamic>>;
    final statusColor = _statusColor(status);

    return InkWell(
      onTap: () => _showOrderDetails(order),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.trData(order['orderNumber']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                _statusChip(status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _statusIcon(status),
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.trData(order['distributorName']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${items.length} item${items.length == 1 ? '' : 's'} - ${order['date']}',
                        style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rs ${_formatAmount(order['amount'])}',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: items.take(2).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.trData(item['name']),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${item['quantity']} x Rs ${_formatAmount(item['price'])}',
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            if (items.length > 2) const SizedBox(height: 8),
            if (items.length > 2)
              Text(
                '+${items.length - 2} more item${items.length - 2 == 1 ? '' : 's'}',
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoPill(Icons.payments_outlined, order['paymentMethod']),
                const SizedBox(width: 8),
                _infoPill(Icons.verified_outlined, order['paymentStatus']),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            _statusLabel(status),
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            context.trData(label),
            style: GoogleFonts.lato(
              fontSize: 10,
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    final items = order['items'] as List<Map<String, dynamic>>;
    final history = order['statusHistory'] as List<Map<String, dynamic>>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.86,
          minChildSize: 0.55,
          maxChildSize: 0.94,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.trText('Order Details'),
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.trData(order['orderNumber']),
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _statusChip(order['status']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _detailPanel(
                          children: [
                            _detailRow('Distributor', order['distributorName']),
                            _detailRow(
                              'Distributor Type',
                              order['distributorType'],
                            ),
                            _detailRow('Assignment', order['assignmentType']),
                            _detailRow('Order Date', order['date']),
                            _detailRow(
                              'Payment',
                              '${order['paymentMethod']} - ${order['paymentStatus']}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _sectionTitle('Products'),
                        const SizedBox(height: 8),
                        ...items.map(_itemDetailCard),
                        const SizedBox(height: 16),
                        _sectionTitle('Bill Summary'),
                        const SizedBox(height: 8),
                        _detailPanel(
                          children: [
                            _detailRow('Items', items.length.toString()),
                            _detailRow(
                              'Subtotal',
                              'Rs ${_formatAmount(order['amount'])}',
                            ),
                            _detailRow(
                              'Grand Total',
                              'Rs ${_formatAmount(order['amount'])}',
                              isAmount: true,
                            ),
                          ],
                        ),
                        if (history.isNotEmpty) const SizedBox(height: 16),
                        if (history.isNotEmpty)
                          _sectionTitle('Status Timeline'),
                        if (history.isNotEmpty) const SizedBox(height: 8),
                        if (history.isNotEmpty)
                          _detailPanel(
                            children: history.map(_historyRow).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailPanel({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      child: Column(children: children),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      context.trData(title),
      style: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              context.trData(label),
              style: GoogleFonts.lato(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              context.trData(value.isEmpty ? 'N/A' : value),
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                fontSize: isAmount ? 15 : 12,
                fontWeight: isAmount ? FontWeight.w800 : FontWeight.w600,
                color: isAmount ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDetailCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trData(item['name']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${item['quantity']} x Rs ${_formatAmount(item['price'])}',
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${_formatAmount(item['totalPrice'])}',
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyRow(Map<String, dynamic> history) {
    final status = _statusText(history['status']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(status),
              size: 15,
              color: _statusColor(status),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(status),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _formatDateTime(history['changedAt']),
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.receipt_long, size: 72, color: AppColors.grey),
        const SizedBox(height: 16),
        Text(
          context.trText('No orders found'),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.trText('Pull down to refresh order management data.'),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.cloud_off, size: 72, color: Colors.red.shade300),
        const SizedBox(height: 16),
        Text(
          context.trText('Orders could not be loaded'),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.trData(message),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            label: Text(context.trText('Retry')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(120, 42),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _normalizeOrder(Map<String, dynamic> order) {
    final distributor = order['distributor'];
    final distributorDetails = order['distributorDetails'];
    final items = _normalizeItems(order['items']);
    final status = _statusText(order['status']);

    return {
      ...order,
      'id': _asString(order['_id'] ?? order['id'] ?? order['orderId']),
      'orderNumber': _asString(order['orderNumber'], defaultValue: 'Order'),
      'distributorName': distributor is Map
          ? _asString(
              distributor['businessName'] ?? distributor['name'],
              defaultValue: 'Distributor',
            )
          : distributorDetails is Map
          ? _asString(
              distributorDetails['distributorName'],
              defaultValue: 'Distributor',
            )
          : _asString(
              order['assignedDistributorName'],
              defaultValue: 'Distributor',
            ),
      'distributorType': distributor is Map
          ? _asString(distributor['distributionType'], defaultValue: 'N/A')
          : _asString(order['assignedDistributorType'], defaultValue: 'N/A'),
      'assignmentType': _readableText(
        context.trData(
          order['assignmentType'] ?? distributorDetails?['assignmentType'],
        ),
      ),
      'items': items,
      'status': status,
      'amount': _asInt(
        order['totalAmount'] ?? order['amount'] ?? order['total'],
      ),
      'paymentMethod': _asString(order['paymentMethod'], defaultValue: 'N/A'),
      'paymentStatus': _asString(order['paymentStatus'], defaultValue: 'N/A'),
      'date': _formatDate(order['createdAt'] ?? order['date']),
      'statusHistory': _normalizeHistory(order['statusHistory']),
    };
  }

  List<Map<String, dynamic>> _normalizeItems(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map>().map((item) {
      final quantity = _asInt(item['quantity']);
      final price = _asInt(item['price']);
      return {
        'product': _asString(item['product']),
        'name': _asString(item['name'], defaultValue: 'Product'),
        'quantity': quantity,
        'price': price,
        'totalPrice': _asInt(
          item['totalPrice'],
          defaultValue: quantity * price,
        ),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _normalizeHistory(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map>().map((item) {
      return {
        'status': _asString(item['status']),
        'changedAt': item['changedAt'],
      };
    }).toList();
  }

  String _statusText(dynamic value) {
    final status = _asString(value).trim();
    return status.isEmpty ? 'Pending' : status;
  }

  String _friendlyOrderError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection') ||
        text.contains('timeout')) {
      return 'We could not refresh your orders. Please check your internet connection and try again.';
    }
    if (text.contains('401') || text.contains('unauthorized')) {
      return 'Your session has expired. Please sign in again to view orders.';
    }
    if (text.contains('500') || text.contains('server')) {
      return 'The order service is temporarily unavailable. Please try again in a moment.';
    }
    return 'Orders could not be loaded right now. Please try again.';
  }

  String _statusBucket(dynamic value) {
    final status = _statusText(value).toLowerCase();
    if (status.contains('accept')) return 'accepted';
    if (status.contains('ship')) return 'shipped';
    if (status.contains('deliver') || status.contains('complete')) {
      return 'delivered';
    }
    if (status.contains('cancel') || status.contains('reject')) {
      return 'cancelled';
    }
    return 'pending';
  }

  String _statusLabel(String status) {
    switch (_statusBucket(status)) {
      case 'accepted':
        return _statusText(status);
      case 'shipped':
        return _statusText(status);
      case 'delivered':
        return _statusText(status);
      case 'cancelled':
        return _statusText(status);
      default:
        return _statusText(status);
    }
  }

  Color _statusColor(String status) {
    switch (_statusBucket(status)) {
      case 'accepted':
        return Colors.blue;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (_statusBucket(status)) {
      case 'accepted':
        return Icons.verified_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.pending_actions_rounded;
    }
  }

  String _formatDate(dynamic value) {
    final text = _asString(value);
    if (text.isEmpty) return 'N/A';
    final date = DateTime.tryParse(text)?.toLocal();
    if (date == null) return text;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(dynamic value) {
    final text = _asString(value);
    if (text.isEmpty) return 'N/A';
    final date = DateTime.tryParse(text)?.toLocal();
    if (date == null) return text;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${_formatDate(value)}  $hour:$minute';
  }

  String _formatAmount(dynamic value) {
    final amount = _asInt(value).toString();
    final buffer = StringBuffer();
    for (var i = 0; i < amount.length; i++) {
      final fromEnd = amount.length - i;
      buffer.write(amount[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  String _readableText(dynamic value) {
    final text = _asString(value, defaultValue: 'N/A');
    if (text == 'N/A') return text;
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  int _asInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  String _asString(dynamic value, {String defaultValue = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? defaultValue : text;
  }
}
