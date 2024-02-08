# frozen_string_literal: true

RSpec.describe Esquema::Model do
  let(:model) { Company }
  subject(:schema_model) { Esquema::Model.new(model) }

  it "does something useful" do
    expect(schema_model).to be_a(Esquema::Model)
  end

  it "raises an error if the class is not an ActiveRecord schema_model" do
    expect {
      described_class.new(String)
    }.to raise_error(ArgumentError, "Class is not an ActiveRecord model")
  end

  it "returns a ruby hash representing the schema_model properties" do
    expect(schema_model.name).to eq("Company")
  end

  it "returns a ruby hash representing the schema_model properties" do
    expect(schema_model.metadata).to eq({})
  end

  context "build_schema" do
    it "returns a ruby hash representing the schema_model properties" do
      expect(schema_model.metadata.keys).to eq(model.column_names.map(&:to_sym))
    end
  end
end
