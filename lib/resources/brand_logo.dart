class BranchLogo {
  final String? branchName;
  final String? branchLogoSlug;
  final String? branchLogoPathLightMode;
  final String? branchLogoPathDarkMode;
  final List<String>? keyWords;
  BranchLogo(
    this.keyWords,
    this.branchLogoSlug, {
    this.branchName,
    this.branchLogoPathLightMode,
    this.branchLogoPathDarkMode,
  });
}

class BranchLogoCategory {
  final String categoryName;
  final Set<BranchLogo> branchLogos;
  BranchLogoCategory({required this.categoryName, required this.branchLogos});
}

List<BranchLogoCategory> branchLogoCategories = [
  BranchLogoCategory(
    categoryName: 'Social network & Tech companies',
    branchLogos: {
      facebook,
      instagram,
      twitter,
      linkedin,
      snapchat,
      tiktok,
      pinterest,
      whatsapp,
      google,
      microsoft,
      apple,
      samsung,
      netflix,
      gitlab,
      discord,
      vtc,
      x,
      behance,
      dribbble,
      github,
      slack,
      heroku,
      qq,
      reddit,
      skype,
      spotify,
      gmail,
      soundcloud,
      stackoverflow,
      tinder,
      tripadivisor,
      tumblr,
      twitch,
      udemy,
      viber,
      vimeo,
      wechat,
      weibo,
      zalo,
      vivo,
      coursera,
    },
  ),
  BranchLogoCategory(categoryName: 'Government', branchLogos: {vneid, mAadhaar}),
  BranchLogoCategory(categoryName: 'E-commerce', branchLogos: {amazon, shopee, tiki}),
  BranchLogoCategory(
    categoryName: 'Bank & Payment',
    branchLogos: {
      visa,
      mastercard,
      vietcombank,
      sacombank,
      acb,
      bidv,
      vietinbank,
      techcombank,
      vpbank,
      mbBank,
      maritimebank,
      momo,
      vib,
      agribank,
      usbank,
      bankofamerica,
      citi,
      paypal,
      vtcpay,
      // wellsfarge,
      pnc,
    },
  ),
];

List<BranchLogo> allBranchLogos = [
  gitlab,
  discord,
  x,
  facebook,
  instagram,
  twitter,
  linkedin,
  snapchat,
  tiktok,
  pinterest,
  whatsapp,
  google,
  gmail,
  microsoft,
  apple,
  samsung,
  amazon,
  netflix,
  vtc,
  behance,
  dribbble,
  github,
  slack,
  heroku,
  vneid,
  mAadhaar,
  qq,
  reddit,
  skype,
  spotify,
  mbBank,
  soundcloud,
  stackoverflow,
  tinder,
  tripadivisor,
  tumblr,
  twitch,
  udemy,
  viber,
  vimeo,
  wechat,
  weibo,
  zalo,
  vivo,
  coursera,
  vietcombank,
  sacombank,
  acb,
  bidv,
  momo,
  vib,
  vietinbank,
  techcombank,
  vpbank,
  maritimebank,
  agribank,
  usbank,
  bankofamerica,
  citi,
  visa,
  paypal,
  mastercard,
  vtcpay,
  wellsfarge,
  pnc,
  tiki,
  shopee,
];

//Government
BranchLogo vneid = BranchLogo(
  ['vneid'],
  'vneid',
  branchName: 'VNeID',
  branchLogoPathLightMode: 'assets/icons/brand_icons/VNeID_logo.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/VNeID_logo.svg',
);

BranchLogo mAadhaar = BranchLogo(
  ['mAadhaar'],
  'mAadhaar',
  branchName: 'mAadhaar',
  branchLogoPathLightMode: 'assets/icons/brand_icons/mAadhaar.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/mAadhaar_dark.svg',
);

BranchLogo gitlab = BranchLogo(
  ['gitlab'],
  'gitlab',
  branchName: 'Gitlab',
  branchLogoPathLightMode: 'assets/icons/brand_icons/gitlab_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/gitlab_icon.svg',
);

