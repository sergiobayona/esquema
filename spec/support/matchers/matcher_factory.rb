# frozen_string_literal: true

class MatcherFactory
  def initialize(matcher_name)
    @matcher_name = matcher_name
  end

  def define_matcher
    RSpec::Matchers.define(@matcher_name) do |expected|
      yield

      match do |actual|
        traverse(expected, actual, false)
      end

      match_when_negated do |actual|
        traverse(expected, actual, true)
      end

      failure_message do |_actual|
        ::FailurePresenter.render(@include_json_errors)
      end

      failure_message_when_negated do |_actual|
        ::FailurePresenter.render(@include_json_errors)
      end
    end
  end
end
