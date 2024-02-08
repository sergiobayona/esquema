# frozen_string_literal: true

RSpec.describe Esquema::Serializer do
  subject(:serializer) { Esquema::Serializer.new(Employee) }

  it "does something useful" do
    expect(serializer.serialize).to eq('')
  end

end
