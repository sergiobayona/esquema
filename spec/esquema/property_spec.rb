# frozen_string_literal: true

RSpec.describe Esquema::Property do
  context "as_json with an ID column" do
    let(:id_column) { Employee.columns.find { |c| c.name == "id" } }
    let(:property) { Esquema::Property.new(id_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({ type: "integer", title: "Id" })
    end
  end

  context "string column with default" do
    let(:string_column) { Address.columns.find { |c| c.name == "country" } }
    let(:property) { Esquema::Property.new(string_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "string",
                                       title: "Country",
                                       default: "United States of America"
                                     })
    end
  end

  context "boolean column with default value" do
    let(:boolean_column) { Employee.columns.find { |c| c.name == "active" } }

    let(:property) { Esquema::Property.new(boolean_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "boolean",
                                       title: "Active",
                                       default: false
                                     })
    end
  end

  context "datetime column" do
    let(:datetime_column) { Employee.columns.find { |c| c.name == "created_at" } }

    let(:property) { Esquema::Property.new(datetime_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date-time",
                                       title: "Created at"
                                     })
    end
  end

  context "date column" do
    let(:date_column) { Employee.columns.find { |c| c.name == "birth_date" } }

    let(:property) { Esquema::Property.new(date_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date",
                                       title: "Birth date"
                                     })
    end
  end
end
