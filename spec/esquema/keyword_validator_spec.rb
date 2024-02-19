# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::KeywordValidator do
  describe ".validate!" do
    context "when the property type is not a valid option" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :sometype, default: 1)
        end.to raise_error(ArgumentError, "Unknown type sometype")
      end
    end

    context "when the property name is not a symbol" do
      it "raises an error" do
        expect do
          described_class.validate!("name", :string, default: "John Doe")
        end.to raise_error(ArgumentError, "Property must be a symbol")
      end
    end

    context "when the property type is not a symbol" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, "string", default: "John Doe")
        end.to raise_error(ArgumentError, "Property type must be a symbol")
      end
    end

    context "when the property type does not match its default value" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, default: 1)
        end.to raise_error(ArgumentError, "Default value for name does not match type string")
      end
    end

    context "when the property is a valid option" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :string, default: "John Doe", enum: ["John Doe", "Jane Doe"])
        end.not_to raise_error
      end
    end

    context "when the property type does not match its enum values" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, enum: [1, 2, 3])
        end.to raise_error(ArgumentError, "Enum value for name does not match type string")
      end
    end

    context "when the property is a string and the enum values are strings of numbers" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :string, enum: %w[1 2 3])
        end.not_to raise_error
      end
    end

    context "when the property enum is not an array" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, enum: "John Doe")
        end.to raise_error(ArgumentError, "Enum for name is not an array")
      end

      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, enum: { name: "John Doe" })
        end.to raise_error(ArgumentError, "Enum for name is not an array")
      end
    end

    context "when the property type does not match its constant value" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, const: 1)
        end.to raise_error(ArgumentError, "Const value for name does not match type string")
      end
    end

    context "when the property is a string and the constant value is a string of a number" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :string, const: "1")
        end.not_to raise_error
      end
    end

    context "when the property is a string and the constant value is a string" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :string, const: "John Doe")
        end.not_to raise_error
      end
    end

    context "when the property is a string and the constant value is a symbol" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, const: :john_doe)
        end.to raise_error(ArgumentError, "Const value for name does not match type string")
      end
    end

    context "when the property is a string and the constant value is a boolean" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :string, const: true)
        end.to raise_error(ArgumentError, "Const value for name does not match type string")
      end
    end

    context "when the property is a boolean and the default value is false" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :boolean, default: false)
        end.not_to raise_error
      end
    end

    context "when the property is a boolean and the default value is true" do
      it "does not raise an error" do
        expect do
          described_class.validate!(:name, :boolean, default: true)
        end.not_to raise_error
      end
    end

    context "when the property is a boolean and the default value is a string" do
      it "raises an error" do
        expect do
          described_class.validate!(:name, :boolean, default: "true")
        end.to raise_error(ArgumentError, "Default value for name does not match type boolean")
      end
    end
  end
end
