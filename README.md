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

Create 100 documents:
```ruby
ruby cli.rb gen 5
```

To generate documents and put them on the cluster: [--cluster] or [-c]
Example:
Create 5 documents and put them on the cluster:
```ruby
ruby cli.rb gen 5 -c
```
To generate documents on your local node: [--local] or [-l]
Create 5 documents on localhost:
```ruby
ruby cli.rb gen -l 5
```

Profiling Queries
----------------------------------------------------------------------------

####To run a search query (on the cluster add "-c"):

```ruby
ruby cli.rb search <index> <query_file> -c
```

####Indices:

There are two indices to choose from:

1) Transactions
    For this index, our documents contain nested maps of values.

2) Flat Transactions
    For this index, our documents contain the same level, except each value
    is at the root of the document.

0) Query through the database and returns matches where 'fees' are both greater then or equal to 1000,
and less then 5000. Groups by country and orders by alphabetically.
1) Find all *unique* source accounts located in the USA and order by account type in ascending order.
2) For all transactions numbered between 500 and 10000, find the largest input amount
3) Find all transactions using a priority code less or equal to 10, group by priority code, and take the average
 input amount
4) Find all transactions coming out of Paris, FR and going to New York, USA that have an input amount of less
than $20,000, are from a Visa, and from the business Sears. Do not display results from the branch
number 123, 456, 789, or 000.
