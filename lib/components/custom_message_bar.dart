import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class CustomMessageBar extends MessageBar {
  final TextStyle messageInputTextStyle;
  final TextEditingController _textController = TextEditingController();

  CustomMessageBar(
      {super.replying,
      super.replyingTo,
      super.actions,
      super.replyWidgetColor,
      super.replyIconColor,
      super.replyCloseColor,
      super.messageBarColor,
      super.sendButtonColor,
      super.messageBarHitText,
      super.messageBarHintStyle,
      super.onTextChanged,
      super.onSend,
      super.onTapCloseReply,
      this.messageInputTextStyle = kTextFieldInputTextStyle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          replying
              ? Container(
                  color: replyWidgetColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        color: replyIconColor,
                        size: 24,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            'Re : ' + replyingTo,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTapCloseReply,
                        child: Icon(
                          Icons.close,
                          color: replyCloseColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          replying
              ? Container(
                  height: 1,
                  color: Colors.grey.shade300,
                )
              : Container(),
          Container(
            color: messageBarColor,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: <Widget>[
                ...actions,
                Expanded(
                  child: Container(
                    child: TextField(
                      style: messageInputTextStyle,
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: onTextChanged,
                      decoration: InputDecoration(
                        hintText: messageBarHitText,
                        hintMaxLines: 1,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        hintStyle: messageBarHintStyle,
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: InkWell(
                    child: Icon(
                      Icons.send,
                      color: sendButtonColor,
                      size: 24,
                    ),
                    onTap: () {
                      if (_textController.text.trim() != '') {
                        if (onSend != null) {
                          onSend!(_textController.text.trim());
                        }
                        _textController.text = '';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
