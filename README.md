cs391
=====

Tools for our big data Elastic Search project

Getting Started
-----------------------------------------------------------------------------
### Setting up your environment
run: "./start-es"

### To run scripts:

Use the CLI tool, outlined below to execute any code. Please add new commands, options, etc
into the cli.rb file in order to make this as reusable as possible.

If you require additional Ruby gems, please add them to the Gemfile and install
with bundle install versus running "gem install blah" manually.

Dealing with Git
-----------------------------------------------------------------------------
### Navigating to a branch
"git checkout branch_name"

### Create your own branch:
From the branch you want to branch off of:
"git checkout -b"

### Saving Changes To A Branch
git add file_name
git commit -m "Your change message"
git push origin YOUR_BRANCH_NAME

### Merging your changes to master:
Go here: https://github.com/derekdowling/cs391/pulls
Click "New pull request"
Set "base" to master set "compare" to your branch name
Go to our facebook chat, post the resulting pull request link and let someone else review/merge it.

Running the CLI
----------------------------------------------------------------------------
We've written all our our toolage into an easy to use CLI. You can see the available commands
and options by:
```ruby
ruby cli.rb
```

Using the create data script.
-----------------------------------------------------------------------------
Create data generates the number of documents specified.
Examples:
Create 5 documents:
```ruby 
ruby cli.rb gen 5
```

To use the elastic search driver simply use [--driver]
To profile the command use [--profile]]
Example:
Create 5 documents and use a loader:
```ruby
ruby cli.rb gen --driver gen 5
```
Types of Data that can be generated:
float: any float between 0 and 10,000.00
int: any integer between 0 and 100,000
small_int: any integer between 0 and 100
string: 20 random character
ip: IPv4 address
credit_card_type: (Ex) visa
ein: employee ID
duns_num: duns number, a number given to a company
id: a 13 digit id number

Self explanatory types:
address, name, city, phone_num, email, country
latitude, longitude, zip, credit_card_num,
credit_card_expiry_date, company, date, time, job_title

Profiling Queries
----------------------------------------------------------------------------
COMING SOON.
