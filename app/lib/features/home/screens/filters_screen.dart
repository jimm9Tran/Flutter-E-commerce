import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterType { atoZ, priceLtoH, priceHtoL }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          "Bộ lọc",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Đóng"))
        ],
      ),
      body: FiltersAvailable(),
    );
  }
}

class FiltersAvailable extends StatefulWidget {
  const FiltersAvailable({super.key});

  @override
  State<FiltersAvailable> createState() => _FiltersAvailableState();
}

class _FiltersAvailableState extends State<FiltersAvailable> {
  FilterType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    return Column(
      children: <Widget>[
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          title: const Text('a-z'),
          value: FilterType.atoZ,
          groupValue: _selectedFilter,
          onChanged: (FilterType? value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          title: const Text('Giá từ thấp đến cao'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          value: FilterType.priceLtoH,
          groupValue: _selectedFilter,
          onChanged: (FilterType? value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        RadioListTile(
          activeColor: Colors.deepPurple.shade700,
          title: const Text('Giá từ cao đến thấp'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: .1)),
          value: FilterType.priceHtoL,
          groupValue: _selectedFilter,
          onChanged: (FilterType? value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        TextButton(
            onPressed: () {
              if (_selectedFilter == FilterType.atoZ) {
                filterProvider.setFilterNumber(1);
              } else if (_selectedFilter == FilterType.priceLtoH) {
                filterProvider.setFilterNumber(2);
              } else if (_selectedFilter == FilterType.priceHtoL) {
                filterProvider.setFilterNumber(3);
              }
              Navigator.pop(context);
            },
            child: Text(
              "\nXác nhận",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple.shade700,
                  fontSize: 16),
            ))
      ],
    );
  }
}
