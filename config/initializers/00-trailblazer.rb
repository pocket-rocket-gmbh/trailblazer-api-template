require "trailblazer/endpoint/grape/controller"

require 'reform/form/dry'
Reform::Form.class_eval do
  feature Reform::Form::Dry
end
