import 'package:book_my_seat/src/model/seat_layout_state_model.dart';
import 'package:book_my_seat/src/model/seat_model.dart';
import 'package:book_my_seat/src/utils/seat_state.dart';
import 'package:book_my_seat/src/widgets/seat_widget.dart';
import 'package:flutter/material.dart';

class SeatLayoutWidget extends StatelessWidget {
  final SeatLayoutStateModel stateModel;
  final void Function(int rowI, int colI, SeatState currentState)
      onSeatStateChanged;

  const SeatLayoutWidget({
    Key? key,
    required this.stateModel,
    required this.onSeatStateChanged,
  }) : super(key: key);
  String numberToAlphabet(int number) {
  // Check if the number is within the valid range (1 to 100)
    if (number < 1 || number > 100) {
      throw ArgumentError('Number must be between 1 and 100');
    }

    // Define the mapping of numbers to alphabets
    final List<String> alphabetMapping = [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
      'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];

    // Convert the number to alphabet(s)
    return _convertToAlphabet(number, alphabetMapping);
  }

  String _convertToAlphabet(int number, List<String> alphabetMapping) {
    if (number <= 26) {
      return alphabetMapping[number - 1];
    } else {
      // Calculate the first alphabet
      int firstIndex = ((number - 1) ~/ 26) - 1;
      int secondIndex = (number - 1) % 26;
      String firstAlphabet = alphabetMapping[firstIndex];
      String secondAlphabet = alphabetMapping[secondIndex];
      return '$firstAlphabet$secondAlphabet';
    }
  }
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 5,
      minScale: 0.8,
      boundaryMargin: const EdgeInsets.all(8),
      constrained: true,
      scaleEnabled: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              // Empty space for corner
              SizedBox(
                  width:
                      double.parse("${stateModel.seatSvgSize}")), // Adjust width as needed
              // Column numbers
              ...List<int>.generate(stateModel.cols, (colI) => colI)
                  .map<SizedBox>(
                    (colI) => SizedBox( width:
                      double.parse("${stateModel.seatSvgSize}"),
                    child: Text(
                      '${colI + 1}', // Adjust index to match your desired numbering
                      style: TextStyle(fontSize: 14,color: Colors.blueGrey), // Adjust style as needed
                    ),),
                  )
                  .toList()
            ],
          ),
          ...List<int>.generate(stateModel.rows, (rowI) => rowI)
              .map<Row>(
                (rowI) => Row(
                  children: [
                   SizedBox( width:
                      double.parse("${stateModel.seatSvgSize}"),
                    child: Text(
                          '${numberToAlphabet(rowI + 1)}', // Adjust index to match your desired numbering
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey), // Adjust style as needed
                        ),),
                    ...List<int>.generate(stateModel.cols, (colI) => colI)
                        .map<SeatWidget>((colI) => SeatWidget(
                              model: SeatModel(
                                seatState: stateModel.currentSeatsState[rowI]
                                    [colI],
                                rowI: rowI,
                                colI: colI,
                                seatSvgSize: stateModel.seatSvgSize,
                                pathSelectedSeat: stateModel.pathSelectedSeat,
                                pathDisabledSeat: stateModel.pathDisabledSeat,
                                pathSoldSeat: stateModel.pathSoldSeat,
                                pathUnSelectedSeat:
                                    stateModel.pathUnSelectedSeat,
                              ),
                              onSeatStateChanged: onSeatStateChanged,
                            ))
                        .toList()
                  ],
                ),
              )
              .toList()
        ],
      ),
      )
    );
  }
}
