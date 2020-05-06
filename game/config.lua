-- CONFIG
application = {
    showRuntimeErrors = false, -- false ON PRODUCTION
	content = {
		width = 320,
		height = 480,
		fps = 60,
        antialias = false,
		scale = "zoomEven",
		audioPlayFrequency = 22050,
        imageSuffix = {
		    ["@2x"] = 1.5,
		    ["@4x"] = 3.0,
		},
	},
	notification = {
        iphone = {
            types = { "badge", "sound", "alert" }
        },
    },
	license = {
        google = {
			-- GOOGLE PLAY LICENSE (FOUND IN SERVICES AND APIs OF APP in https://play.google.com/apps/publish)
            key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo1DAUCWqtyL78WRK3aSeCutU08voYLosqD+reqJZ1z/ud3VZKxHIeKd0FXVTcKn2OgjOhkBBEnWfPe9P1MKiZ5BllnjueBCXojsJRfMbFfigRjEWY1Gtj6QvNtvQ1bSz/ru1gMwFiJt+pSEttkYwZTddGGLSPgxztgxRBtTIusFQECVhlHoVd/+0VGdDhF2JYkgOfTxu4bSV/s4Ktx18Uc7KlJyEVNFhl7V70DcodzNfPVngqlwSCQyxke6QT0YK/d+Axz/1bDdylryOMeNYM0hV6zCj3QhjCxEQtPK84byrat4LePzY4IHelXz6Q0iMGn2aHEf/Tjbi9klsM7ZDwwIDAQAB",
        },
    },
}