# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::Model do
  class User < ActiveRecord::Base
    include Esquema::Model
  end

  let(:model) { User }

  after { Esquema.configuration.reset }

  it "returns a ruby hash representing the schema_model properties" do
    expect(model.json_schema).to include_json({
                                                "title": "User",
                                                "type": "object",
                                                "properties": {
                                                  "id": {
                                                    "type": "integer",
                                                    "title": "Id"
                                                  },
                                                  "name": {
                                                    "type": "string",
                                                    "title": "Name"
                                                  },
                                                  "email": {
                                                    "type": "string",
                                                    "title": "Email"
                                                  },
                                                  "created_at": {
                                                    "type": "date-time",
                                                    "title": "Created at"
                                                  },
                                                  "updated_at": {
                                                    "type": "date-time",
                                                    "title": "Updated at"
                                                  }
                                                }
                                              })
  end

  context "" do
  end
end
