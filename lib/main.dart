import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(StreamProviderExample());

/// *****************************************************
/// *****************************************************
/// *****************************************************
/// Something important to understand here is that there's a
/// fundamental difference between using this StreamProvider
/// and using a ChangeNotifier for something like this.
///
///
/// It's a stream of OBJECTS, *not changes*.
///
/// Using a ChangeNotifier updates you about changes but doesn't
/// give you a whole new object to replace the old one.
///
/// Here, each time there is a periodic tick we're NOT updating
/// the value of the int in our existing object, **we're creating a whole
/// new object with the new value of our periodic** !!
///
/// In short: The int is NOT incrementing. Instead, each new tick
/// creates a whole new object with a value for that int that is
/// one higher than the int of the object it's replacing.
///
/// *****************************************************
/// *****************************************************
/// *****************************************************

class StreamProviderExample extends StatelessWidget {
  const StreamProviderExample({
    Key key,
}) : super();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ModelObjectBeingStreamed>(
      /// You need to give it the first instance of whatever you're
      /// streaming so it has something to initialize with
      initialData: ModelObjectBeingStreamed(currentValueOfMemberInTheObjectBeingStreamed: 0),

      create: (context) => createStreamOfObjectBeingStreamed(),
      child: MaterialApp(
        home: StreamProviderExampleUI(),
      ),
    );
  }
}

class StreamProviderExampleUI extends StatelessWidget {
  const StreamProviderExampleUI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamProvider Example'),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment(0, -.20),

        /// It's just a standard Consumer
        child: Consumer<ModelObjectBeingStreamed>(
          builder: (context, newInstanceOfModelObjectBeingStreamed, _) {
            return StuffYouSee(
              newInstanceOfModelObjectBeingStreamed: newInstanceOfModelObjectBeingStreamed,
            );
          },
        ),
      ),
    );
  }
}

class StuffYouSee extends StatelessWidget {
  const StuffYouSee({
    Key key,
    this.newInstanceOfModelObjectBeingStreamed,
  }) : super(key: key);

  final ModelObjectBeingStreamed newInstanceOfModelObjectBeingStreamed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.purple[200],
          border: Border.all(
            color: Colors.black45,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(2, 2),
            ),
          ]),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This is NOT incrementing! \n\nIt\s the number of times this '
            'ModelObject has been replaced with a completely different '
            'one. Each new Object has a value one higher than the Object it '
            'replaced.\n\nRemember, we\'re streaming Objects, not updates.\n',
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          Text(
            newInstanceOfModelObjectBeingStreamed.currentValueOfMemberInTheObjectBeingStreamed.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 88,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Stream<ModelObjectBeingStreamed> createStreamOfObjectBeingStreamed() {
  return Stream<ModelObjectBeingStreamed>.periodic(
      Duration(seconds: 1),
      (currentPeriodicValue) =>
          ModelObjectBeingStreamed(currentValueOfMemberInTheObjectBeingStreamed: currentPeriodicValue + 1)).take(10000);
}

class ModelObjectBeingStreamed {
  ModelObjectBeingStreamed({this.currentValueOfMemberInTheObjectBeingStreamed});
  int currentValueOfMemberInTheObjectBeingStreamed;
}
