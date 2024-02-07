# frozen_string_literal: true

RSpec.describe Esquema do
  it "has a version number" do
    expect(Esquema::VERSION).not_to be nil
  end

  it "does something useful" do
    Esquema::Analyzer.analyze
  end
end
