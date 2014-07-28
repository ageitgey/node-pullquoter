math = require('mathjs')
natural = require('natural')
stopwords = require('stopwords').english
memoize = require('memoizee')
_ = require("lodash")

module.exports = pullquoter = (content, numberOfQuotes = 1) ->
  sentences = splitIntoSentences(content)
  sentenceScores = scoreSentences(sentences)
  getTopSentences(sentences, sentenceScores, numberOfQuotes)


# Split raw text into an array of sentences
splitIntoSentences = (content) ->
  content = content.replace("\n", ". ")
  sentences = content.match(/(.+?[\.|\!|\?](?:\s|$))/g) or []

  _.map sentences, (sentence) ->
    sentence.trim()

# Strip stopwords from a sentence and return a list of stemmed tokens
tokenizeSentence = (s) ->
  tokenizer = new natural.WordPunctTokenizer();
  words = tokenizer.tokenize(s.toLowerCase());
  words = _.difference(words, stopwords)
  tokens = natural.PorterStemmer.tokenizeAndStem(words.join(' '))
  tokens

# Calculate the 'similarity' of two sentences by counting the
# number of commontokens between the two sentences
# (normalized by the length of the sentences)
sentenceSimilarity = (s1, s2) ->
  if (s1.length + s2.length) == 0
    return 0

  # Find the overlapping tokens in both sentences
  numberOfOverlappingTokens = _.intersection(s1, s2).length

  # Normalize the # of overlapping tokens based on the average
  # length of the two sentences to make it fair
  avgSentenceTokenLength = ((s1.length + s2.length) / 2)

  numberOfOverlappingTokens / avgSentenceTokenLength

scoreSentences = (sentences) ->
  memoizedSimilarity = memoize(sentenceSimilarity)
  k = sentences.length
  return [ ] if k <= 0
  return [0] if k == 1

  tokenizedSentences = _.map(sentences, tokenizeSentence)

  # Find the similarity between each sentence and store in a matrix
  values = math.zeros(k, k).map (value, index, matrix) ->
    return 0 if index[0] == index[1]

    s1 = tokenizedSentences[index[0]]
    s2 = tokenizedSentences[index[1]]

    # keep sentence order consistent for memoization
    if s2 < s1
      [s1, s2] = [s2, s1]

    memoizedSimilarity(s1, s2)

  # Sum the total scores of each row in the matrix.
  # Mathjs doesn't support dimentional sums of vectors,
  # so fake it with matrix multiplication.
  scores = math.multiply(values, math.ones(k))

  # Return just a single vector of scores. This seems the be the
  # quickest way to get a js array out of a mathjs vector.
  return scores._data

getTopSentences = (sentences, sentenceScores, n) ->
  sentenceObjects = _.map sentences, (s, i) ->
    {
      sentence: s
      score: sentenceScores[i]
      orderInText: i
    }

  sentenceObjects = _.sortBy sentenceObjects, (sentence_score) ->
    -(sentence_score.score)

  if sentenceObjects.length < n
    n = sentenceObjects.length

  sentenceObjects = sentenceObjects[0...n]

  sentenceObjects = _.sortBy sentenceObjects, (sentence) ->
    sentence.orderInText

  _.pluck(sentenceObjects, "sentence")
