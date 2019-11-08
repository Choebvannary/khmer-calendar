import 'dart:io';

import 'package:flutter/material.dart';

class Navigate{
	static Future push(BuildContext context, Widget routTo){
		return Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context)=> routTo
			)
		);
	}

	static Future removeUntil(BuildContext context, Widget routTo){
		return Navigator.of(context).pushAndRemoveUntil(
			MaterialPageRoute(
				builder: (context) => routTo),
				(Route<dynamic> route) => false
		).then((value){
			if(value){
				exit(0);
			}
		});
	}

	static Future route(BuildContext context, Widget routTo){
		return Navigator.pushReplacement(
			context,
			MaterialPageRoute(
				builder: (context)=> routTo
			)
		);
	}
}