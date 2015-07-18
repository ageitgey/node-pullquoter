'use strict'

assert = require('assertive')
fs = require('fs')

describe 'pullquoter', ->
  pullquoter = require('../src/pullquoter')
  content = fs.readFileSync('./fixtures/polygon.txt').toString()

  it 'should return a pull quote', ->
    quotes = pullquoter(content, 1)
    assert.equal quotes.length, 1
    assert.equal quotes[0], 'It\'s not just the mechanics of old-school games that Shovel Knight nails, though; it also has that undefinable, metaphysical look and feel of an NES classic.'

  it 'should return top quotes in the order they appear in the document, not raw score order', ->
    quotes = pullquoter(content, 2)
    assert.equal quotes.length, 2
    assert.equal quotes[0], 'Though tons of NES games make up Shovel Knight\'s DNA, the most obvious mechanical comparison is Capcom\'s 1990 platformer DuckTales.'
    assert.equal quotes[1], 'It\'s not just the mechanics of old-school games that Shovel Knight nails, though; it also has that undefinable, metaphysical look and feel of an NES classic.'

  it 'should return one pull quote by default', ->
    quotes = pullquoter(content)
    assert.equal quotes.length, 1

  it 'should return n pull quotes if requested', ->
    quotes = pullquoter(content, 7)
    assert.equal quotes.length, 7

  it 'should return all sentences in document if you request more pull quotes than there are sentences', ->
    quotes = pullquoter(content, 5000)
    assert.equal quotes.length, 34

  it 'should handle documents with no text gracefully', ->
    quotes = pullquoter('')
    assert.equal quotes.length, 0

  it 'should handle documents with a single sentence', ->
    quotes = pullquoter('blah blah blah.')
    assert.equal quotes.length, 1
    assert.equal quotes[0], 'blah blah blah.'

  it 'should handle documents with a single sentence and bad paramters', ->
    quotes = pullquoter('blah blah blah.', 500)
    assert.equal quotes.length, 1
    assert.equal quotes[0], 'blah blah blah.'

  it 'should handle documents with two sentences', ->
    quotes = pullquoter('blah blah blah. blah de blah.')
    assert.equal quotes.length, 1
