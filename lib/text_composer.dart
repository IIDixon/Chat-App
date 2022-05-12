import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  const TextComposer(this.sendMessage, {Key? key}) : super(key: key);
  final Function ({String? text, File? imgFile}) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool isComposing = false;
  final controller = TextEditingController();
  final picker = ImagePicker();

  void reset(){
    controller.clear();
    setState(() {
      isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
              onPressed: () async{
                XFile? img = await picker.pickImage(source: ImageSource.camera);
                if(img == null) return;
                widget.sendMessage(imgFile: File(img.path));
              },
              icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
              onChanged: (text){
                setState(() {
                  isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                widget.sendMessage(text : text);
                reset();
              },
            ),
          ),
          IconButton(
              onPressed: isComposing ? (){
                widget.sendMessage(text: controller.text);
                reset();
              } : null,
              icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
