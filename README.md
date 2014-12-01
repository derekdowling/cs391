# cs391
=====

Tools for our big data Elastic Search project

Getting Started
------

Use the CLI tool, outlined below to execute any code. Please add new commands, options, etc
into the cli.rb file in order to make this as reusable as possible.

```
ruby cli.rb
```

If you require additional Ruby gems, please add them to the Gemfile and install
with bundle install versus running "gem install blah" manually.

Dealing with Git
-----------------------------------------------------------------------------
### Navigating to a branch

```
"git checkout branch_name"
```

### Create your own branch:
From the branch you want to branch off of:

```
"git checkout -b"
```
### Saving Changes To A Branch

```
git add file_name
git commit -m "Your change message"
git push origin YOUR_BRANCH_NAME
```

### Merging your changes to master:
Go here: https://github.com/derekdowling/cs391/pulls
Click "New pull request"
Set "base" to master set "compare" to your branch name
Go to our facebook chat, post the resulting pull request link and let someone else review/merge it.

### Running the CLI

We've written all our our toolage into an easy to use CLI. You can see the available commands
and options by:

```
ruby cli.rb
```

Creating Data
-----
Create data generates the number of documents specified.

Examples:

Create 100 documents and print to console:

```
ruby cli.rb gen transactions nested_manifest.json 100
```

To generate documents and put them on the cluster: [--cluster] or [-c]
Example:

Create 100 documents and put them on the cluster:

```
ruby cli.rb gen transactions nested_manifest.json 100 -c
```
To generate 100 documents on your local node: [--local] or [-l]

```
ruby cli.rb gen transactions nested_manifest.json 100 -l
```

Profiling Searces/Queries
----------------------------------------------------------------------------

To run a search query on the cluster:

```
ruby cli.rb search <index> <query_file> -c
// example:
ruby cli.rb search transactions flat_queries.json -c
```

#### Indices:

There are two indices to choose from:

A) Transactions
    For this index, our documents contain nested maps of values.

B) Flat Transactions
    For this index, our documents contain the same level, except each value
    is at the root of the document.

#### Queries:

There are five different queries to execute. You can execute a specific one on
the cluster by running:

```
ruby cli.rb search transactions nested_queries.json -c -q <query_index>
```

Index) Query

0) Query through the database and returns matches where 'fees' are both greater then or equal to 1000,
and less then 5000. Groups by country and orders by alphabetically.

1) Find all *unique* source accounts located in the USA and order by account type in ascending order.

2) For all transactions numbered between 500 and 10000, find the largest input amount

3) Find all transactions using a priority code less or equal to 10, group by priority code, and take the average
 input amount

4) Find all transactions coming out of Paris, FR and going to New York, USA that have an input amount of less
than $20,000, are from a Visa, and from the business Sears. Do not display results from the branch
number 123, 456, 789, or 000.
