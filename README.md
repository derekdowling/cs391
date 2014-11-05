cs391
=====

Tools for our big data Elastic Search project

##### Getting Started

### Setting up your environment
run: "./start-es"

### To run scripts:

Use the CLI tool, outlined below to execute any code. Please add new commands, options, etc
into the create_data.rb file in order to make this as reusable as possible.

If you require additional Ruby gems, please add them to the Gemfile and install
with bundle install versus running "gem install blah" manually.

-----------------------------------------------------------------------------
##### Dealing with Git

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
Go to our facebook chat, post the resulting pull request link and let someone
else review/merge it.
----------------------------------------------------------------------------
##### Running the cli

We've written all our our toolage into an easy to use CLI. You can see the available commands
and options by:
```ruby
ruby create_data.rb
```

-----------------------------------------------------------------------------
##### Using the create data script.
Create data generates the number of documents specified.
Examples:
Create 5 documents:
```ruby 
ruby create_data.rb gen 5
```

To use the elastic search driver simply use [--driver]
Example:
Create 5 documents and use a loader:
```ruby
ruby create_data.rb gen --driver gen 5
```
----------------------------------------------------------------------------
##### Profiling Queries
COMING SOON.
