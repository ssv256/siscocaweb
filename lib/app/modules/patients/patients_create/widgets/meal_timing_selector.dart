import 'package:flutter/material.dart';

class MealTimingSelector extends StatefulWidget {
  final Function(String) onMealTimingSelected;
  final String? initialTiming;

  const MealTimingSelector({
    Key? key,
    required this.onMealTimingSelected,
    this.initialTiming,
  }) : super(key: key);

  @override
  _MealTimingSelectorState createState() => _MealTimingSelectorState();
}

class _MealTimingSelectorState extends State<MealTimingSelector> {
  String? selectedTiming;

  @override
  void initState() {
    super.initState();
    selectedTiming = widget.initialTiming;
  }

  @override
  Widget build(BuildContext context) {
    List<String> mealTimings = [
      'Antes de comer',
      'Después de comer',
      'Durante la comida',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuándo tomar',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            itemCount: mealTimings.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTiming = mealTimings[index];
                  });
                  widget.onMealTimingSelected(mealTimings[index]);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(163, 188, 194, 202),
                    border: Border.all(
                      color: selectedTiming == mealTimings[index]
                        ? Colors.green
                        : Colors.transparent,
                      width: selectedTiming == mealTimings[index] ? 1.5 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Center(
                      child: Text(
                        mealTimings[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: selectedTiming == mealTimings[index]
                            ? Colors.black
                            : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 