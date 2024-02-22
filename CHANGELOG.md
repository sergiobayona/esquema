## [0.1.2] - 2024-02-22
- Removed Rails dependency and added ActiveRecord dependency.
- Added documentation for `virtual_property` and improved overall README.md
- Only supporting Ruby 3.2 and above for now.
- Added support for `virtual_property`. This allows you to define JSON schema properties that don't have a corresponding AR attribute.
- Performance improvements.
- Improved error handling and added more tests.
- Improved documentation and added more examples.
- Added additional support for schema validation keywords. Example: `minLength`, `maxLength`, `pattern`, `format`, `multipleOf`, `minimum`, `maximum`, `exclusiveMinimum`, `exclusiveMaximum`, `enum`, `const`, `items`, `additionalItems`, `contains`, `minItems`, `maxItems`, `uniqueItems`, `propertyNames`, `minProperties`, `maxProperties`, `required`, `dependencies`, `patternProperties`, `allOf`, `anyOf`, `oneOf`, `not`.

## [0.1.0] - 2024-02-14

- Initial release
