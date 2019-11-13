module KeywordMatcher
  class Prophet
    attr_reader :phrase

    SEPARATOR = %r{[\s\(\)\/*:"#'\[\];<>\\\/\$\.,=“”«»]+}.freeze
    MEASURES = 'кг|г|л|мл|уп|ед|шт|мг|пак|гр'.freeze

    def initialize(phrase)
      @phrase = phrase
    end

    def explode
      prepare
        .split(SEPARATOR)
        .map(&:strip)
        .reject(&:blank?)
    end

    def prepare
      phrase.gsub(/[-]/, ' ') # split text contains - character by space
            .gsub(/(\p{Ll}{2,})(\d+\S)/, '\1 \2') # split text contains > 1 character from digits
            .gsub(/%([\p{L}\d])/, '% \1') # add space after percents
            .gsub(/(\d)[\.,](\d)/, '\1-\2') # replace separator between digits from , or . to -
            .gsub(/(\d)[\.,\s]+(#{MEASURES})\.?(?!\p{L})/i, '\1\2') # replace gaps between numbers and measures
            .gsub(/(\p{Ll})(\p{Lu})/, '\1 \2') # split camelcase string
            .gsub(/(\d)-0+(#{MEASURES})/i, '\1\2') # remove trailing zeroes after measures
            .gsub(/([а-яa-z])(\d+)(#{MEASURES})/i, '\1 \2\3') # add space between word and measure
            .gsub(/(\d+)(#{MEASURES})([x|х])/i, '\1\2 \3') # add space before amount
            .gsub(/([а-я])([a-z]{2,})/i, '\1 \2') # add space between alternating Russian English
            .downcase
    end
  end
end
