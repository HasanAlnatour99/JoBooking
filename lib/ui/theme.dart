import 'package:bookingme/services/utilits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blueClr = Color(0xFF1C3955);
const Color orangeClr = Color(0xFFFC982E);
const Color whiteClr = Colors.white;
const Color lightOrange = Color(0xFFFFAB4C);
const Color pinkClr = Color(0xFFff4667);
MaterialColor primaryClr = buildMaterialColor(blueClr);
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);
const Color blackClr = Color(0xFF2d2e2c);
const mBackgroundColor = Color(0xFFFAFAFA);
const mBlueColor = Color(0xFF2C53B1);
const mGreyColor = Color(0xFFB4B0B0);
const mTitleColor = Color(0xFF23374D);
const mSubtitleColor = Color(0xFF8E8E8E);
const mBorderColor = Color(0xFFE8E8F3);
const mFillColor = Color(0xFFFFFFFF);
const mCardTitleColor = Color(0xFF2E4ECF);
const mCardSubtitleColor = mTitleColor;

class Themes {
  static TextStyle buttonStyle=TextStyle(
    fontFamily: GoogleFonts.lora().fontFamily,
    color: Colors.white,
    letterSpacing: 0.4,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle inputStyle=TextStyle(
    fontFamily: GoogleFonts.roboto().fontFamily,
    color: blackClr,
    letterSpacing: 0.5,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static TextStyle header2 = TextStyle(
    fontFamily: GoogleFonts.lora().fontFamily,
    color: Colors.white,
    fontSize: 18,
    letterSpacing: 0.4,
    fontWeight: FontWeight.bold
  );
  static TextStyle header3 = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      color: Colors.white,
      fontSize: 15,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w500,
  );
  static TextStyle header4 = TextStyle(
    fontFamily: GoogleFonts.roboto().fontFamily,
    color: Colors.grey,
    fontSize: 13,
    letterSpacing: 0.4,
    fontWeight: FontWeight.bold,
  );
  // Style for title
  static TextStyle mTitleStyle = GoogleFonts.inter(
      fontWeight: FontWeight.w600, color: mTitleColor, fontSize: 16);

// Style for Discount Section
  static TextStyle mMoreDiscountStyle = GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w700, color: mBlueColor);

// Style for Service Section
  static TextStyle mServiceTitleStyle = GoogleFonts.inter(
      fontWeight: FontWeight.w500, fontSize: 13, color: mTitleColor);
  static TextStyle mServiceSubtitleStyle = GoogleFonts.inter(
      fontWeight: FontWeight.w400, fontSize: 10, color: mSubtitleColor);

// Style for Popular Destination Section
  static TextStyle mPopularDestinationTitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: mCardTitleColor,
  );
  static TextStyle mPopularDestinationSubtitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: mCardSubtitleColor,
  );

// Style for Travlog Section
  static TextStyle mTravlogTitleStyle = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w900, color: mFillColor);
  static TextStyle mTravlogContentStyle = GoogleFonts.inter(
      fontSize: 10, fontWeight: FontWeight.w500, color: mTitleColor);
  static TextStyle mTravlogPlaceStyle = GoogleFonts.inter(
      fontSize: 10, fontWeight: FontWeight.w500, color: mBlueColor);
}