BranchLogo discord = BranchLogo(
  ['discord'],
  'discord',
  branchName: 'Discord',
  branchLogoPathLightMode: 'assets/icons/brand_icons/discord_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/discord_icon.svg',
);

BranchLogo facebook = BranchLogo(
  ['facebook', 'fb', "phở bò", "pho bo", "phay buc", "phây búc"],
  'facebook',
  branchName: 'Facebook',
  branchLogoPathLightMode: 'assets/icons/brand_icons/fb_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/fb_icon.svg',
);
BranchLogo instagram = BranchLogo(
  ['instagram', 'ig'],
  'instagram',
  branchName: 'Instagram',
  branchLogoPathLightMode: 'assets/icons/brand_icons/instagram_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/instagram_icon.svg',
);

BranchLogo x = BranchLogo(
  ['x'],
  'x',
  branchName: 'X',
  branchLogoPathLightMode: 'assets/icons/brand_icons/x_icon_black.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/x_icon_white.svg',
);
BranchLogo twitter = BranchLogo(
  ['twitter', 'twt'],
  'twitter',
  branchName: 'Twitter',
  branchLogoPathLightMode: 'assets/icons/brand_icons/twitter_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/twitter_icon.svg',
);
BranchLogo linkedin = BranchLogo(
  ['linkedin', 'in'],
  'linkedin',
  branchName: 'Linkedin',
  branchLogoPathLightMode: 'assets/icons/brand_icons/linkedin_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/linkedin_icon.svg',
);
BranchLogo snapchat = BranchLogo(
  ['snapchat'],
  'snapchat',
  branchName: 'Snapchat',
  branchLogoPathLightMode: 'assets/icons/brand_icons/snapchat_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/snapchat_icon.svg',
);
BranchLogo tiktok = BranchLogo(
  ['tiktok', 'tik tok', 'tik-tok', "top top", "tóp tóp", "tík tók", "tốp tốp"],
  'tiktok',
  branchName: 'Tiktok',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tiktok_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tiktok_icon-light.svg',
);
BranchLogo pinterest = BranchLogo(
  ['pinterest'],
  'pinterest',
  branchName: 'Pinterest',
  branchLogoPathLightMode: 'assets/icons/brand_icons/pinterest_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/pinterest_icon.svg',
);
BranchLogo whatsapp = BranchLogo(
  ['whatsapp'],
  'whatsapp',
  branchName: 'Whatsapp',
  branchLogoPathLightMode: 'assets/icons/brand_icons/whatsapp_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/whatsapp_icon.svg',
);
BranchLogo google = BranchLogo(
  ['google', 'gg', 'gu gồ', 'gu gô'],
  'google',
  branchName: 'Google',
  branchLogoPathLightMode: 'assets/icons/brand_icons/google_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/google_icon.svg',
);
BranchLogo microsoft = BranchLogo(
  ['microsoft', "word", "excel", "powerpoint", "outlook", "teams", "onedrive", "onedrive"],
  'microsoft',
  branchName: 'Microsoft',
  branchLogoPathLightMode: 'assets/icons/brand_icons/microsoft_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/microsoft_icon.svg',
);
BranchLogo apple = BranchLogo(
  [
    'apple',
    "icloud",
    "macbook",
    "iphone",
    "ipad",
    "watch",
    "airpod",
    "i cloud",
    "apple id",
    "appleid",
  ],
  'apple',
  branchName: 'Apple',
  branchLogoPathLightMode: 'assets/icons/brand_icons/apple_icon-black.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/apple_icon-white.svg',
);
BranchLogo samsung = BranchLogo(
  ['samsung', 'sam sung', 'sam-sung', 'sam sung', "samsung cloud", "samsungcloud"],
  'samsung',
  branchName: 'Samsung',
  branchLogoPathLightMode: 'assets/icons/brand_icons/samsung_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/samsung_icon-light.svg',
);
BranchLogo amazon = BranchLogo(
  ['amazon'],
  'amazon',
  branchName: 'Amazon',
  branchLogoPathLightMode: 'assets/icons/brand_icons/amazon_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/amazon_icon-light.svg',
);
BranchLogo netflix = BranchLogo(
  ['netflix', 'net flix', 'net-flix', "nét phích", "nét phích en chill", "netflix and chill"],
  'netflix',
  branchName: 'Netflix',
  branchLogoPathLightMode: 'assets/icons/brand_icons/netflix_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/netflix_icon.svg',
);
BranchLogo behance = BranchLogo(
  ['behance'],
  'behance',
  branchName: 'Behance',
  branchLogoPathLightMode: 'assets/icons/brand_icons/behance_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/behance_icon.svg',
);
BranchLogo dribbble = BranchLogo(
  ['dribbble'],
  'dribbble',
  branchName: 'Dribbble',
  branchLogoPathLightMode: 'assets/icons/brand_icons/dribbble_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/dribbble_icon.svg',
);
BranchLogo github = BranchLogo(
  ['github'],
  'github',
  branchName: 'Github',
  branchLogoPathLightMode: 'assets/icons/brand_icons/github_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/github_icon-light.svg',
);
BranchLogo slack = BranchLogo(
  ['slack'],
  'slack',
  branchName: 'Slack',
  branchLogoPathLightMode: 'assets/icons/brand_icons/slack_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/slack_icon.svg',
);
BranchLogo heroku = BranchLogo(
  ['heroku'],
  'heroku',
  branchName: 'Heroku',
  branchLogoPathLightMode: 'assets/icons/brand_icons/heroku_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/heroku_icon.svg',
);
BranchLogo paypal = BranchLogo(
  ['paypal', 'pay pal', 'pay-pal'],
  'paypal',
  branchName: 'Paypal',
  branchLogoPathLightMode: 'assets/icons/brand_icons/paypal_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/paypal_icon.svg',
);
BranchLogo qq = BranchLogo(
  ['qq'],
  'qq',
  branchName: 'QQ',
  branchLogoPathLightMode: 'assets/icons/brand_icons/qq_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/qq_icon.svg',
);
BranchLogo reddit = BranchLogo(
  ['reddit'],
  'reddit',
  branchName: 'Reddit',
  branchLogoPathLightMode: 'assets/icons/brand_icons/reddit_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/reddit_icon.svg',
);
BranchLogo skype = BranchLogo(
  ['skype'],
  'skype',
  branchName: 'Skype',
  branchLogoPathLightMode: 'assets/icons/brand_icons/skype_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/skype_icon.svg',
);
BranchLogo shopee = BranchLogo(
  ['shopee', 'sho pee', 'sho-pee', 'sho pee', "sọp be"],
  'shopee',
  branchName: 'Shopee',
  branchLogoPathLightMode: 'assets/icons/brand_icons/shopee_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/shopee_icon.svg',
);
BranchLogo spotify = BranchLogo(
  ['spotify'],
  'spotify',
  branchName: 'Spotify',
  branchLogoPathLightMode: 'assets/icons/brand_icons/spotify_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/spotify_icon.svg',
);
BranchLogo soundcloud = BranchLogo(
  ['soundcloud'],
  'soundcloud',
  branchName: 'Soundcloud',
  branchLogoPathLightMode: 'assets/icons/brand_icons/soundcloud_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/soundcloud_icon.svg',
);
BranchLogo stackoverflow = BranchLogo(
  ['stackoverflow', 'stack overflow', 'stack-overflow', 'stack overflow'],
  'stackoverflow',
  branchName: 'Stackoverflow',
  branchLogoPathLightMode: 'assets/icons/brand_icons/stackoverflow_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/stackoverflow_icon.svg',
);
BranchLogo tiki = BranchLogo(
  ['tiki', 'ti ki', 'ti-ki', 'ti ki', 'tí ki'],
  'tiki',
  branchName: 'Tiki',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tiki_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tiki_icon.svg',
);
BranchLogo tinder = BranchLogo(
  ['tinder'],
  'tinder',
  branchName: 'Tinder',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tinder_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tinder_icon.svg',
);
BranchLogo tripadivisor = BranchLogo(
  ['tripadvisor'],
  'tripadvisor',
  branchName: 'Tripadvisor',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tripadvisor_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tripadvisor_icon.svg',
);
BranchLogo tumblr = BranchLogo(
  ['tumblr'],
  'tumblr',
  branchName: 'Tumblr',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tumblr_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tumblr_icon-light.svg',
);
BranchLogo twitch = BranchLogo(
  ['twitch'],
  'twitch',
  branchName: 'Twitch',
  branchLogoPathLightMode: 'assets/icons/brand_icons/twitch_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/twitch_icon.svg',
);
BranchLogo udemy = BranchLogo(
  ['udemy'],
  'udemy',
  branchName: 'Udemy',
  branchLogoPathLightMode: 'assets/icons/brand_icons/udemy_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/udemy_icon.svg',
);
BranchLogo viber = BranchLogo(
  ['viber'],
  'viber',
  branchName: 'Viber',
  branchLogoPathLightMode: 'assets/icons/brand_icons/viber_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/viber_icon.svg',
);
BranchLogo vimeo = BranchLogo(
  ['vimeo'],
  'vimeo',
  branchName: 'Vimeo',
  branchLogoPathLightMode: 'assets/icons/brand_icons/vimeo_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/vimeo_icon.svg',
);
BranchLogo wechat = BranchLogo(
  ['wechat'],
  'wechat',
  branchName: 'Wechat',
  branchLogoPathLightMode: 'assets/icons/brand_icons/wechat_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/wechat_icon.svg',
);
BranchLogo weibo = BranchLogo(
  ['weibo'],
  'weibo',
  branchName: 'Weibo',
  branchLogoPathLightMode: 'assets/icons/brand_icons/weibo_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/weibo_icon-light.svg',
);
BranchLogo zalo = BranchLogo(
  ['zalo'],
  'zalo',
  branchName: 'Zalo',
  branchLogoPathLightMode: 'assets/icons/brand_icons/zalo_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/zalo_icon.svg',
);
BranchLogo vivo = BranchLogo(
  ['vivo'],
  'vivo',
  branchName: 'Vivo',
  branchLogoPathLightMode: 'assets/icons/brand_icons/vivo_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/vivo_icon.svg',
);
BranchLogo coursera = BranchLogo(
  ['coursera'],
  'coursera',
  branchName: 'Coursera',
  branchLogoPathLightMode: 'assets/icons/brand_icons/coursera_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/coursera_icon.svg',
);

