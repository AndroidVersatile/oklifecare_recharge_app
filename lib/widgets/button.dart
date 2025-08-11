import 'package:flutter/material.dart';

import 'package:uonly_app/theme/app_theme.dart';
class CustomElevatedBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool isActive;
  final Color? textColor;
  final bool isBigSize;
  final bool isUpperCase;

  const CustomElevatedBtn({
    this.isActive = true,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.isBigSize = false,
    this.isUpperCase = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Container(
        width: isBigSize ? size.width * 0.8 : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE95168), // Pink
              Color(0xFFE95168), // Purple
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class CustomElevatedIconBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final Color? color;

  const CustomElevatedIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: TextButton.styleFrom(
        fixedSize: context.screenSize * .4,
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;

  const CustomTextBtn({
    required this.onPressed,
    required this.text,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? context.colorScheme.primary,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class CustomTextIconBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color? color;

  const CustomTextIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class CustomOutlinedIconBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final Color? color;

  const CustomOutlinedIconBtn({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textScale = TextUtils.getTextScale(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      label: Icon(icon),
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
        surfaceTintColor: color ?? Theme.of(context).colorScheme.secondary,
        side: BorderSide(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
      icon: Text(
        text,
        // textScaleFactor: textScale,
      ),
    );
  }
}

class CustomOutlinedBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isBigSize;

  // final IconData icon;
  final Color? color;

  const CustomOutlinedBtn({
    required this.onPressed,
    required this.text,
    required this.isBigSize,
    // required this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textScale = TextUtils.getTextScale(context);
    final size = MediaQuery.of(context).size;
    return OutlinedButton(
      onPressed: onPressed,
      // label: Icon(icon),
      style: TextButton.styleFrom(
        fixedSize: isBigSize ? size * .4 : null,
        foregroundColor: color ?? Theme.of(context).colorScheme.secondary,
        surfaceTintColor: color ?? Theme.of(context).colorScheme.secondary,
        side: BorderSide(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Text(
        text,
        // textScaleFactor: textScale,
      ),
    );
  }
}

class CustomDropDownButton extends StatefulWidget {
  const CustomDropDownButton(
      {required this.items,
      required this.label,
      required this.onSelect,
      this.initialSelection,
      this.fillColor,
      super.key});

  final List<String> items;
  final String label;
  final String? initialSelection;
  final Color? fillColor;
  final void Function(String date) onSelect;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      key: widget.key,
      width: context.screenWidth - 20,
      menuHeight: 300,
      onSelected: (value) {
        widget.onSelect(value!);
        setState(() {});
      },
      inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          suffixIconColor: Color(0xFF8189B0),
          labelStyle: context.textTheme.labelMedium?.copyWith(
            color: Color(0xFF8189B0),
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF8189B0),
              ),
              borderRadius: BorderRadius.circular(AppTheme.radius)),
          fillColor: widget.fillColor ?? Colors.white,
          outlineBorder: BorderSide.none,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppTheme.radius))),
      dropdownMenuEntries:
          widget.items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
      label: Text(widget.label),
      initialSelection: widget.initialSelection ?? '',
    );
  }
}
