# Run Salesforce Export to S3 on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Use [ro](https://www.octoberswimmer.com/ro-backup/) to export Salesforce data to S3.

## Installation

Use the [Deploy to Heroku](https://heroku.com/deploy) button above to create a copy of the app.

## Set AWS credentials

```
$ heroku config:set AWS_DEFAULT_REGION=us-west-2 AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Set S3 Bucket

```
$ heroku config:set S3_BUCKET=my-bucket
```

## Set Salesforce credentials

```
$ heroku config:set RO_ENDPOINT=login.salesforce.com RO_USERNAME=user@example.com RO_PASSWORD=passwordWithToken
```

## Run export on Heroku

```
$ heroku run ./bin/ro --s3-bucket $S3_BUCKET -f parquet --exclude-empty --unzipped --exclude-base64
```

## Run export on Heroku using [Scheduler](https://devcenter.heroku.com/articles/scheduler)

Install free scheduler addon:

```
$ heroku addons:create scheduler:standard
```

Configure data export job:

```
$ heroku addons:open scheduler
```

Example exporting to individual parquet files, one per object:

```
$ ./bin/ro --s3-bucket $S3_BUCKET -f parquet --exclude-empty --unzipped --exclude-base64 --quiet
```

## Run export locally

```
$ godotenv -f <(heroku config --shell) ./bin/ro --s3-bucket my-bucket -f parquet --exclude-empty --unzipped --exclude-base64
```

## Run incremental exports

Export all changes in the previous hour, rounded down to the beginning of the hour.

```
$ heroku run ./bin/ro --s3-bucket $S3_BUCKET -f parquet --exclude-empty --unzipped --exclude-base64 -s $(date -d "$(date +%Y-%m-%dT%H:00:00%z) -1 hour" +%Y-%m-%dT%H:%M:%S%z) -o $(date +%Y-%m-%d-%H0000-hourly) Account Contact Lead Opportunity
```

## Export Metadata

Split up metadata into multiple exports if needed to avoid the 10,000 component limit.

```
$ force login -i $RO_ENDPOINT -u $RO_USERNAME -p $RO_PASSWORD
$ force export metadata -x Report -x Dashboard
$ force fetch -d metadata -t Report -t Dashboard
$ s3-cli put --recursive --verbose metadata s3://S3_BUCKET/metadata/$(date +%Y-%m-%d-%H%M%S)
```
