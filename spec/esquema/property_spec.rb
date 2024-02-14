# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::Property do
  # Defines the User model
  class User < ActiveRecord::Base
  end

  let(:model) { User }

  context "string column" do
    let(:string_column) { User.column_for_attribute("name") }

    let(:property) { Esquema::Property.new(string_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({ type: "string", title: "Name" })
    end
  end

  context "integer column" do
    let(:integer_column) { User.column_for_attribute("group") }
    let(:property) { Esquema::Property.new(integer_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({ type: "integer", title: "Group" })
    end
  end

  context "string column with default" do
    let(:string_column) { User.column_for_attribute("country") }
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
    let(:boolean_column) { User.column_for_attribute("active") }

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
    let(:text_column) { User.column_for_attribute("bio") }

    let(:property) { Esquema::Property.new(text_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "string",
                                       title: "Bio"
                                     })
    end
  end

  context "datetime column" do
    let(:datetime_column) { User.column_for_attribute("created_at") }

    let(:property) { Esquema::Property.new(datetime_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date-time",
                                       title: "Created at"
                                     })
    end
  end

  context "date column" do
    let(:date_column) { User.column_for_attribute("dob") }

    let(:property) { Esquema::Property.new(date_column) }

    it "includes the required keywords and values" do
      expect(property.as_json).to eq({
                                       type: "date",
                                       title: "Dob"
                                     })
    end
  end
end