BranchLogo tesla = BranchLogo(
  ['tesla'],
  'tesla',
  branchName: 'Tesla',
  branchLogoPathLightMode: 'assets/icons/brand_icons/tesla_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/tesla_icon-light.svg',
);

BranchLogo airbnb = BranchLogo(
  ['airbnb'],
  'airbnb',
  branchName: 'Airbnb',
  branchLogoPathLightMode: 'assets/icons/brand_icons/airbnb_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/airbnb_icon.svg',
);

BranchLogo gmail = BranchLogo(
  ['gmail', "email", "e mail", "e-mail", "g mail", "g-mail", "thư điện tử"],
  'gmail',
  branchName: 'Gmail',
  branchLogoPathLightMode: 'assets/icons/brand_icons/gmail_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/gmail_icon.svg',
);

BranchLogo vtc = BranchLogo(
  ['vtc', 'vtc'],
  'vtc',
  branchName: 'VTC',
  branchLogoPathLightMode: 'assets/icons/brand_icons/vtc_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/vtc_icon.svg',
);

//bank

BranchLogo vietcombank = BranchLogo(
  ['vietcombank'],
  'vietcombank',
  branchName: 'Vietcombank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/vietcombank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/vietcombank_icon.svg',
);

BranchLogo sacombank = BranchLogo(
  ['sacombank'],
  'sacombank',
  branchName: 'Sacombank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/sacombank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/sacombank_icon.svg',
);

