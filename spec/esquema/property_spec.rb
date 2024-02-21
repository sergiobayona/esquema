# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::Property do
  let(:object) { double("object") }
  let(:options) { {} }
  subject { described_class.new(object, options) }

  describe "#initialize" do
    context "when property has a name" do
      before { allow(object).to receive(:respond_to?).with(:name).and_return(true) }

      it "sets the property and options" do
        expect(subject.object).to eq(object)
        expect(subject.options).to eq(options)
      end
    end

    context "when property does not have a name" do
      before { allow(object).to receive(:respond_to?).with(:name).and_return(false) }

      it "raises an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError, "property must have a name")
      end
    end
  end

  context "when property is an ActiveRecord column" do
    let(:user) { stub_const "User", Class.new(ActiveRecord::Base) }
    let(:property) { Esquema::Property.new(column) }

    context "string column" do
      let(:column) { user.column_for_attribute("name") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({ type: "string", title: "Name" })
      end
    end

    context "integer column" do
      let(:column) { user.column_for_attribute("group") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({ type: "integer", title: "Group" })
      end
    end

    context "string column with default" do
      let(:column) { user.column_for_attribute("country") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({
                                         type: "string",
                                         title: "Country",
                                         default: "United States of America"
                                       })
      end
    end

    context "boolean column with default value" do
      let(:column) { user.column_for_attribute("active") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({
                                         type: "boolean",
                                         title: "Active",
                                         default: false
                                       })
      end
    end

    context "text column" do
      let(:column) { user.column_for_attribute("bio") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({
                                         type: "string",
                                         title: "Bio"
                                       })
      end
    end

    context "date column" do
      let(:column) { user.column_for_attribute("dob") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({
                                         type: "date",
                                         title: "Dob"
                                       })
      end
    end

    context "datetime column" do
      let(:column) { user.column_for_attribute("created_at") }

      it "includes the required keywords and values" do
        expect(property.as_json).to eq({
                                         type: "date-time",
                                         title: "Created at"
                                       })
      end
    end
  end
end
