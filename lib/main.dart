import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  print("running");
  // print(getColors());
  //test();
  //createColorSwatch();
  runApp(
    const MaterialApp(
      title: "Color Fetcher Title",
      home: FetcherHome(),
    ),
  );
}

// Example return
// {
// "result" : [
// [34,44,49],
// [71,103,83],
// [130,163,127],
// [176,190,154],
// [234,203,148]
// ]
// }
void test() async {
  var response = await http.post(
      Uri.parse('http://colormind.io/api/'),
      headers: <String, String>{
        'Content-Type': 'text/plain',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
      body: '{"model":"default"}'
  );
  print(jsonDecode(response.body));
}

class ColorSwatch {
  // var emptylist = List<int>.filled(3,0);
  // final colors = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
  final List<List<int>> colors;

  ColorSwatch({ required this.colors });

  // factory ColorSwatch.fromJson(Map<String, dynamic> json) {
  //   return ColorSwatch(colors: json["result"]);
  // }
}

Future<http.Response> getColors() {
  return http.post(
    Uri.parse('http://colormind.io/api/'),
    headers: <String, String>{
      'Content-Type': 'text/plain',
    },
    body: '{"model":"default"}'
  );
}

Future<ColorSwatch> createColorSwatch() async {
  final response = await getColors();

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var dataResult = data['result'];
    print("Data, $data");
    //return ColorSwatch.fromJson(jsonDecode(response.body));
    //return ColorSwatch(colors: data["result"]);
    print("dataResult: $dataResult");
    print(dataResult[0].runtimeType);
    var test = dataResult[0].map((s) => s as int).toList();
    print(test);
    print(test.runtimeType);

    print(dataResult[0][0].runtimeType);

    var colorArray = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
    print(colorArray);
    // Converting List<dynamic> to List<int>.
    // There should be a much better way, but I don't know it
    for (var i = 0; i < colorArray.length; i++) {
      for (var j = 0; j < colorArray[i].length; j++) {
        colorArray[i][j] = dataResult[i][j];
      }
    }
    print(colorArray);
    print(colorArray[0]);
    print(colorArray[0].runtimeType);
    print(colorArray[0][0].runtimeType);

    return ColorSwatch(colors: colorArray);

  } else {
    return ColorSwatch(colors: [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]);
  }
}

class FetcherHome extends StatefulWidget {
  const FetcherHome({Key? key}) : super(key: key);

  @override
  _FetcherHomeState createState() {
    return _FetcherHomeState();
  }
}

class _FetcherHomeState extends State<FetcherHome> {
  var body = Center(child: Text("Placeholder for colors"));

  void displayColorSwatch() async {
    setState(() {
      body = const Center(child: Text("waiting for colors"));
    });

    var panelData = await createColorSwatch();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ColorPage(data: panelData,)),
    );

  }

  void test() {
    print("EKJlkj");
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text("Color Fetcher"))
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
          tooltip: "Add",
          child: Icon(Icons.add),
          onPressed: () => {displayColorSwatch()}
      ),
    );
  }
}




class ColorContainer extends StatelessWidget {
  //const ColorContainer({Key? key}) : super(key: key);
  final ColorSwatch colorData;
  ColorContainer({required this.colorData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print(colorData.colors[1]),
      onDoubleTap: () => print(colorData.colors[2]),
      child: Container(
        child: Card(
          child: Center(child: Text(colorData.colors.toString())),
        ),
      ),
    );
  }
  
}

class ColorPage extends StatefulWidget {
  final ColorSwatch data;
  const ColorPage({Key? key, required this.data}) : super(key: key);

  @override
  _ColorPageState createState() {
    return _ColorPageState();
  }
}

class _ColorPageState extends State<ColorPage> {

  @override
  Widget build(BuildContext context) {
    const title = 'Grid List';
    print(widget.data.colors);
    var data = widget.data.colors;

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 1,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(5, (index) {
            return Center(
              child: Text(
                data[index].toString(),
                style: Theme.of(context).textTheme.headline5,
              ),
            );
          }),
        ),
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //         title: const Center(child: Text("Color Fetcher"))
  //     ),
  //     body: Text(widget.data.colors.toString()),
  //     floatingActionButton: FloatingActionButton(
  //         tooltip: "Add",
  //         child: Icon(Icons.add),
  //         onPressed: null // () => {displayColorSwatch()}
  //     ),
  //   );
  // }
}