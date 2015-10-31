### RDD

A solution to [Resume Driven Development challenge](https://gist.github.com/coryodaniel/61a2ebf7fe5086b69f36)

#### Setup

###### Environment Variables

This project uses the service called Big Query. You need to setup these environment variables in the `.env` file in order to communicate with this service. All variables can be found in [Google Developer Console](https://console.developers.google.com). Put your certificate in the `certs` folder.

Here is the list of Big Query variables in `.env`

```
BIG_QUERY_CLIENT_ID = 'your_client_id'
BIG_QUERY_SERVICE_EMAIL = 'your_service_email'
BIG_QUERY_KEY_FILE_NAME = 'your_certificate_filename.p12'
BIG_QUERY_PROJECT_ID = 'your_project_id'
BIG_QUERY_DATASET = 'github dataset url' # for example: https://bigquery.cloud.google.com/table/githubarchive:day.events_20150101
```

###### Installation

```
gem install bundler
bundle
rake # make sure all tests pass
```

#### Running

```
$ rdd --after 2015-10-15T20:10:02-00:00 --top 20
Getting Github statistics for 2015-10-15 - 2015-10-31T15:27:39-07:00
Results (~8 seconds):
rdpeng/ProgrammingAssignment2 - 14013 points
jtleek/datasharing - 12353 points
octocat/Spoon-Knife - 10745 points
FreeCodeCamp/FreeCodeCamp - 6739 points
herrbischoff/awesome-osx-command-line - 6336 points
basecamp/trix - 6335 points
jwagner/smartcrop.js - 5919 points
kubernetes/kubernetes - 5423 points
twbs/bootstrap - 5009 points
No-CQRT/GooGuns - 4842 points
gabrielbull/react-desktop - 4186 points
Homebrew/homebrew - 4132 points
butterproject/butter - 4061 points
JohnCoates/Aerial - 3643 points
facebook/react-native - 3551 points
rdpeng/RepData_PeerAssessment1 - 3477 points
docker/docker - 3378 points
una/CSSgram - 3253 points
angular/angular.js - 3246 points
cmusatyalab/openface - 3219 points
```
