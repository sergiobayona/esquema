module Esquema
  class Property
    attr_reader :name, :type, :default, :title, :description, :item_type

    def initialize(attr)
      @name = attr.name
      @type = attr.type
      @default = attr.default unless attr.default.nil?
    end
  end
end
