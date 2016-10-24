# Impact

Impact is a Ruby on Rails 4.2.x application with the following system
dependencies:

**Dependencies**
* Ruby 2.3.0
* PostgreSQL
* AWS S3
* Redis
* Elasticsearch

## Development

**Configuring Your Hosts File**
IMPACT uses subdomains, which means you will need to configure your etc/hosts file (on OSX) for the app to run. You can also use Pow if you're familiar with it - it is much easier in general and it is highly recommended that you use it **if** you know how. Otherwise, open your finder on your Mac, then click 'go' in the top toolbar, then paste etc/hosts into "go to folder" and proceed from there. IMPACT listens at port 5000, which means you should add this to the file:

`0.0.0.0     impact.dev  #for IMPACT's homepage`
`0.0.0.0     test-01.impact.dev  #for your own site`

What does "#for your own site" mean? Keep in mind that when you create a user and sign-in, you'll need to create a business to start using IMPACT. That business will get its own subdomain, and this will need to be reflected in your hosts file. The nomenclature for your etc/hosts file should match the name of your business. Therefore, the second entry above could just as easily be "test0001.impact.dev" or "foo.impact.dev" if the business created was "test0001" or "foo". Your hosts file just needs to know what the subdomain is.

**Setting Up Your Environment Variables**
Make sure to set the following ENV variables in a `.env` file:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_S3_BUCKET`
* `AWS_S3_REGION`

See **Setting Up AWS** for more information on acquiring the necessary
credentials.

Ensure the `foreman` gem is installed and start the application with:

`foreman start`

To create all indices for the first time, run:

`rake environment elasticsearch:import:all FORCE=y`

To create a single index for a newly added model `Widget`, run:

`rake environment elasticsearch:import:model CLASS=Widget FORCE=y`

To refresh the indices at a later time, run:

`rake environment elasticsearch:import:all`

**What You Need Running in Terminal**
As indicated by the dependencies listed earlier, you will need to have ElasticSearch and Redis running for the app to work. If you do not have these installed, do so, preferably using Homebrew where applicable. You should also be passingly familiar (at least) with what ElasticSearch and Redis do and how they work. This is especially relevant for ElasticSearch, as it is leveraged in the app extensively and a fundamental knowledge of how it works and how to manipulate it will save you time and frustration. Please keep in mind that IMPACT does **not** use SearchKick to handle ElasticSearch. If you're only familiar with SearchKick, read the documentation on the gems used for ES in IMPACT. It should make sense after a read through or two.

Once you have completed the above (the dependencies installed; your host file configured; your AWS configured and env variables set and ElasticSearch indices created, etc.), cd to your root Rails folder in Terminal. Open up a few tabs. In one tab, run the command:

`elasticsearch`

In another tab, run:

`redis-server`

Finally, as detailed earlier, run:

`foreman start`

Keep in mind that the usual "rails -s" command is not necessary when you are using Foreman. If you don't know why, please spend time reading what Foreman is, and how it works. 

Foreman does not print server logs automatically like rails -s will. Here is the Terminal command to print out server logs (open a new tab in your Rails app's root directory for this):

`tail -f log/development.log`

Provided you have completed all the steps mentioned up to this point in the documentation (including setting up AWS), you should be able to point your browser to http://impact.dev:5000/ and have the homepage properly rendered. Don't forget to create a database, run migrations, and all the other fundamentals of installing a Rails app locally. Once you get all this set-up you'll also need to get a super admin set-up via terminal as well. Do this, then log in and proceed to create a business.

## Test

Make sure to set the following ENV variables in a `.env.test` file:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_S3_BUCKET`
* `AWS_S3_REGION`

See **Setting Up AWS** for more information on acquiring the necessary
credentials.

Run the test suite with:

`rake test`

## Staging/Production

Impact is hosted on Heroku. Create a new Heroku app in the standard US region.
This README uses the name `impact-staging`.

Add the following free addons:

* Heroku Postgres
* Heroku PGBackups (auto one-month)
* Memcached Cloud
* Redis To Go
* Bonsai

Open the Heroku application settings and the following config variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_CLOUDFRONT_HOST`
* `AWS_S3_BUCKET`
* `AWS_S3_REGION`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_SES_SMTP_ADDRESS`
* `AWS_SES_SMTP_PASSWORD`
* `AWS_SES_SMTP_PORT`
* `AWS_SES_SMTP_USERNAME`
* `HOST`
* `REDIS_PROVIDER`
* `SUPPORT_EMAIL`

See **Setting Up AWS** for more information on acquiring the necessary
credentials.

Set `HOST` to the primary application host (e.g. `impact-staging.herokuapp.com` or
`impact-staging.com`)

