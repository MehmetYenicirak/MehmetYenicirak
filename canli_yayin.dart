import 'package:flutter/material.dart';
import "package:flutter_vlc_player/flutter_vlc_player.dart";
import 'package:cloud_firestore/cloud_firestore.dart';


class canli_yayin extends StatefulWidget {
  canli_yayin({Key? key}) : super(key: key);

  @override
  State<canli_yayin> createState() => _canli_yayinState();
}

class _canli_yayinState extends State<canli_yayin> {
  static const _networkCachingMs = 2000;
  @override
  Widget build(BuildContext context) {
    CollectionReference db = FirebaseFirestore.instance.collection('HTTPS');

    return FutureBuilder(
      future: db.doc("https").get(),     
      builder: (BuildContext context, AsyncSnapshot snapshot) {
         Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            String httpsirl =data["https"];
            // örnek url
            //"https://gstreamer.freedesktop.org/data/media/sintel_trailer-480p.webm"

 
            late final VlcPlayerController _controller  = VlcPlayerController.network(
            httpsirl,
             hwAcc: HwAcc.full,
             options: VlcPlayerOptions(
               advanced: VlcAdvancedOptions(
                 [VlcAdvancedOptions.networkCaching(_networkCachingMs)]
               ),
               http: VlcHttpOptions([
                 VlcHttpOptions.httpReconnect(true),
                 ]),
               rtp: VlcRtpOptions([
                 VlcRtpOptions.rtpOverRtsp(true),
               ]),
            
             )
            );
        return Scaffold(
          appBar: AppBar(),
          body:Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
          VlcPlayer(controller: _controller, aspectRatio:16 / 9 ,
           placeholder:Center(child: CircularProgressIndicator(),),
           )
          
        ],
          ) ,


        ) ;
      },
    );
  }
}
