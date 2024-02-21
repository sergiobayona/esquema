RSpec.describe Esquema::Builder do
  let(:model) { double("Model") }
  let(:builder) { described_class.new(model) }

  describe "#initialize" do
    it "raises an ArgumentError if the class is not an ActiveRecord model" do
      expect { described_class.new(Object) }.to raise_error(ArgumentError, "Class is not an ActiveRecord model")
    end

    it "sets the model and initializes properties" do
      allow(model).to receive(:ancestors).and_return([ActiveRecord::Base])
      expect(builder.model).to eq(model)
      expect(builder.required_properties).to eq([])
    end
  end

  describe "#build_schema" do
    before { allow(model).to receive(:ancestors).and_return([ActiveRecord::Base]) }

    it "builds the schema for the ActiveRecord model" do
      expect(builder).to receive(:build_title).and_return("Title")
      expect(builder).to receive(:build_description).and_return("Description")
      expect(builder).to receive(:build_type).and_return("object")
      expect(builder).to receive(:build_properties).and_return({ property: "value" })
      expect(builder).to receive(:required_properties).and_return(["property"])

      schema = builder.build_schema

      expect(schema).to eq({
                             title: "Title",
                             description: "Description",
                             type: "object",
                             properties: { property: "value" },
                             required: ["property"]
                           })
    end
  end

  describe "#build_properties" do
    before { allow(model).to receive(:ancestors).and_return([ActiveRecord::Base]) }

    it "adds properties from columns, associations, and virtual properties" do
      expect(builder).to receive(:add_properties_from_columns)
      expect(builder).to receive(:add_properties_from_associations)
      expect(builder).to receive(:add_virtual_properties)

      properties = builder.build_properties

      expect(properties).to eq(builder.instance_variable_get(:@properties))
    end
  end

  describe "#build_type" do
    before { allow(model).to receive(:ancestors).and_return([ActiveRecord::Base]) }

    it "returns the type of the model" do
      expect(model).to receive(:respond_to?).with(:type).and_return(true)
      expect(model).to receive(:type).and_return("type")

      expect(builder.build_type).to eq("type")
    end

    it "returns 'object' if the model does not respond to type" do
      expect(model).to receive(:respond_to?).with(:type).and_return(false)

      expect(builder.build_type).to eq("object")
    end
  end
end
