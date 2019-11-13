module KeywordMatcher
  class Process
    attr_reader :group, :words

    def initialize(group, words)
      @group = group
      @words = words
    end

    def found?
      in_any?(group.or) && negation_found?.blank?
    end

    private

    def negation_found?
      return if group.not.blank?

      in_any?(group.not)
    end

    def in_any?(groups)
      groups.map do |values|
        values.map do |terms|
          match = false
          terms.each do |term|
            words.each do |word|
              if condition(term, word)
                match = true
                break
              end
            end
          end
          match
        end.include?(false).blank?
      end.include?(true)
    end

    def matched?(term, word)
      word == term
    end

    def condition(term, word)
      synonym = find_synonym(term)
      synonym.present? ? (matched?(term, word) || matched?(synonym, word)) : matched?(term, word)
    end

    def find_synonym(term)
      synonyms_h.map { |k, v| term.gsub(k, v) if term.match?(k) }.reject(&:blank?).try(:first)
    end

    def synonyms_h
      {
        %r{([0-9]+)гр} => '\1г',
        %r{([0-9]+)г(?!р)} => '\1гр',
        %r{([0-9])([,|.])(.*)} => '\1-\3'
      }
    end
  end
end