Set `REDIS_PROVIDER` equal to the value `REDISTOGO_URL`.

Set `SUPPORT_EMAIL` to the desired "from" email field.

Additionally, `SECRET_KEY_BASE` is required, but will automatically be populated
by Heroku.

Once everything is in place, start the application by pushing its repository to
Heroku. From the command line in the application directory, run the following
command to add the remote "heroku" git branch to your local repository:

`heroku git:remote -a impact-staging`

Push the application to Heroku:

`git push heroku master`

Once the push is complete, migrate and seed the database with the initial
catgories list:

```
heroku run rake db:migrate
heroku run rake db:seed
```

Then ensure the indices are created by running:

`rake environment elasticsearch:import:all FORCE=y`

Ensure that a worker dyno is running:

`heroku ps:scale worker=1`

The application is now live. Open the application in your default web browser
with:

`heroku apps:open`

## Setting Up AWS

Impact relies on AWS S3 for uploading images and serving static production
assets.

Each application instance (i.e. "development", "test", "staging", "production")
should reference their own unique database and bucket.

### AWS S3

Following the naming convention used in the Heroku app, create a new AWS S3
bucket in the US East region with the name "impact-staging". Set the
`AWS_S3_REGION` and `AWS_S3_BUCKET` ENV variables to `us-east-1` and
`impact-staging`, respectively.

The bucket CORS policy will also need to modified so that we can perform
presigned client-side posts as well as serve font assets across CDN domains.

Under "Permissions", "Edit CORS Configuration", clear what is present, and paste
the following:

```
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <CORSRule>
    <AllowedOrigin>http://impact-staging.herokuapp.com</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
  </CORSRule>
  <CORSRule>
    <AllowedOrigin>http://www.impact-staging.com</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
  </CORSRule>
</CORSConfiguration>
```

There should be one `CORSRule` entry for each domain that the application is
expected to be served on.

Navigate to AWS IAM service and add a new user with the name:

`s3-impact-staging`

Make sure to view and copy or download the user credentials.

* "Access Key ID" is the ENV variable "AWS_ACCESS_KEY_ID"
* "Secret Access Key" is the ENV variable "AWS_SECRET_ACCESS_KEY"

To enable the newly created user to access the required resources, add a "Inline
Policy" of type "Custom Policy". Name the policy
`allow-all-on-s3-impact-staging` and set the policy document to:

```
{
  "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::impact-staging",
                   "arn:aws:s3:::impact-staging/*"]
    }
  ]
}
```

This completes the AWS setup for the "development" and "test" environments.

For "staging" and "production" environments, a Cloudfront distribution and SES
service will also need to be setup.

### AWS Cloudfront

To serve assets from a CDN, create an AWS Cloudfront web distribution. Under
"Origin Domain Name" select the S3 bucket from the dropdown list.

Change the "Forward Headers" option to "Whitelist" and add all three default
headers to the whitelist ("Access-Control-Request-Headers",
"Access-Control-Request-Method", and "Origin").

Create the distribution and record its domain name as the `AWS_CLOUDFRONT_HOST`
ENV variable.

### AWS SES

Finally, Impact uses AWS SES to deliver transactional SMTP email. Navigate to
the US East region of the SES service. Under SMTP settings, record the "Server
Name" field and the "Port" field as the `AWS_SES_SMTP_ADDRESS` and the
`AWS_SES_SMTP_PORT` ENV variables.

Click "Create My SMTP Credentials", "Create" and then record the username and
password as the `AWS_SES_SMTP_USERNAME` and `AWS_SES_SMTP_PASSWORD` ENV
variables.

Finally, ensure that the support email ENV variable is either listed under
"Verified Addresses" or that the email domain is a verified domain.

For best results, "Request Production Access".

## Commit Process

DO NOT COMMIT DIRECTLY TO DEV OR MASTER

To begin work on IMPACT, checkout the `dev` branch and run `git pull origin dev`
to get a fresh copy of the dev branch.

Checkout a new feature branch, identified by the work you are doing (presumably a
Pivotal Tracker ID#). For example:

`git checkout -b 123456_update_widget`

Ensure all tests pass and commit your changes. Once you have been instructed to
merge your branch into dev, first checkout the `dev` branch and ensure it is
up-to-date: `git pull origin dev`.

Then checkout your feature branch and rebase it against dev:

```
git checkout 123456_update_widget
git rebase dev
```

Now that your feature branch is freshly rebased against the dev branch, checkout
`dev` and merge in your work.

```
git checkout dev
git merge 123456_update_widget
```

There should NOT BE ANY merge conflicts. Push the updated dev branch to origin:

`git push origin dev`
