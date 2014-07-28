suite 'pullquoter', ->
  pullquoter = require("../src/pullquoter")
  content = fs.readFileSync("./fixtures/polygon.txt").toString()

  test 'returns a pull quote', ->
    quotes = pullquoter(content, 1)
    eq quotes.length, 1
    eq quotes[0], 'It\'s not just the mechanics of old-school games that Shovel Knight nails, though; it also has that undefinable, metaphysical look and feel of an NES classic.'

  test 'returns top quotes in the order they appear in the document, not raw score order', ->
    quotes = pullquoter(content, 2)
    eq quotes.length, 2
    eq quotes[0], 'Though tons of NES games make up Shovel Knight\'s DNA, the most obvious mechanical comparison is Capcom\'s 1990 platformer DuckTales.'
    eq quotes[1], 'It\'s not just the mechanics of old-school games that Shovel Knight nails, though; it also has that undefinable, metaphysical look and feel of an NES classic.'

  test 'returns one pull quote by default', ->
    quotes = pullquoter(content)
    eq quotes.length, 1

  test 'returns n pull quotes if requested', ->
    quotes = pullquoter(content, 7)
    eq quotes.length, 7

  test 'returns all sentences in document if you request more pull quotes than there are sentences', ->
    quotes = pullquoter(content, 5000)
    eq quotes.length, 34

  test 'handles documents with no text gracefully', ->
    quotes = pullquoter('')
    eq quotes.length, 0

  test 'handles documents with a single sentence', ->
    quotes = pullquoter('blah blah blah.')
    eq quotes.length, 1
    eq quotes[0], 'blah blah blah.'

  test 'handles documents with a single sentence and bad paramters', ->
    quotes = pullquoter('blah blah blah.', 500)
    eq quotes.length, 1
    eq quotes[0], 'blah blah blah.'

  test 'handles documents with two sentences', ->
    quotes = pullquoter('blah blah blah. blah de blah.')
    eq quotes.length, 1
