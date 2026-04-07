class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'MedicalGPT';
  static const String appTagline = 'A Family of Medical AI Models';

  // Splash
  static const String splashSubtitle = 'A Family of Medical AI Models';

  // Onboarding
  static const String onboardingTitle1 = 'MedicalGPT';
  static const String onboardingSubtitle1 =
      'AI-powered healthcare assistance at your fingertips';
  static const String onboardingTitle2 = 'Our Capabilities';
  static const String onboardingSubtitle2 =
      'Advanced medical AI tools designed for you';
  static const String onboardingTitle3 = 'Important Medical Disclaimer';
  static const String onboardingDisclaimer =
      'MedicalGPT is an AI-assisted tool for informational and research purposes only. '
      'It is NOT a substitute for professional medical advice, diagnosis, or treatment. '
      'Always consult a qualified healthcare professional for all medical decisions.';
  static const String onboardingDisclaimerSub =
      'By continuing, you agree to use this app responsibly and understand its limitations.';
  static const String onboardingCta = "I Understand, Let's Begin";
  static const String skip = 'Skip';
  static const String next = 'Next';

  // Auth
  static const String welcomeBack = 'Welcome Back';
  static const String signInSubtitle = 'Sign in to continue';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String createAccount = 'Create Account';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = "Don't have an account? ";
  static const String hasAccount = 'Already have an account? ';
  static const String continueWithGoogle = 'Continue with Google';
  static const String termsAgreement =
      'I agree to the Terms of Service and Privacy Policy';
  static const String or = 'or';

  // Home
  static const String homeGreeting = 'How can I help you today?';
  static const String homeSubtitle =
      'Ask a medical question, analyze an image, or read a report.';
  static const String inputHint = 'Ask MedicalGPT...';
  static const String newChat = 'New Chat';
  static const String recentChats = 'RECENT CHATS';

  // Suggestion Chips
  static const String suggestion1 = 'Analyze Skin Lesion';
  static const String suggestion2 = 'Medical Question';
  static const String suggestion3 = 'Read Report';

  // Attachment Menu
  static const String analyzeSkin = 'Analyze Skin Lesion';
  static const String chestXray = 'Chest X-Ray';
  static const String medicalReport = 'Read Report';
  static const String medicalOcr = 'Medical OCR';
  static const String comingSoon = 'Coming Soon';

  // AI Response Placeholders
  static const String thinkingMessage = 'MedicalGPT is thinking...';
  static const String defaultAiResponse =
      'Thank you for your question. As an AI medical assistant, I can provide general health information. '
      'For your specific concern, I recommend consulting a qualified healthcare professional for personalized advice. '
      'Is there anything specific you\'d like to know more about?';

  // Drawer
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String about = 'About MedicalGPT';

  // Profile
  static const String editProfile = 'Edit Profile';
  static const String signOut = 'Sign Out';
  static const String joinedOn = 'Joined';
  static const String changePhoto = 'Change Photo';

  // Settings
  static const String appearance = 'Appearance';
  static const String darkMode = 'Dark Mode';
  static const String notifications = 'Notifications';
  static const String enableNotifications = 'Enable Notifications';
  static const String aboutSection = 'About';
  static const String appVersion = 'App Version';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String rateApp = 'Rate the App';
  static const String accountSection = 'Account';
  static const String deleteAccount = 'Delete Account';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection.';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String nameRequired = 'Full name is required';
  static const String emailNotFound =
      'This email does not exist. Please create a new account.';

  // Feature Items (no emojis)
  static const String featureSkinTitle = 'Skin Lesion Classifier';
  static const String featureSkinDesc = 'Detects 8 types of skin lesions';
  static const String featureChestTitle = 'Chest X-Ray Analyzer';
  static const String featureChestDesc = 'AI-powered chest X-ray analysis';
  static const String featureChatTitle = 'Medical Chatbot';
  static const String featureChatDesc = 'Ask any health question';
  static const String featureOcrTitle = 'Medical OCR';
  static const String featureOcrDesc = 'Read prescriptions & reports';
}
