# Pullquoter

Automatically pull interesting quotes out of an article.

[![Build Status](https://travis-ci.org/ageitgey/node-pullquoter.svg?branch=master)](https://travis-ci.org/ageitgey/node-pullquoter)

You've probably seen [pull quotes](http://en.wikipedia.org/wiki/Pull_quote)
like this in online articles:

![](http://i.imgur.com/LCRetkt.jpg)

Well, until now a *human being* had to spend *several moments* choosing which
quotes to feature. This node module uses basic text summarization techniques to
find interesting sentences to use as pull quotes automatically.

#### Why would I want this?

* Spice up your website with cool pull quotes without any real work
* Make a clone of [Rotten Tomatoes](http://www.rottentomatoes.com/) that is
  totally automated but still has cool review snippets.
* Maybe you are so busy that you only have time to read one sentence of any
  article?

## Credits / Thanks
This node module uses an improved version of the algorithm presented in the
article
[Build your own summary tool!](http://thetokenizer.com/2013/04/28/build-your-own-summary-tool/)
by [Shlomi Babluki](http://thetokenizer.com/). However, this module is improved
in both capability and efficency.

## Install

To install the command-line `pullquoter` utility:

    npm install -g pullquoter

To install the `pullquoter` module for use in your Node.js project:

    npm install --save pullquoter

## Usage

You can use `pullquoter` from node or right on the command line!

### Command line interface

You can pass text to pullquoter and it will pull out interesting sentences.

You can either pass in a file name:

```
pullquoter my_file.txt
```

Or you can pipe it in:

```
cat my_file.txt | pullquoter
```

By default, it returns one interesting sentence.  If you want more,
use the `-n` parameter:

```
pullquoter -n 10 my_file.txt
```

You can easily chain this together with other unix commands to do cool stuff.
For example, you can download a web page, and then use
[unfluff]() to grab the page text and
[jq](http://stedolan.github.io/jq/) to pull out the body test.  Then just pass
it to pullquoter and get sentences!

```
curl -s "http://www.polygon.com/2014/6/26/5842180/shovel-knight-review-pc-3ds-wii-u" | unfluff | jq -r .text | pullquoter
```
```
It's not just the mechanics of old-school games that Shovel Knight nails, though; it also has that undefinable, metaphysical look and feel of an NES classic.
```

### Module Interface

#### `pullquoter(text, numberOfQuotesToPull)`

text: The text you want to parse. This should be plain text in English.

numberOfQuotesToPull (default: 1): The number of sentences to pull out of the
article

```javascript
pullquoter = require('pullquoter');

quotes = pullquoter(myText);
```

Or pass in how mant quotes you want:

```javascript
pullquoter = require('pullquoter');

quotes = pullquoter(myText, 10);
```

## Limitations / Problems / TODO

* This only works for English. The stopwords, stemmer and tokenized currently only support English. It could be     expanded for other western languages pretty easily, though.
* This module has a runtime of something like O(n^2/2) where n is the number of sentences in the text. So maybe don't run it on a huge piece of text.
* If you are doing something serious, maybe look into a [better text summarization algorithm](http://en.wikipedia.org/wiki/Automatic_summarization#Methods).
