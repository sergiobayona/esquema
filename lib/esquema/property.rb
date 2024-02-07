module Esquema
  class Property
    attr_reader :name, :type, :default, :title, :description, :item_type

    def initialize(name:, type:, default: nil, title: nil, description: nil, item_type: nil)
      @name = name
      @type = type
      @title = title
      @default = default
      @description = description
      @item_type = item_type
    end
  end
end
