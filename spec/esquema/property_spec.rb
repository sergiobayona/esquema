# frozen_string_literal: true

RSpec.describe Esquema::Property do
  # Defines the User model
  class User < ActiveRecord::Base
  end

  let(:model) { User }

  context "string column" do
    let(:string_column) { User.columns.find { |c| c.name == "name" } }
    let(:property) { Esquema::Property.new(string_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({ type: "string", title: "Name" })
    end
  end

  context "integer column" do
    let(:integer_column) { User.columns.find { |c| c.name == "group" } }
    let(:property) { Esquema::Property.new(integer_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({ type: "integer", title: "Group" })
    end
  end

  context "string column with default" do
    let(:string_column) { User.columns.find { |c| c.name == "country" } }
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
    let(:boolean_column) { User.columns.find { |c| c.name == "active" } }

    let(:property) { Esquema::Property.new(boolean_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "boolean",
                                       title: "Active",
                                       default: false
                                     })
    end
  end

  context "text column" do
    let(:text_column) { User.columns.find { |c| c.name == "bio" } }

    let(:property) { Esquema::Property.new(text_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "string",
                                       title: "Bio"
                                     })
    end
  end

  context "datetime column" do
    let(:datetime_column) { User.columns.find { |c| c.name == "created_at" } }

    let(:property) { Esquema::Property.new(datetime_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date-time",
                                       title: "Created at"
                                     })
    end
  end

  context "date column" do
    let(:date_column) { User.columns.find { |c| c.name == "dob" } }

    let(:property) { Esquema::Property.new(date_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date",
                                       title: "Dob"
                                     })
    end
  end
end
