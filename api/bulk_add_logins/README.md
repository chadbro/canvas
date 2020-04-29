# Bulk Update Canvas Login Passwords

## General Information

This script takes a list of Canvas users and creates another login under their profile (user account).

Documentation on the Logins API endpoint: https://canvas.instructure.com/doc/api/logins.html

## Required Ruby Gems

There are several ruby gems that you will need to have installed in order to run this script. Instructions to install are as follows:

gem install typhoeus # Helps with making the API calls and concurrency gem install json # Assists in parsing the data from the API call

## Using the Script

Before running this script, you'll need to modify the four variables at the beginning of the file:

domain = '' # e.g. 'domain' in 'https://domain.instructure.com'
token = ''  # api token for account admin user
env = ''	#Either blank for prod, or type test or beta
csv = ''    # Use the full path /Users/XXXXX/Path/To/File.csv

## CSV Files

The csv_file should follow the format of the provided csv example file:

canvas_user_id  login_id    user_id     authentication_provider_id
12345	example@example.com	asdfasdf canvas
The first three columns can be obtained by running an SIS Provisioning Report and copying the canvas_user_id, login_id, and user_id columns.

Feel free to comment out line 35 if no sis_user_id is being assigned (user_id from CSV)