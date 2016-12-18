module AstVisualizer
  class Node
    include Neo4j::ActiveNode
    id_property :uuid, auto: :uuid
    property :name
    property :node_type
    property :location
    property :line_number

    has_many :out, :classes, type: :class, model_class: 'AstVisualizer::Node'
    has_many :out, :strings, type: :string, model_class: 'AstVisualizer::Node'
    has_many :out, :modules, type: :module, model_class: 'AstVisualizer::Node'
    has_many :out, :constants, type: :constant, model_class: 'AstVisualizer::Node'
    has_many :out, :constant_assignments, type: :constant_assignment, model_class: 'AstVisualizer::Node'
    has_many :out, :method_calls, type: :method_call, model_class: 'AstVisualizer::Node'
    has_many :out, :methods, type: :method, model_class: 'AstVisualizer::Node'
    has_many :out, :conditionals, type: :conditional, model_class: 'AstVisualizer::Node'
    has_many :out, :variables, type: :variable, model_class: 'AstVisualizer::Node'
    has_many :out, :hashes, type: :hash, model_class: 'AstVisualizer::Node'

 end
end
