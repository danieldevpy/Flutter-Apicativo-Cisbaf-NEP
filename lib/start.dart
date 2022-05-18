
import 'dart:async';
import 'dart:io';
import 'package:Cisbaf_NEP/chrome_safari_browser_example.screen.dart';
import 'package:Cisbaf_NEP/notification_badge.dart';
import 'package:Cisbaf_NEP/services/local_notification_service.dart';
import 'package:Cisbaf_NEP/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restart_app/restart_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';


import 'model/pushnotification_model.dart';


Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
  
}
// import 'package:path_provi'der/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// InAppLocalhostServer localhostServer = new InAppLocalhostServer();

Future main() async {

  
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();


  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }

  runApp(MyApp());
}

  late int start = 0;
 

class MyChromeSafariBrowser extends ChromeSafariBrowser {

  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
      
         start = 1;
  }
}


class MyApp extends StatefulWidget {
  final ChromeSafariBrowser browser = MyChromeSafariBrowser();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

    void launchWhatsapp({@required number, @required message}) async{
    String url = "whatsapp://send?phone=$number&text=$message";

    await canLaunch(url) ? launch(url) : print("object");
  }

    void registerNotification() async{
    LocalNotificationService.initialize(context);
    await Firebase.initializeApp();
    


    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message){
                 
                   
                   final routeFromMessage = message!.data["link"];
                             if(message != null){
                             urlpadrao = routeFromMessage;
                              if (widget.browser.isOpened()){
                                   widget.browser.close();
                  
                  
                              }else{
                                print("não está aberto");
                              }
                             
                             

                                PushNotification notification = PushNotification(
                                title: message.notification!.title,
                                body: message.notification!.body,
                                dataTitle: message.data['title'],
                                dataBody: message.data['body'],
                              );
                              setState(() {
                                _totalNotificationCounter ++;
                                _notificationInfo = notification;
                                
                                });
                             
                              print("o link da notificação é $urlpadrao");
                            }else{
                              
                              
                            }
                            });

    
        late final FirebaseMessaging messaging;

     
    

        final _messaging = FirebaseMessaging.instance;

        NotificationSettings settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized){
          print("Usuario autorizado");

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          

          final outraurl = message.data["link"];
          
          
          PushNotification notification = PushNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body'],
          );
          setState(() {
            _totalNotificationCounter ++;
            _notificationInfo = notification;
            urlpadrao = outraurl;
            
            
          });
         });

        }


    }
  

  @override
  void initState() {
    registerNotification();

    super.initState();


                             FirebaseMessaging.onMessage.listen((message) {
                              if(message.notification != null){
                                print(message.notification!.title);
                                print(message.notification!.body);

                                
                              }else{

                                
                              }
                              LocalNotificationService.display(message);
                             });
                            FirebaseMessaging.onMessageOpenedApp.listen((message) async{ 
                              
                              
                             
                              final routeFromMessage = message.data["link"];
                             
                             urlpadrao = routeFromMessage;
                              print("o link da notificação é! $urlpadrao");

                            PushNotification notification = PushNotification(
                                title: message.notification!.title,
                                body: message.notification!.body,
                                dataTitle: message.data['title'],
                                dataBody: message.data['body'],
                                
                              );
                              setState(() {
                                _totalNotificationCounter ++;
                                _notificationInfo = notification;
                               
                              

                                });
                            }
                            );
                            widget.browser.open(
                            url: Uri.parse("https://cursosonline.nep.cisbaf.com/"),
                            options: ChromeSafariBrowserClassOptions(
                                android: AndroidChromeCustomTabsOptions(
                                    addDefaultShareMenuItem: false,
                                    enableUrlBarHiding: true,
                                    showTitle: false,
                                    keepAliveEnabled: true,
                                    toolbarBackgroundColor: Colors.transparent,
                                    ),
                                    
                                ios: IOSSafariOptions(
                                    dismissButtonStyle:
                                        IOSSafariDismissButtonStyle.CLOSE,
                                    presentationStyle:
                                        IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
    super.initState();
                         
                            
                          
          _totalNotificationCounter = 0;

  }
  String urlpadrao = "https://cursosonline.nep.cisbaf.com/";
  late int _totalNotificationCounter;
  PushNotification? _notificationInfo;
 


  @override
  void dispose() {
    super.dispose();


    
  }

 @override
  Widget build(BuildContext context) {

    return Scaffold(
        
        body: LayoutBuilder(
          builder:(context, constraints){


          
            if (constraints.maxWidth > 600 )  {
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/fundobranco.png"),fit:BoxFit.cover,)),
                  child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
             
                      Image(image: AssetImage('images/logo.png')),
                      SizedBox(height: 50,),
                      if (_totalNotificationCounter != 0)
                            Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.topCenter,
                            width: 350,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),

                              borderRadius: BorderRadius.circular(5),
                              
                              
                              ),
                              
                              child: Column(
                                children: [
                                  
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Notificações  ",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                    NotificationBadge(totalNotification: _totalNotificationCounter),
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  _notificationInfo != null
                                  ?  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Text(
                                        
                                        "${_notificationInfo!.dataTitle ?? _notificationInfo!.title}",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(height: 9,),
                                      Text(
                                        "${_notificationInfo!.dataBody ?? _notificationInfo!.body}",
                                        style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 10,),
                                    
                                      ])
                                      : Container(),Column(
                                        children: [
                                          ElevatedButton(
                                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                                        onPressed: () async {
                                      
                                                  if (widget.browser.isOpened()){
                                                    await widget.browser.close();
                                      
                                      
                                                  }else{
                                                    print("não está aberto");
                                                  }
                                                  await widget.browser.open(
                                                  url: Uri.parse(urlpadrao),
                                                  options: ChromeSafariBrowserClassOptions(
                                                      android: AndroidChromeCustomTabsOptions(
                                                          addDefaultShareMenuItem: false,
                                                          enableUrlBarHiding: true,
                                                          showTitle: false,
                                                          keepAliveEnabled: true,
                                                          toolbarBackgroundColor: Colors.transparent,
                                                          ),
                                                          
                                                      ios: IOSSafariOptions(
                                                          dismissButtonStyle:
                                                              IOSSafariDismissButtonStyle.CLOSE,
                                                          presentationStyle:
                                                              IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
                                            
                                        },
                      
                        
                              child: Text("ABRIR NOTIFICAÇÃO")),
                                        ],
                                      )
                                ],
                                
                              ),
                              
                    
                            ),
                                  SizedBox(height: 20,),
                                Text('Bem vindo ao aplicativo do Cisbaf NEP',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
            
                                  
                                ),),
                                Container(
                                
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.topCenter,
                                width: 370,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                              
                                  ),
                                  child: Text("Nosso aplicativo está em fase de desenvol-vimento e foi criado com intuito de facilitar o estudo dos cursos presentes na platafor-ma do Cisbaf NEP \n\nPara acessar as aulas basta clicar no botão abrir plataforma!",
                                          style: TextStyle(fontSize: 18,)),
              
                                ),
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(horizontal: 110,)
                                  ),
                                  
                                    onPressed: () async {
                              
                                        if (widget.browser.isOpened()){
                                        await widget.browser.close();
                      
                      
                                        }else{
                                          print("não está aberto");
                                        }
                                        await widget.browser.open(
                                        url: Uri.parse("https://cursosonline.nep.cisbaf.com/"),
                                        options: ChromeSafariBrowserClassOptions(
                                            android: AndroidChromeCustomTabsOptions(
                                                addDefaultShareMenuItem: false,
                                                enableUrlBarHiding: true,
                                                showTitle: false,
                                                keepAliveEnabled: true,
                                                toolbarBackgroundColor: Colors.transparent,
                                                ),
                                                
                                            ios: IOSSafariOptions(
                                                dismissButtonStyle:
                                                    IOSSafariDismissButtonStyle.CLOSE,
                                                presentationStyle:
                                                    IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
                                  
                              },
                              child:Text("ABRIR PLATAFORMA",),),
                              ElevatedButton.icon(
                              label: Text("Ajuda"),
                              icon: Icon(Icons.call),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 140,)

                              ),
                              onPressed: (){
                                launchWhatsapp(number: "+5521968843062", message: "Olá preciso de ajuda com o aplciativo do CISBAF NEP");
                              },),
                              
                              SizedBox(height: 20),


                        
                
                            ],
                          ),
                  ),
                ),
              );
            }
            // CELULAR 
            else{
            
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/fundobranco.png"),fit:BoxFit.cover,)),
                  child: Center(
                    child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                             
                                  Image(image: AssetImage('images/logo.png')),
                                  SizedBox(height: 30,),
                                  if (_totalNotificationCounter != 0)
                                  Container(
                                  padding: EdgeInsets.all(10.0),
                                  alignment: Alignment.topCenter,
                                  width: 300,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                    
                                    ),
                                    
                                    child: Column(
                                      children: [
                                        
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Notificações  ",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          NotificationBadge(totalNotification: _totalNotificationCounter),
                                          ],
                                        ),
                                        SizedBox(height: 6,),
                                        _notificationInfo != null
                                        ?  Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            
                                            Text(
                                              
                                              "${_notificationInfo!.dataTitle ?? _notificationInfo!.title}",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                              SizedBox(height: 4,),
                                            Text(
                                              "${_notificationInfo!.dataBody ?? _notificationInfo!.body}",
                                              style: TextStyle(fontSize: 14)),
                                            SizedBox(height: 5,),
                                          
                                            ])
                                            : Container(),Column(
                                              children: [
                                                ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary: Colors.orange),
                                              onPressed: () async {
                                            
                                                        if (widget.browser.isOpened()){
                                                          await widget.browser.close();
                                            
                                            
                                                        }else{
                                                          print("não está aberto");
                                                        }
                                                        await widget.browser.open(
                                                        url: Uri.parse(urlpadrao),
                                                        options: ChromeSafariBrowserClassOptions(
                                                            android: AndroidChromeCustomTabsOptions(
                                                                addDefaultShareMenuItem: false,
                                                                enableUrlBarHiding: true,
                                                                showTitle: false,
                                                                keepAliveEnabled: true,
                                                                toolbarBackgroundColor: Colors.transparent,
                                                                ),
                                                                
                                                            ios: IOSSafariOptions(
                                                                dismissButtonStyle:
                                                                    IOSSafariDismissButtonStyle.CLOSE,
                                                                presentationStyle:
                                                                    IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
                                                  
                                              },
                            
                              
                                    child: Text("ABRIR NOTIFICAÇÃO")),
                            
                                              ],
                                            )
                                      ],
                                      
                                    ),
                                    
                          
                                          ),
                                        
                               
                                  
                                    Text('Bem vindo ao aplicativo do Cisbaf NEP',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      
                                    ),),
                                    Container(
                                        padding: EdgeInsets.all(10.0),
                                        alignment: Alignment.topCenter,
                                        width: 300,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                      
                                          ),
                                          child: Text("Nosso aplicativo está em fase de desenvolvimento e foi criado com intuito de facilitar o estudo dos cursos presentes na plataforma do Cisbaf NEP \n\nPara acessar as aulas basta clicar no botão abrir plataforma!",
                                                  style: TextStyle(fontSize: 15,)),
                      
                                        ),
                                        ElevatedButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            padding: EdgeInsets.symmetric(horizontal: 70,)
                                          ),
                                          
                                            onPressed: () async {
                                      
                                                if (widget.browser.isOpened()){
                                                await widget.browser.close();
                              
                              
                                                }else{
                                                  print("não está aberto");
                                                }
                                                await widget.browser.open(
                                                url: Uri.parse("https://cursosonline.nep.cisbaf.com/"),
                                                options: ChromeSafariBrowserClassOptions(
                                                    android: AndroidChromeCustomTabsOptions(
                                                        addDefaultShareMenuItem: false,
                                                        enableUrlBarHiding: true,
                                                        showTitle: false,
                                                        keepAliveEnabled: true,
                                                        toolbarBackgroundColor: Colors.transparent,
                                                        ),
                                                        
                                                    ios: IOSSafariOptions(
                                                        dismissButtonStyle:
                                                            IOSSafariDismissButtonStyle.CLOSE,
                                                        presentationStyle:
                                                            IOSUIModalPresentationStyle.OVER_FULL_SCREEN)));
                                          
                                      },
                                      child:Text("ABRIR PLATAFORMA",),),
                                      ElevatedButton.icon(
                                      label: Text("Ajuda"),
                                      icon: Icon(Icons.call),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(horizontal: 110,)

                                      ),
                                      onPressed: (){
                                        launchWhatsapp(number: "+5521968843062", message: "Olá preciso de ajuda com o aplciativo do CISBAF NEP");
                                      },),
                                      


                
                      
                                  ],
                                ),
                  ),
                ),
              );
            }
            
    
          },
          
          )
      
      );
  }


  
}
