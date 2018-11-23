module KeywordMatcher
  class Process
    attr_reader :group, :words

    FUZZINESS = 1
    MIN_WORD_LENGTH_FOR_FUZZY = 4

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
            words.each do |w|
              match = true if condition(term, w)
            end
          end
          match
        end.include?(false).blank?
      end.include?(true)
    end

    def matched?(term, w)
      return w == (quoted?(term) ? term[1..-2] : term) if precise?(term)
      ::DamerauLevenshtein.distance(term, w) <= FUZZINESS
    end

    def condition(term, w)
      synonym = find_synonym(term)
      synonym.present? ? (matched?(term, w) || matched?(synonym, w)) : matched?(term, w)
    end

    def find_synonym(term)
      synonyms_h.map { |k, v| term.gsub(k, v) if term.match?(k) }.reject(&:blank?).try(:first)
    end

    def synonyms_h
      {
        %r{([0-9]+)гр} => '\1г',
        %r{([0-9])([,|.])(.*)} => '\1-\3'
      }
    end

    def precise?(term)
      quoted?(term) || (quoted?(term).blank? && term.length < MIN_WORD_LENGTH_FOR_FUZZY)
    end

    def quoted?(term)
      regex = /(["'])(?:(?=(\\?))\2.)*?\1/
      term.match?(regex)
    end
  end
end
