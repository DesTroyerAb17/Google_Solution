import 'package:flutter/material.dart';
import 'blog_infographic_page.dart';

final Map<String, Widget Function()> infographicMap = {
  "What to Do in Case of a Burn":()=> BlogInfographicPage(
    title: "What to Do in Case of a Burn",
    bannerImage: "assets/blog_burn_banner.jpg",
    intro: "What to Do in Case of a Burn - Learn what to do and when to seek medical attention.",
    steps: [
      BlogStep(number: 1, title: "Step One", description: "Cool the area under running water for 10 minutes.", imagePath: "assets/burn_step1.png"),
      BlogStep(number: 2, title: "Step Two", description: "Apply a soothing burn cream or aloe vera gel.", imagePath: "assets/burn_step2.png"),
      BlogStep(number: 3, title: "Step Three", description: "Cover loosely with a clean, non-stick bandage.", imagePath: "assets/burn_step3.png"),
    ],
    medicalTips: [
      "Seek help if burn is large or deep.",
      "Watch for infection signs like pus or redness.",
      "Burns on face, hands, or genitals need urgent care.",
    ],
    quickTips: [
      "Never use ice or butter on burns.",
      "Avoid popping blisters.",
      "Keep burn area clean and dry.",
    ],
  ),

  "How to Stop a Nosebleed Quickly": ()=>BlogInfographicPage(
    title: "How to Stop a Nosebleed Quickly",
    bannerImage: "assets/blog_nosebleed_banner.jpg",
    intro: "Nosebleeds can look scary, but most aren't serious. Here's how to handle them calmly and correctly.",
    steps: [
      BlogStep(number: 1, title: "Sit Upright & Lean Forward", description: "This helps reduce pressure and prevents swallowing blood.", imagePath: "assets/nosebleed_step1.png"),
      BlogStep(number: 2, title: "Pinch the Nose", description: "Pinch the soft part for 10–15 minutes. Don't stop to check.", imagePath: "assets/nosebleed_step2.png"),
      BlogStep(number: 3, title: "Cold Compress", description: "Apply ice or cold towel on nose bridge.", imagePath: "assets/nosebleed_step3.png"),
    ],
    medicalTips: [
      "If bleeding lasts >20 minutes.",
      "If it follows a head injury.",
      "If occurring frequently without reason.",
    ],
    quickTips: [
      "Avoid nose-picking and dry air.",
      "Use saline sprays if needed.",
      "Don’t tilt the head back.",
    ],
  ),

  "First Aid for Choking: Step-by-Step Guide": ()=>BlogInfographicPage(
    title: "First Aid for Choking: Step-by-Step Guide",
    bannerImage: "assets/blog_choking_banner.jpg",
    intro: "Learn to help someone choking using back blows and abdominal thrusts.",
    steps: [
      BlogStep(number: 1, title: "Check for Coughing or Gasping", description: "If they can’t breathe, act fast.", imagePath: "assets/choking_step1.png"),
      BlogStep(number: 2, title: "Back Blows", description: "Give 5 firm back blows between the shoulder blades.", imagePath: "assets/choking_step2.png"),
      BlogStep(number: 3, title: "Abdominal Thrusts", description: "Give 5 inward-upward thrusts below the ribcage.", imagePath: "assets/choking_step3.png"),
    ],
    medicalTips: [
      "If unconscious, start CPR.",
      "Don’t use abdominal thrusts on infants.",
      "Call 911 if choking doesn’t stop.",
    ],
    quickTips: [
      "Encourage slow chewing.",
      "Cut food into small bites.",
      "Supervise children with toys.",
    ],
  ),

  "What to Do If Someone Faints": ()=>BlogInfographicPage(
    title: "What to Do If Someone Faints",
    bannerImage: "assets/blog_fainting_banner.jpg",
    intro: "Learn to help someone who fainted due to heat, shock, or low blood pressure.",
    steps: [
      BlogStep(number: 1, title: "Lay Them Down", description: "Keep legs elevated to restore blood flow.", imagePath: "assets/fainting_step1.png"),
      BlogStep(number: 2, title: "Loosen Clothes", description: "Helps improve breathing and comfort.", imagePath: "assets/fainting_step2.png"),
      BlogStep(number: 3, title: "Check Responsiveness", description: "Call for help if unconscious >1 minute.", imagePath: "assets/fainting_step3.png"),
    ],
    medicalTips: [
      "Seek care if fainting is frequent.",
      "Check for underlying conditions.",
      "If chest pain follows, call 911.",
    ],
    quickTips: [
      "Fan them gently if overheated.",
      "Don’t give food/water right away.",
      "Stay with the person till alert.",
    ],
  ),

  "Basic CPR Instructions for Everyone": ()=>BlogInfographicPage(
    title: "Basic CPR Instructions for Everyone",
    bannerImage: "assets/blog_cpr_banner.jpg",
    intro: "A guide to help save lives when someone stops breathing.",
    steps: [
      BlogStep(number: 1, title: "Check Response", description: "Tap and shout. Call 911 if no response.", imagePath: "assets/cpr_step1.png"),
      BlogStep(number: 2, title: "Start Chest Compressions", description: "Push hard and fast in center of chest.", imagePath: "assets/cpr_step2.png"),
      BlogStep(number: 3, title: "Give Rescue Breaths (Optional)", description: "Tilt head back and give 2 breaths.", imagePath: "assets/cpr_step3.png"),
    ],
    medicalTips: [
      "Only trained users should do rescue breaths.",
      "Use AED if available.",
      "Stop only when help arrives or signs of life return.",
    ],
    quickTips: [
      "Use 'Stayin’ Alive' beat for timing.",
      "Don’t interrupt compressions.",
      "Place hands correctly on sternum.",
    ],
  ),

  "How to Make a DIY First Aid Kit": ()=>BlogInfographicPage(
    title: "How to Make a DIY First Aid Kit",
    bannerImage: "assets/blog_firstaidkit_banner.jpg",
    intro: "Build your own emergency-ready first aid kit at home or for travel.",
    steps: [
      BlogStep(number: 1, title: "Collect Supplies", description: "Bandages, antiseptics, gloves, tweezers, etc.", imagePath: "assets/firstaidkit_step1.png"),
      BlogStep(number: 2, title: "Organize Items", description: "Use a labeled waterproof box.", imagePath: "assets/firstaidkit_step2.png"),
      BlogStep(number: 3, title: "Keep It Accessible", description: "Store in car, bag, or home cabinet.", imagePath: "assets/firstaidkit_step3.png"),
    ],
    medicalTips: [
      "Restock regularly.",
      "Check expiration dates.",
      "Customize it based on family needs.",
    ],
    quickTips: [
      "Include meds for allergies and pain.",
      "Add emergency contacts list.",
      "Train family on usage.",
    ],
  ),

  "How to Respond to Allergic Reactions":()=> BlogInfographicPage(
    title: "How to Respond to Allergic Reactions",
    bannerImage: "assets/blog_allergy_banner.jpg",
    intro: "Recognize and respond to mild or severe allergic reactions.",
    steps: [
      BlogStep(number: 1, title: "Identify Reaction", description: "Hives, swelling, sneezing, breathing issues.", imagePath: "assets/allergy_step1.png"),
      BlogStep(number: 2, title: "Use Antihistamines or EpiPen", description: "Give medication based on severity.", imagePath: "assets/allergy_step2.png"),
      BlogStep(number: 3, title: "Call Emergency if Needed", description: "If breathing worsens or EpiPen used.", imagePath: "assets/allergy_step3.png"),
    ],
    medicalTips: [
      "Always carry prescribed meds.",
      "Avoid known allergens.",
      "Medical alert bracelets help responders.",
    ],
    quickTips: [
      "Watch food labels carefully.",
      "Keep spare EpiPen accessible.",
      "Avoid fragrances if sensitive.",
    ],
  ),

  "Emergency Care for Electric Shock": ()=>BlogInfographicPage(
    title: "Emergency Care for Electric Shock",
    bannerImage: "assets/blog_electricshock_banner.jpg",
    intro: "Know how to handle an electric shock incident safely.",
    steps: [
      BlogStep(number: 1, title: "Turn Off Power", description: "Don’t touch the person until power is off.", imagePath: "assets/electricshock_step1.png"),
      BlogStep(number: 2, title: "Check Breathing", description: "Begin CPR if no response.", imagePath: "assets/electricshock_step2.png"),
      BlogStep(number: 3, title: "Treat Burns", description: "Cover with clean cloth, don’t apply creams.", imagePath: "assets/electricshock_step3.png"),
    ],
    medicalTips: [
      "If unconscious, call for ambulance.",
      "Even mild shocks can need checkups.",
      "Keep victim still and warm.",
    ],
    quickTips: [
      "Use insulated tools to separate them from source.",
      "Don’t delay emergency call.",
      "Don’t move person unless danger exists.",
    ],
  ),

  "First Aid Basics Everyone Should Know":()=> BlogInfographicPage(
    title: "First Aid Basics Everyone Should Know",
    bannerImage: "assets/blog_firstaid_banner.jpg",
    intro: "A helpful guide to handle common emergencies at home or work.",
    steps: [
      BlogStep(number: 1, title: "Minor Cuts", description: "Clean with water, apply ointment, and bandage.", imagePath: "assets/firstaid_step1.png"),
      BlogStep(number: 2, title: "Small Burns", description: "Cool under water, use aloe, and cover.", imagePath: "assets/firstaid_step2.png"),
      BlogStep(number: 3, title: "Nosebleeds", description: "Lean forward, pinch soft part for 10 minutes.", imagePath: "assets/firstaid_step3.png"),
    ],
    medicalTips: [
      "Keep a ready first aid kit.",
      "Learn CPR and choking aid.",
      "Emergency numbers should be handy.",
    ],
    quickTips: [
      "Teach kids about safety.",
      "Label all medicine clearly.",
      "Replace used items after emergencies.",
    ],
  ),
};
