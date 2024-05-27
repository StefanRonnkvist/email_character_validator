import "package:flutter/material.dart";

const String _alphabitCharacters =
    "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
const String numberCharacters = "0123456789";
const String specialCharacters = "!#\$%&'*+-/=?^_`{|~.";
const String cautionCharacters = "(),:;<>[\\]";
const String domainCharacters = "-.";
const String consecutiveCharacters = "@-_.";
const String atCharacter = "@";
const String dotCharacter = ".";
const Color cautionColor = Colors.amber;
const Color passColor = Colors.green;
const Color failColor = Colors.red;
const int maxEmailName = 64;
const int maxEmailDomain = 253;
const int maxEmailTld = 63;
const int minEmailName = 1;
const int minEmailDomain = 1;
const int minEmailTld = 2;

List<String> _findEmailParts(String fullEmail) {
  /*
  This Class accepts a string that is an eMail address and returns a list of three strings. the elements of the string list are eMail Name, Domain Name and Top Level Domain (TLD) Name. if the entered string can not be broken into the three components, the class will return \"error\" in each list element.
   */
  bool errorValue = false;
  String namePart = "";
  String domainPart = "";
  String tldPart = "";
  String domainEmail = "";
  int lastAtIndex = fullEmail.lastIndexOf(atCharacter);
  if (lastAtIndex.isNegative) {
    errorValue = true;
  }
  if(!lastAtIndex.isNegative){
    domainEmail = fullEmail.substring(lastAtIndex + 1);
    namePart = fullEmail.substring(0, lastAtIndex);
  }
  int lastDotIndex = domainEmail.lastIndexOf(dotCharacter);
  if (lastDotIndex.isNegative) {
    errorValue = true;
  }
  if(!lastDotIndex.isNegative){
    domainPart = domainEmail.substring(0, lastDotIndex);
    tldPart = domainEmail.substring(lastDotIndex + 1);
  }
  List<String> returnList = [
    namePart,
    domainPart,
    tldPart,
    errorValue.toString()
  ];
  return returnList;
}

List<int> _makeConsecutive(String fullEmailChars) {
  /*
  finds consecutive specific special characters in the email string
   */
  List<String> emailChar = fullEmailChars.split("");
  List<int> matchIndex = [];
  List<int> reducedIndex = [];
  for (int j = 0; j < emailChar.length; j++) {
    if (consecutiveCharacters.contains(emailChar[j])) {
      matchIndex.add(j);
    }
  }
  for (int j = 0; j < matchIndex.length - 1; j++) {
    if (matchIndex[j].compareTo(matchIndex[j + 1] - 1) == 0) {
      reducedIndex.add(matchIndex[j]);
      reducedIndex.add(matchIndex[j + 1]);
    }
  }
  if (consecutiveCharacters.contains(emailChar[0])) {
    reducedIndex.add(0);
  }
  if (consecutiveCharacters.contains(emailChar[emailChar.length - 1])) {
    reducedIndex.add(emailChar.length - 1);
  }
  reducedIndex = (reducedIndex.toSet().toList());
  reducedIndex.sort();
  return reducedIndex;
}

List<TextSpan> _testEmailParts(String nameParts, String characterString,
    int minCharacter, int maxCharacter) {
  /*
  This class accepts two strings and two integers and returns a list of TextSpans the color each characters as pass, warning and fail. The determination of each character as valid character and string length of each string used in email name, domain name and TLD name.
   */
  List<TextSpan> textSpanList = [];
  List<String> testString = nameParts.split("");
  if (testString.length < minCharacter) {
    for (int i = 0; i < testString.length; i++) {
      textSpanList.add(TextSpan(
          text: testString[i], style: const TextStyle(color: failColor)));
    }
  } else if (testString.length > maxCharacter) {
    for (int i = 0; i < testString.length; i++) {
      textSpanList.add(TextSpan(
          text: testString[i], style: const TextStyle(color: failColor)));
    }
  } else {
    for (int i = 0; i < testString.length; i++) {
      if(_makeConsecutive(nameParts).contains(i)){
        textSpanList.add(TextSpan(
            text: testString[i], style: const TextStyle(color: failColor)));
      }
      else if (characterString.contains(testString[i])) {
        textSpanList.add(TextSpan(
            text: testString[i], style: const TextStyle(color: passColor)));
      } else if (cautionCharacters.contains(testString[i])) {
        textSpanList.add(TextSpan(
            text: testString[i], style: const TextStyle(color: cautionColor)));
      } else {
        textSpanList.add(TextSpan(
            text: testString[i], style: const TextStyle(color: failColor)));
      }
    }
  }
  return textSpanList;
}

RichText _errorMessageTextSpan() {
  String errorMessage = "eMail must contain one each \"@\" and \".\" symbols ";
  RichText newTextSpan = RichText(
      text: TextSpan(text: null, children: <InlineSpan>[
    TextSpan(text: errorMessage, style: const TextStyle(color: failColor)),
  ]));
  return newTextSpan;
}

RichText buildTextSpan(String fullEmail) {
  /*
  This is the entry class for this project and accepts an email string and returns RichText that contains the email characters colored inside TextSpans.
   */
  List<String> nameDomainTLD = _findEmailParts(fullEmail);
  bool errorState = bool.parse(nameDomainTLD[3]);
  if (errorState) {
    return _errorMessageTextSpan();
  }
  String testName = _alphabitCharacters + numberCharacters + specialCharacters;
  String testDomain = _alphabitCharacters + numberCharacters + domainCharacters;
  List<TextSpan> nameTextSpan =
      _testEmailParts(nameDomainTLD[0], testName, minEmailName, maxEmailName);
  List<TextSpan> domainTextSpan = _testEmailParts(
      nameDomainTLD[1], testDomain, minEmailDomain, maxEmailDomain);
  List<TextSpan> tldTextSpan =
      _testEmailParts(nameDomainTLD[2], testDomain, minEmailTld, maxEmailTld);
  RichText newTextSpan = RichText(
    text: TextSpan(text: null, children: <InlineSpan>[
      for (int i = 0; i < nameTextSpan.length; i++) ...{
        nameTextSpan[i],
      },
      const TextSpan(text: atCharacter, style: TextStyle(color: passColor)),
      for (int i = 0; i < domainTextSpan.length; i++) ...{
        domainTextSpan[i],
      },
      const TextSpan(text: dotCharacter, style: TextStyle(color: passColor)),
      for (int i = 0; i < tldTextSpan.length; i++) ...{
        tldTextSpan[i],
      },
    ]),
  );
  return newTextSpan;
}
