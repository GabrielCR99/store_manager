import 'package:flutter/material.dart';

import 'image_source_sheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> fieldValidator,
    List initialValue,
    bool isAutoValidate = false,
  }) : super(
            onSaved: onSaved,
            validator: fieldValidator,
            initialValue: initialValue,
            autovalidate: isAutoValidate,
            builder: (state) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 124.0,
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value.map<Widget>((i) {
                        return Container(
                            height: 100.0,
                            width: 100.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onLongPress: () {
                                state.didChange(state.value..remove(i));
                              },
                              child: i is String
                                  ? Image.network(
                                      i,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                    ),
                            ));
                      }).toList()
                        ..add(GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                      onImageSelected: (image) {
                                        state
                                            .didChange(state.value..add(image));
                                        Navigator.of(context).pop();
                                      },
                                    ));
                          },
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                            color: Colors.white.withAlpha(30),
                          ),
                        )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      : Container(),
                ],
              );
            });
}