BranchLogo acb = BranchLogo(
  ['acb'],
  'acb',
  branchName: 'ACB',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/acb_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/acb_icon.svg',
);

BranchLogo bidv = BranchLogo(
  ['bidv'],
  'bidv',
  branchName: 'BIDV',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/bidv_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/bidv_icon.svg',
);

BranchLogo vietinbank = BranchLogo(
  ['vietinbank'],
  'vietinbank',
  branchName: 'Vietinbank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/vietinbank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/vietinbank_icon.svg',
);

BranchLogo techcombank = BranchLogo(
  ['techcombank'],
  'techcombank',
  branchName: 'Techcombank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/techcombank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/techcombank_icon.svg',
);

BranchLogo vib = BranchLogo(
  ['vib'],
  'vib',
  branchName: 'VIB',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/vib_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/vib_icon.svg',
);

BranchLogo momo = BranchLogo(
  ['momo'],
  'momo',
  branchName: 'Momo',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/momo_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/momo_icon.svg',
);

// BranchLogo mb = BranchLogo(
//   ['mb'],
//   'mb',
//   branchName: 'MB',
//   branchLogoPathLightMode: 'assets/icons/brand_icons/banks/mb_icon.svg',
//   branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/mb_icon.svg',
// );

BranchLogo vpbank = BranchLogo(
  ['vpbank', 'vp bank'],
  'vpbank',
  branchName: 'VPBank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/vpbank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/vpbank_icon.svg',
);

