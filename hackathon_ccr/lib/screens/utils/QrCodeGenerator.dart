import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerate extends StatefulWidget {
  String idEmpresa;
  String idPromocao;
  QrCodeGenerate({this.idEmpresa, this.idPromocao});

  @override
  _QrCodeGenerateState createState() => _QrCodeGenerateState();
}

class _QrCodeGenerateState extends State<QrCodeGenerate> {
  @override
  initState(){
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  String getString(){
    if(this.widget.idPromocao==null)
      return this.widget.idEmpresa;
    else
      return this.widget.idEmpresa + "; " +this.widget.idPromocao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QrImage(
          data: getString(),
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
