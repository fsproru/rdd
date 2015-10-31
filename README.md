### RDD

A solution to [Resume Driven Development challenge](https://gist.github.com/coryodaniel/61a2ebf7fe5086b69f36)

#### Setup

##### Environment Variables

This project uses the service called Big Query. You need to setup these environment variables in the `.env` file in order to communicate with this service. All variables can be found in [Google Developer Console](https://console.developers.google.com). Put your certificate in the `certs` folder.

Here is the list of Big Query variables in `.env`

```
BIG_QUERY_CLIENT_ID = 'your_client_id'
BIG_QUERY_SERVICE_EMAIL = 'your_service_email'
BIG_QUERY_KEY_FILE_NAME = 'your_certificate_filename.p12'
BIG_QUERY_PROJECT_ID = 'your_project_id'
BIG_QUERY_DATASET = 'github dataset url' # for example: https://bigquery.cloud.google.com/table/githubarchive:day.events_20150101
```

##### Installation

```
gem install bundler
bundle
rake # make sure all tests pass
```

#### Running

```
bin/rdd
```
