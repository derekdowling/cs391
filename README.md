cs391
=====

Tools for our big data Elastic Search project

##### Getting Started

### Setting up your environment
run: "./start-es"

### To run scripts:

ruby YOUR_FILE_NAME.rb

BOOM DONE.

If you require additional Ruby gems, please add them to the Gemfile and install
with bundle install versus running "gem install blah" manually.
D

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

-----------------------------------------------------------------------------
##### Using the create data script.
Create data generates the number of documents specified.
Examples:
Create 1 document: ruby create_data.rb gen 1
Create 5 documents: ruby create_data.rb gen 5

To use a loader simply use [--loader]
Example:
Create 5 documents and use a loader: ruby create_data.rb gen --loader gen 5

----------------------------------------------------------------------------

