# frozen_string_literal: true

RSpec.describe "A schema with multiple objects" do
  module Foo
    class User < ActiveRecord::Base
      has_many :tasks, class_name: "Foo::Task"

      include Esquema::Model
    end

    class Task < ActiveRecord::Base
      belongs_to :user, class_name: "Foo::User"
    end
  end

  subject(:model) { Foo::User }

  it "includes the associated model schema" do
    expect(model.json_schema).to include_json({
                                                "title": "Foo::user",
                                                "type": "object",
                                                "properties": {
                                                  "tasks": {
                                                    "type": "array",
                                                    "title": "Tasks",
                                                    "items": {
                                                      "title": "Foo::task",
                                                      "type": "object",
                                                      "properties": {
                                                        "id": {
                                                          "type": "integer",
                                                          "title": "Id"
                                                        },
                                                        "title": {
                                                          "type": "string",
                                                          "title": "Title"
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
                                                    }
                                                  }
                                                }
                                              })
  end
end
