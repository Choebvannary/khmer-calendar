import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rdbCalendar/res/color.dart';
import 'package:rdbCalendar/res/fontsize.dart';
import 'package:rdbCalendar/res/number.dart';
import 'package:rdbCalendar/res/string.dart';
import 'package:rdbCalendar/service/service.dart';
import 'package:rdbCalendar/shared-pref/shared-pref.dart';
import 'package:rdbCalendar/ui/home.dart';
import 'package:rdbCalendar/util/logging.dart';
import 'package:rdbCalendar/util/navigate.dart';
import 'package:rdbCalendar/widget/text-view.dart';

class NoConnection extends StatefulWidget {
  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
	StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
	  super.initState();
	  _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
		  if(result != ConnectivityResult.none){
			  _checkSpeed();
		  }
	  });
  }

	@override
	void dispose() {
		_subscription.cancel();
		super.dispose();
	}

	@override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    elevation: 0.0,
		    backgroundColor: Colors.transparent,
	    ),
	    backgroundColor: ColorRes.white,
	    body: Container(
		    child: Center(
			    child: SingleChildScrollView(
				    child: Column(
					    crossAxisAlignment: CrossAxisAlignment.center,
					    mainAxisAlignment: MainAxisAlignment.center,
					    children: <Widget>[
						    Icon(
							    Icons.portable_wifi_off,
							    size: NumberRes.width145,
							    color: ColorRes.grey,
						    ),
						    TextView().buildText(
							    text: StringRes.noConnectionKh,
							    textAlign: TextAlign.center,
							    style: TextStyle(
								    fontSize: FontSize.subtitle
							    )
						    ),
						    TextView().buildText(
							    text: StringRes.noConnectionEn,
							    textAlign: TextAlign.center,
							    style: TextStyle(
								    fontSize: FontSize.subtitle
							    )
						    ),
						    SizedBox(height: NumberRes.width145)
					    ],
				    ),
			    ),
		    ),
	    ),
    );
  }

	void _checkSpeed() async {
		try {
			final result = await InternetAddress.lookup('google.com');
			if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
				_getMonthData();
			}
		} on SocketException catch (_) {
			Logging.logWarning(StringRes.noConnectionEn);
		}
	}

	void _getMonthData() {
	  ServiceFS().getMonth().then((data){
	  	SharedPref.setPref(data);
	  	Navigate.pushAndRemoveUntil(context, Home());
	  }).catchError((e){
	  	Logging.logWarning(e.toString());
	  });
	}
}
