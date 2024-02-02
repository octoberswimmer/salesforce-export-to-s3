# Run Salesforce Export to S3 on Heroku

Use [ro](https://www.octoberswimmer.com/ro-backup/) to export Salesforce data to S3.

## Set AWS credentials

```
$ heroku config:set AWS_DEFAULT_REGION=us-west-2 AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## Set Salesforce credentials

```
$ heroku config:set RO_ENDPOINT=login.salesforce.com RO_USERNAME=user@example.com RO_PASSWORD=passwordWithToken
```

## Run export on Heroku

```
$ heroku run ./bin/ro --s3-bucket salesforce-org-backups -f parquet --exclude-empty --unzipped --exclude-base64
```

## Run export on Heroku using [Scheduler](https://devcenter.heroku.com/articles/scheduler)

```
$ ./bin/ro --s3-bucket salesforce-org-backups -f parquet --exclude-empty --unzipped --exclude-base64 --quiet
```

## Run export locally

```
$ godotenv -f <(heroku config --shell) ./bin/ro --s3-bucket salesforce-org-backups -f parquet --exclude-empty --unzipped --exclude-base64
```

## Run incremental exports

Export all changes in the previous hour, rounded down to the beginning of the hour.

```
$ ./bin/ro --s3-bucket salesforce-org-backups -f parquet --exclude-empty --unzipped --exclude-base64 -s $(date -d "$(date +%Y-%m-%dT%H:00:00%z) -1 hour" +%Y-%m-%dT%H:%M:%S%z) -o $(date +%Y-%m-%d-%H0000-hourly) Account Contact Lead Opportunity
```
