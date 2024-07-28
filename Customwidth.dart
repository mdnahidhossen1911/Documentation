import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String? name;
  final NetworkImage? networkImage;
  final String? number;
  final String? gmail;
  final VoidCallback? onPress;
  final Color? color;


   UserItem({
    required this.name,
    required this.networkImage,
    required this.number,
    required this.gmail,
    required this.color,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 2, 20, 18),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: color,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
      ),
      child: GestureDetector(
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: networkImage,
                backgroundColor: Colors.grey.shade100,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text('Name : $name', style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                   Text('Gmail : $gmail', style: TextStyle(fontSize: 16,color: Colors.black),),
                   Text('Number : $number', style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

/// call widget /////////////////////////////////////////
////////////////////////////////////////////////////////
UserItem(
       name: 'Nahid Hossen',
       networkImage: NetworkImage('${userdata.data[index]['image']}'),
       gmail: 'nahid@gmail.com',
       number: '015xxxxxxxx',
       color: Colors.grey,
       onPress: (){
            print("position ${index+1}");
       }
)


