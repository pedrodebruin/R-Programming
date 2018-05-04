# You may need to do install httpuv for the authentication:
# install.packages("httpuv")

library(httr)


# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "3d85a4fd01091898be58",
                   secret = "708aebac15416cdda333f1e4dc1c9d1562aefbdf")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

## 4. Use API
gtoken <- config(token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
# OR:
#req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
#stop_for_status(req)


content(req)

json1 <- content(req)
json2 <- jsonlite::fromJSON(jsonlite::toJSON(json1))

colnames(json2)

DFdatasharing <- json2[14,]
DFdatasharing$created_at
