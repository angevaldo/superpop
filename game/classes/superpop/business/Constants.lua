local Constants = {


	-- TABLE SCORES RANKING 
	TBL_IDS_SCORES_NETWORK = { -- ID ANDROID GOOGLE PLAY   OR   ID APPLE APPSTORE
	    Splash = system.getInfo( "platformName" ) == "Android" and "CgkI6s_fh_QKEAIQDA" or "com.ajtechlabs.games.superpop.highscoreSplash",
	    Timer = system.getInfo( "platformName" ) == "Android" and "CgkI6s_fh_QKEAIQDQ" or "com.ajtechlabs.games.superpop.highscoreTimer",
	    Bomb = system.getInfo( "platformName" ) == "Android" and "CgkI6s_fh_QKEAIQDg" or "com.ajtechlabs.games.superpop.highscoreBomb",
	},

	-- IN-APP PURCHASE
	TBL_IAP_THEMES_FRAMES = { {1,1}, {2,2}, {3,4}, {5,6}, {7,8}, {9,10}, {11,12} }, -- {INACTIVE FRAME, ACTIVE FRAME}
	TBL_IAP_THEMES = { -- ID, PRICE (1 AND 2 NOT NECESSARY)
	    {"com.ajtechlabs.games.t01", ""}, 				-- DAY GARDEN THEME
	    {"com.ajtechlabs.games.t02", ""}, 				-- SUNSET GARDEN THEME
	    {"com.ajtechlabs.games.t03", "US$ 0,99"}, 		-- NIGHT GARDEN THEME
	    {"com.ajtechlabs.games.t04", "US$ 0,99"}, 		-- CHRISTMAS THEME
	    {"com.ajtechlabs.games.t05", "US$ 0,99"}, 		-- FITNESS THEME
	    {"com.ajtechlabs.games.t06", "US$ 0,99"}, 		-- STARS THEME
	    {"com.ajtechlabs.games.t07", "US$ 0,99"}, 		-- BEACH THEME
	},
	TBL_IAP_PRODUCTS = { -- ID, PRICE, LABEL
	    {"com.ajtechlabs.games.remove_a", "US$ 4,99", "REMOVE ADS"},
	    {"com.ajtechlabs.games.all_t", "US$ 5,99", "ALL THEMES"},
	    {"com.ajtechlabs.games.remove_a_and_all_t", "US$ 9,99", "REMOVE ADS + ALL THEMES"},
	},

	-- SOCIAL - FACEBOOK & TWITTER
	STR_URL_FACEBOOK_PAGE = "https://www.facebook.com/thesuperpop",
	STR_URL_TWITTER_ACCOUNT = "https://twitter.com/superpopthe",
	STR_SOCIAL_SHARE_MESSAGE = "Can you beat me? ",

	-- APPLOVIN ADVERTISING (https://www.applovin.com)
	STR_KEY_APPLOVIN_AD = "T2H88S6B426g6f6fDTv2x15Nvi51_SGXVXge_nq3pxkvbrZpJSrFTxcMdiOcAf9fCqIBb7FO3zIfpsS6JILnEz",
	STR_MESSAGE_ASK_WATCH_AD_TO_CONTINUE = "Watch the video to get an extra life?",
	NUM_GAMES_PLAYED_TO_SHOW_AD = 5,
	NUM_COINS_REWARDED_VIDEO_AD = 10,
	NUM_WAIT_MILLISECONDS_TO_HIDE_AD_IF_NOT_SHOW = 1000,

	-- RATE US
	NUM_COINS_REWARDED_TO_RATE_US = 300,
	NUM_GAMES_PLAYED_TO_ASK_RATE_US = 10,
	STR_ASK_TO_RATE_US = "Liked? Rate us and get",
	STR_IOS_APP_ID_TO_RATE = "1046407013",
	TBL_SUPPORTED_ANDROID_STORES_TO_RATE = { "google" },



	-- FONT STYLE
	TBL_STYLE = {
	    COLOR = {1,1,1 ,1}, 
	    COLOR_FOCUS = {1,0,0 ,1}, 			
	    COLOR_POSITIVE = {0,1,0 ,1}, 	
	    COLOR_NEGATIVE = {1,0,0 ,1}, 	
	    COLOR_COINS = {1,.85,0 ,1},		
	    FAMILY = "Chewy",				
	},

	-- INTRO
	BOL_IS_TO_SHOW_INTRO_STORY = true,

	-- NOTIFICATIONS
	NUM_DAYS_WITHOUT_PLAY_TO_MISS_YOU_MESSAGE_NOTIFICATION = 5,
	STR_MISS_YOU_MESSAGE_NOTIFICATION = "We miss you! Let's pop something!",
	STR_NEW_GIFT_MESSAGE_NOTIFICATION = "There are a new gift for you!",

	-- FREE COINS GIFT ( {SECONDS TO WAIT, COINS GIFTED} )
	TBL_GIFTS = { {0,350},{60,200},{300,100},{600,50},{1200,25},{2400,20},{4800,20},{7200,20},{14400,20},{28800,15},{57600,15},{86400,10} },

	-- BONUS THEME
	NUM_FIRST_BONUS_THEME_ID = 6,
	NUM_COINS_COLLECTED_TO_BONUS_THEME = 500,

	-- RANKING
	NUM_FRIENDS_TO_LOAD_RANKING = 2,
	STR_ALIAS_ME_RANKING = "Me",
	STR_ALIAS_UNKNOW_RANKING = "Unknown",

	-- GAMEPLAY CONFIGURATIONS
	NUM_SCREEN_PADDING_HORIZONTAL = 20,
	NUM_SCREEN_PADDING_VERTICAL = 40,
	NUM_SCORE_MAX_FOR_EACH_PARTICLE = 10,
	NUM_SCORE_INTERVAL_TO_SPLASH_BONUS_BOMB_MODE = 200,
	NUM_SCORE_MIN_TO_CONTINUE = 99,
	NUM_SCORE_BOMB_PENALTY = -50,
	NUM_TIME_COLLECT_BONUS = 3,

	-- SCREEN BORDER PADDING (CALCULATING BASED ON DEVICE)
	TOP = display.screenOriginY + 15,
	LEFT = (display.contentWidth - display.actualContentWidth) * .5 + 15,
	RIGHT = display.actualContentWidth + (display.contentWidth - display.actualContentWidth) * .5 - 15,
	BOTTOM = display.actualContentHeight + (display.contentHeight - display.actualContentHeight) * .5 - 15,


}

return Constants