module KeywordMatcher
  class Group
    attr_reader :all, :or, :not, :title

    OPERATOR_OR = 'или'.freeze
    OPERATOR_NOT = 'не'.freeze

    def initialize(title)
      @title = title
      @all = values
      @or = or_groups
      @not = not_groups
    end

    def values
      title.downcase.split("\n").map do |line|
        line.split(' ').map(&:strip)
      end.reject(&:empty?)
    end

    def or_groups
      title.downcase.gsub(/\r?\n#{OPERATOR_NOT}.*/m, '').split(OPERATOR_OR).map do |v|
        v.split("\n").reject(&:blank?).map(&:split)
      end.reject(&:blank?)
    end

    def not_groups
      return [] unless title.downcase.match?(/\r?\n#{OPERATOR_NOT}\r?\n/)
      title.downcase.match(/\r?\n#{OPERATOR_NOT}.*/m).to_s.split(OPERATOR_NOT).map do |v|
        v.split("\n").reject(&:blank?).map(&:split)
      end.reject(&:blank?)
    end
  end
end
