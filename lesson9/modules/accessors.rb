# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend self
  end

  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        @history ||= {}
        @history[name] ||= []
        @history[name] << instance_variable_get(var_name)
        instance_variable_set(var_name, value)
      end
      define_method("#{name}_history".to_sym) { @history[name] }
    end
  end

  def strong_attr_accessor(name, attr_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise 'Неверный класс' unless value.instance_of?(attr_class)

      instance_variable_set(var_name, value)
    end
  end
end
