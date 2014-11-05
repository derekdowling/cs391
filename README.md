cs391
=====

Tools for our big data Elastic Search project

##### Getting Started

Install dependencies:
bundle install

To run scripts:

ruby YOUR_FILE_NAME.rb

BOOM DONE.

If you require additional Ruby gems, please add them to the Gemfile and install
with bundle install versus running "gem install blah" manually.

##### Using the create data script.
Create data generates the number of documents specified.
Examples:
Create 1 document: ruby create_data.rb gen 1
Create 5 documents: ruby create_data.rb gen 5

To use a loader simply use [--loader]
Example:
Create 5 documents and use a loader: ruby create_data.rb gen --loader gen 5
