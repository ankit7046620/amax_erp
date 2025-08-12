class UserModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  int? enabled;
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? username;
  String? language;
  String? timeZone;
  int? sendWelcomeEmail;
  int? unsubscribed;
  dynamic userImage;
  String? roleProfileName;
  String? moduleProfile;
  dynamic homeSettings;
  String? gender;
  String? birthDate;
  dynamic interest;
  dynamic phone;
  String? location;
  dynamic bio;
  String? mobileNo;
  int? muteSounds;
  String? deskTheme;
  dynamic bannerImage;
  String? newPassword;
  int? logoutAllSessions;
  String? resetPasswordKey;
  String? lastResetPasswordKeyGeneratedOn;
  dynamic lastPasswordResetDate;
  dynamic redirectUrl;
  int? documentFollowNotify;
  String? documentFollowFrequency;
  int? followCreatedDocuments;
  int? followCommentedDocuments;
  int? followLikedDocuments;
  int? followAssignedDocuments;
  int? followSharedDocuments;
  dynamic emailSignature;
  int? threadNotify;
  int? sendMeACopy;
  int? allowedInMentions;
  dynamic defaultWorkspace;
  dynamic defaultApp;
  int? simultaneousSessions;
  dynamic restrictIp;
  String? lastIp;
  int? loginAfter;
  String? userType;
  String? lastActive;
  int? loginBefore;
  int? bypassRestrictIpCheckIf2faEnabled;
  String? lastLogin;
  String? lastKnownVersions;
  String? apiKey;
  String? apiSecret;
  String? onboardingStatus;

  UserModel({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.docstatus,
    this.idx,
    this.enabled,
    this.email,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.username,
    this.language,
    this.timeZone,
    this.sendWelcomeEmail,
    this.unsubscribed,
    this.userImage,
    this.roleProfileName,
    this.moduleProfile,
    this.homeSettings,
    this.gender,
    this.birthDate,
    this.interest,
    this.phone,
    this.location,
    this.bio,
    this.mobileNo,
    this.muteSounds,
    this.deskTheme,
    this.bannerImage,
    this.newPassword,
    this.logoutAllSessions,
    this.resetPasswordKey,
    this.lastResetPasswordKeyGeneratedOn,
    this.lastPasswordResetDate,
    this.redirectUrl,
    this.documentFollowNotify,
    this.documentFollowFrequency,
    this.followCreatedDocuments,
    this.followCommentedDocuments,
    this.followLikedDocuments,
    this.followAssignedDocuments,
    this.followSharedDocuments,
    this.emailSignature,
    this.threadNotify,
    this.sendMeACopy,
    this.allowedInMentions,
    this.defaultWorkspace,
    this.defaultApp,
    this.simultaneousSessions,
    this.restrictIp,
    this.lastIp,
    this.loginAfter,
    this.userType,
    this.lastActive,
    this.loginBefore,
    this.bypassRestrictIpCheckIf2faEnabled,
    this.lastLogin,
    this.lastKnownVersions,
    this.apiKey,
    this.apiSecret,
    this.onboardingStatus,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    enabled = json['enabled'];
    email = json['email'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    username = json['username'];
    language = json['language'];
    timeZone = json['time_zone'];
    sendWelcomeEmail = json['send_welcome_email'];
    unsubscribed = json['unsubscribed'];
    userImage = json['user_image'];
    roleProfileName = json['role_profile_name'];
    moduleProfile = json['module_profile'];
    homeSettings = json['home_settings'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    interest = json['interest'];
    phone = json['phone'];
    location = json['location'];
    bio = json['bio'];
    mobileNo = json['mobile_no'];
    muteSounds = json['mute_sounds'];
    deskTheme = json['desk_theme'];
    bannerImage = json['banner_image'];
    newPassword = json['new_password'];
    logoutAllSessions = json['logout_all_sessions'];
    resetPasswordKey = json['reset_password_key'];
    lastResetPasswordKeyGeneratedOn =
        json['last_reset_password_key_generated_on'];
    lastPasswordResetDate = json['last_password_reset_date'];
    redirectUrl = json['redirect_url'];
    documentFollowNotify = json['document_follow_notify'];
    documentFollowFrequency = json['document_follow_frequency'];
    followCreatedDocuments = json['follow_created_documents'];
    followCommentedDocuments = json['follow_commented_documents'];
    followLikedDocuments = json['follow_liked_documents'];
    followAssignedDocuments = json['follow_assigned_documents'];
    followSharedDocuments = json['follow_shared_documents'];
    emailSignature = json['email_signature'];
    threadNotify = json['thread_notify'];
    sendMeACopy = json['send_me_a_copy'];
    allowedInMentions = json['allowed_in_mentions'];
    defaultWorkspace = json['default_workspace'];
    defaultApp = json['default_app'];
    simultaneousSessions = json['simultaneous_sessions'];
    restrictIp = json['restrict_ip'];
    lastIp = json['last_ip'];
    loginAfter = json['login_after'];
    userType = json['user_type'];
    lastActive = json['last_active'];
    loginBefore = json['login_before'];
    bypassRestrictIpCheckIf2faEnabled =
        json['bypass_restrict_ip_check_if_2fa_enabled'];
    lastLogin = json['last_login'];
    lastKnownVersions = json['last_known_versions'];
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
    onboardingStatus = json['onboarding_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['enabled'] = enabled;
    data['email'] = email;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['username'] = username;
    data['language'] = language;
    data['time_zone'] = timeZone;
    data['send_welcome_email'] = sendWelcomeEmail;
    data['unsubscribed'] = unsubscribed;
    data['user_image'] = userImage;
    data['role_profile_name'] = roleProfileName;
    data['module_profile'] = moduleProfile;
    data['home_settings'] = homeSettings;
    data['gender'] = gender;
    data['birth_date'] = birthDate;
    data['interest'] = interest;
    data['phone'] = phone;
    data['location'] = location;
    data['bio'] = bio;
    data['mobile_no'] = mobileNo;
    data['mute_sounds'] = muteSounds;
    data['desk_theme'] = deskTheme;
    data['banner_image'] = bannerImage;
    data['new_password'] = newPassword;
    data['logout_all_sessions'] = logoutAllSessions;
    data['reset_password_key'] = resetPasswordKey;
    data['last_reset_password_key_generated_on'] =
        lastResetPasswordKeyGeneratedOn;
    data['last_password_reset_date'] = lastPasswordResetDate;
    data['redirect_url'] = redirectUrl;
    data['document_follow_notify'] = documentFollowNotify;
    data['document_follow_frequency'] = documentFollowFrequency;
    data['follow_created_documents'] = followCreatedDocuments;
    data['follow_commented_documents'] = followCommentedDocuments;
    data['follow_liked_documents'] = followLikedDocuments;
    data['follow_assigned_documents'] = followAssignedDocuments;
    data['follow_shared_documents'] = followSharedDocuments;
    data['email_signature'] = emailSignature;
    data['thread_notify'] = threadNotify;
    data['send_me_a_copy'] = sendMeACopy;
    data['allowed_in_mentions'] = allowedInMentions;
    data['default_workspace'] = defaultWorkspace;
    data['default_app'] = defaultApp;
    data['simultaneous_sessions'] = simultaneousSessions;
    data['restrict_ip'] = restrictIp;
    data['last_ip'] = lastIp;
    data['login_after'] = loginAfter;
    data['user_type'] = userType;
    data['last_active'] = lastActive;
    data['login_before'] = loginBefore;
    data['bypass_restrict_ip_check_if_2fa_enabled'] =
        bypassRestrictIpCheckIf2faEnabled;
    data['last_login'] = lastLogin;
    data['last_known_versions'] = lastKnownVersions;
    data['api_key'] = apiKey;
    data['api_secret'] = apiSecret;
    data['onboarding_status'] = onboardingStatus;
    return data;
  }
}
