// lib/widgets/custom_dropdown.dart

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final Function(T?) onChanged;
  final Widget Function(T) itemBuilder;
  final bool isEnabled;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemBuilder,
    this.isEnabled = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- KOTAK UTAMA YANG TERLIHAT ---
        GestureDetector(
          onTap: widget.isEnabled ? () => setState(() => _isOpen = !_isOpen) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isEnabled ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOpen ? Colors.blue : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.value == null
                    ? Text(widget.hintText, style: TextStyle(color: Colors.grey.shade600, fontSize: 16))
                    : widget.itemBuilder(widget.value as T),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),

        // --- DAFTAR OPSI YANG MUNCUL/HILANG DENGAN ANIMASI ---
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: _isOpen,
            child: Container(
              margin: const EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    // PERBAIKAN DARI KODE BARU DITERAPKAN DI SINI
                    color: Colors.grey.withAlpha(25),
                    blurRadius: 4,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.where((item) => item != widget.value).map((item) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onChanged(item);
                        setState(() => _isOpen = false);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: widget.itemBuilder(item),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}