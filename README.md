# Esquema

Esquema is a Ruby library for JSON Schema generation from ActiveRecord models.

Esquema was designed with the following assumptions:

- An ActiveRecord model represents a JSON Schema object.
- The JSON object properties are a representation of the model's attributes.
- The JSON Schema property types are inferred from the model's attribute types.
- The model associations (has_many, belongs_to, etc.) are represented as subschemas or nested schema objects.
- You can customize the generated schema by using the configuration file or the `enhance_schema` method.

Example Use:

```ruby
class User < ApplicationRecord
  include Esquema::Model

    # Assuming the User db table has the following columns:
    # column :name, :string
    # column :email, :string

  end
end
```

Calling `User.json_schema` will return the JSON Schema for the User model:

```json
{
    "title": "User model",
    "type": "object",
    "properties": {
        "id": {
            "type": "integer"
        },
        "name": {
            "type": "string"
        },
        "email": {
            "type": "string"
        }
    },
    "required:": [
        "name",
        "email"
    ]
}
```

## Installation

 install the gem by executing:

    $ gem install esquema


Run the following command to install the gem and generate the configuration file:

```bash
rails generate esquema:install 
```

This will generate a configuration file at:

    <rails_app>/config/initializer/esquema.rb


## Usage

Simply include the `Esquema::Model` module in your ActiveRecord model and call the `json_schema` method to generate the JSON Schema for the model.

There are multiple ways to customize the generated schema:
- You can exclude columns, foreign keys, and associations from the schema. See the <rails_project>/config/initializer/esquema.rb configuration for more details.
- For more complex customizations, you can use the `enhance_schema` method to modify the schema directly on the AR model. Here is an example:

```ruby
class User < ApplicationRecord
  include Esquema::Model

  enhance_schema do
    model_description "A user of the system"
    property :name, description: "The user's name", title: "Full Name"
    property :group, enum: [1, 2, 3], default: 1, description: "The user's group"
    property :email, description: "The user's email", format: "email"
    virtual_property :age, type: "integer", minimum: 18, maximum: 100, description: "The user's age"
  end
end
```

In the example above, the `enhance_schema` method is used to add a description to the model, change the title of the `name` property and add a description. It adds an enum, default value and a description to the `group` property.

Use the `property` keyword for the existing model attributes. In other words the symbol passed to the `property` method must be a column in the table that the model represents. Property does not accept a `type` argument, as the type is inferred from the column type.

Use the `virtual_property` keyword for properties that are not columns in the table that the model represents. Virtual properties require a `type` argument, as the type cannot be inferred.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sergiobayona/esquema. 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