BranchLogo maritimebank = BranchLogo(
  ['maritimebank'],
  'maritimebank',
  branchName: 'Msbank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/msb_icon-dark.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/msb_icon-light.svg',
);

BranchLogo agribank = BranchLogo(
  ['agribank'],
  'agribank',
  branchName: 'Agribank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/agribank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/agribank_icon.svg',
);

BranchLogo mbBank = BranchLogo(
  ['mb', "mb_bank", "mb bank"],
  'mb_bank',
  branchName: 'MB Bank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/mb_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/mb_icon.svg',
);

BranchLogo usbank = BranchLogo(
  ['usbank', 'us bank'],
  'usbank',
  branchName: 'US Bank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/usbank_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/usbank_icon.svg',
);

BranchLogo bankofamerica = BranchLogo(
  ['bankofamerica', 'bank of america'],
  'bankofamerica',
  branchName: 'Bank of America',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/bankofamerica_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/bankofamerica_icon.svg',
);

BranchLogo citi = BranchLogo(
  ['citi', 'citibank', 'citi bank'],
  'citi',
  branchName: 'Citi Bank',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/citi_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/citi_icon.svg',
);

BranchLogo visa = BranchLogo(
  ['visa', 'visa card'],
  'visa',
  branchName: 'Visa',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/visa_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/visa_icon.svg',
);

BranchLogo mastercard = BranchLogo(
  ['mastercard', 'master card'],
  'mastercard',
  branchName: 'Mastercard',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/mastercard_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/mastercard_icon.svg',
);

BranchLogo vtcpay = BranchLogo(
  ['vtcpay', 'vtc pay'],
  'vtcpay',
  branchName: 'VTC Pay',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/vtcpay_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/vtcpay_icon.svg',
);

BranchLogo wellsfarge = BranchLogo(
  ['wellsfarge', 'wells farge'],
  'wellsfarge',
  branchName: 'Wellsfarge',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/wellsfargo_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/wellsfargo_icon.svg',
);

BranchLogo pnc = BranchLogo(
  ['pnc', 'pnc bank'],
  'pnc',
  branchName: 'PNC',
  branchLogoPathLightMode: 'assets/icons/brand_icons/banks/pnc_icon.svg',
  branchLogoPathDarkMode: 'assets/icons/brand_icons/banks/pnc_icon.svg',
);
