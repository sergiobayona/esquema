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
    expect(schema_model.metadata).to_not be_empty
    expect(schema_model.metadata).to be_a(Hash)
    expect(schema_model.metadata.keys).to eq([:title, :description, :type, :properties])
  end

  context "build_schema" do
    it "returns a ruby hash representing the schema_model properties" do
      schema_model.build_schema
      expect(schema_model.metadata[:properties].keys).to eq(model.column_names.map(&:to_sym))
    end
  end

  context "excluded columns" do
    it "returns false if not included" do
      Esquema.configuration.excluded_columns = []
      expect(schema_model.excluded_column?("id")).to eq(false)
    end

    it "raises an error if the column name is not a string" do
      expect {
        schema_model.excluded_column?(1)
      }.to raise_error(ArgumentError, "Column name must be a string")
    end

    it "returns true if included" do
      Esquema.configuration.excluded_columns = [:id]
      expect(schema_model.excluded_column?("id")).to eq(true)
    end

    it "includes column if not excluded" do
      Esquema.configuration.excluded_columns = []
      expect(schema_model.columns.map(&:name)).to include("id")
    end

    it "excludes columns from the schema_model" do
      Esquema.configuration.excluded_columns = [:id]
      expect(schema_model.columns.map(&:name)).not_to include("id")
    end
  end
end
