import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFFA9C7A);
const Color screenBgColor = Color(0xFFFAFAFA);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color black33Color = Color(0xFF333333);
const Color dBColor = Color(0xFFDBDBDB);
const Color greyColor = Colors.grey;

const double fixPadding = 10.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);
const SizedBox height5Space = SizedBox(height: 5.0);
const SizedBox widthSpace = SizedBox(width: fixPadding);
const SizedBox width5Space = SizedBox(width: 5.0);

SizedBox heightBox(double height) => SizedBox(height: height);

var focusedBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: primaryColor, width: 2.0),
);
var enabledBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: whiteColor, width: 2.0),
);

var enabledBorder2 = UnderlineInputBorder(
  borderSide: BorderSide(color: greyColor, width: 1.5),
);
var focusedBorder2 = UnderlineInputBorder(
  borderSide: BorderSide(color: primaryColor, width: 1.5),
);

Color getColor(int index) {
  if ((index + 4) % 4 == 0) {
    return Color(0xFFE3F2FD);
  } else if ((index + 3) % 4 == 0) {
    return Color(0xFFFFEBEE);
  } else if ((index + 2) % 4 == 0) {
    return Color(0xFFE8F5E9);
  } else if ((index + 1) % 4 == 0) {
    return Color(0xFFEDE7F6);
  } else {
    return Color(0xFFE3F2FD);
  }
}

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: blackColor.withValues(alpha: 0.15),
    blurRadius: 6.0,
    offset: Offset(0, 2),
  ),
];

const TextStyle extraBold16Black = TextStyle(
  color: blackColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w800,
);

const TextStyle bold18Primary = TextStyle(
  color: primaryColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold16Primary = TextStyle(
  color: primaryColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold15Primary = TextStyle(
  color: primaryColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold10Primary = TextStyle(
  color: primaryColor,
  fontSize: 10.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold18White = TextStyle(
  color: whiteColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold16White = TextStyle(
  color: whiteColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold10Grey = TextStyle(
  color: greyColor,
  fontSize: 10.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold16Grey = TextStyle(
  color: greyColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const TextStyle bold11Black = TextStyle(
  color: blackColor,
  fontSize: 11.0,
  fontWeight: FontWeight.w700,
);

const TextStyle semibold25Primary = TextStyle(
  color: primaryColor,
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold16Primary = TextStyle(
  color: primaryColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold15Primary = TextStyle(
  color: primaryColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold20White = TextStyle(
  color: whiteColor,
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold18White = TextStyle(
  color: whiteColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold16White = TextStyle(
  color: whiteColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold15White = TextStyle(
  color: whiteColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold13White = TextStyle(
  color: whiteColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold20Black = TextStyle(
  color: blackColor,
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold18Black = TextStyle(
  color: blackColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold16Black = TextStyle(
  color: blackColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold15Black = TextStyle(
  color: blackColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold14Black = TextStyle(
  color: blackColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold13Black = TextStyle(
  color: blackColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold16Grey = TextStyle(
  color: greyColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold15Grey = TextStyle(
  color: greyColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w600,
);

const TextStyle semibold14Grey = TextStyle(
  color: greyColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
);

const TextStyle medium14Primary = TextStyle(
  color: primaryColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium12Primary = TextStyle(
  color: primaryColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium15White = TextStyle(
  color: whiteColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium14White = TextStyle(
  color: whiteColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium13White = TextStyle(
  color: whiteColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium12White = TextStyle(
  color: whiteColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium18Black = TextStyle(
  color: blackColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium16Black = TextStyle(
  color: blackColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium15Black = TextStyle(
  color: blackColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium14Black = TextStyle(
  color: blackColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium13Black = TextStyle(
  color: blackColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium12Black = TextStyle(
  color: blackColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium10Black = TextStyle(
  color: blackColor,
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium17Grey = TextStyle(
  color: greyColor,
  fontSize: 17.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium15Grey = TextStyle(
  color: greyColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium14Grey = TextStyle(
  color: greyColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const TextStyle medium13Grey = TextStyle(
  color: greyColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const TextStyle regular20White = TextStyle(
  color: whiteColor,
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular15White = TextStyle(
  color: whiteColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular14White = TextStyle(
  color: whiteColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular13White = TextStyle(
  color: whiteColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular12White = TextStyle(
  color: whiteColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular20Black = TextStyle(
  color: blackColor,
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular15Black = TextStyle(
  color: blackColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular14Black = TextStyle(
  color: blackColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular13Black = TextStyle(
  color: blackColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular12Black = TextStyle(
  color: blackColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular20Grey = TextStyle(
  color: greyColor,
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular14Grey = TextStyle(
  color: greyColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const TextStyle regular13Grey = TextStyle(
  color: greyColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
);
