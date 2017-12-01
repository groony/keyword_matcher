module KeywordMatcher
  class Prophet
    attr_reader :phrase

    PRECISION = 0.5
    SPLIT = 0.2
    SEPARATOR = %r{[\s\(\)\/*:"'\\\/\$\.,=]+}
    MEASURES = 'кг|г|л|мл|уп|ед|шт|мг|пак'.freeze

    def initialize(phrase)
      @phrase = phrase
    end

    def explode
      prepare
        .split(SEPARATOR)
        .map(&:strip)
        .map(&:downcase)
        .reject { |w| w.size < 2 }
        .reject { |w| w =~ /\d{5,}/ }
    end

    def prepare
      phrase.downcase
            .gsub(/(\p{Ll})(\d+\S)/, '\1 \2') # split text from digits
            .gsub(/%([\p{L}\d])/, '% \1') # add space after percents
            .gsub(/(\d)[\.,](\d)/, '\1-\2') # replace separator between digits from , or . to -
            .gsub(/(\d)[\.,\s]+(#{MEASURES})\.?/, '\1\2') # replace gaps between numbers and measures
            .gsub(/(\p{Ll})(\p{Lu})/, '\1 \2') # split camelcase string
            .gsub(/(\d)-0+(#{MEASURES})/, '\1\2') # remove trailing zeroes after measures
    end
  end
end
