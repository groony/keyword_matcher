require 'active_support'
require 'active_support/core_ext'
require 'damerau-levenshtein'
require 'keyword_matcher/version'
require 'keyword_matcher/group'
require 'keyword_matcher/prophet'
require 'keyword_matcher/process'

module KeywordMatcher
  class << self
    def matched?(keywords, words)
      Process.new(Group.new(keywords), Prophet.new(words).explode).found?
    end
  end
end
