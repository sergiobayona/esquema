# frozen_string_literal: true

RSpec.describe Esquema::Serializer do
  subject(:serializer) { Esquema::Serializer.new(Employee) }

  it "includes the top level keywords and values" do
    expect(serializer.serialize).to include_json({ title: "Employee", type: "object", description: nil })
  end

  it "includes the attributes" do
    expect(serializer.serialize).to include_json({ properties: { id: { type: "integer" }, name: { type: "string" } } })
  end

  # it "includes the required attributes" do
  #   expect(serializer.serialize).to include_json({required: ["id", "name"]})
  # end

  it "includes the relationships" do
    binding.pry
  end
end
