require 'neo4j'
require 'analyst'
require 'neo4j/session_manager'

require 'neo4j'
require 'neo4j/session_manager'

neo4j_url = ENV['NEO4J_URL'] || 'http://localhost:7474'

Neo4j::Core::CypherSession::Adaptors::Base.subscribe_to_query(&method(:puts))

adaptor_type = neo4j_url.match(/^bolt:/) ? :bolt : :http
Neo4j::ActiveBase.on_establish_session do
  Neo4j::SessionManager.open_neo4j_session(adaptor_type, neo4j_url)
end

session = Neo4j::ActiveBase.current_session

require_relative 'ast_visualizer/node'

module AstVisualizer
  module ClassMethods

    NODE_TYPES = [
      :classes,
      :strings,
      :modules,
      :constants,
      :constant_assignments,
      :top_level_constant_assignments,
      :top_level_constants,
      :top_level_modules,
      :top_level_classes,
      :method_calls,
      :methods,
      :conditionals,
      :variables
    ]

    def build_graph(*path_to_files)
      parser = Analyst::Parser.for_files(*path_to_files)
      parser.top_level_entities.each{ |entity| build_node(entity) }
    end

    def build_node(entity)
      node = AstVisualizer::Node.create(
        name: entity.name,
        node_type: entity.class.name,
        location: entity.location,
        line_number: entity.line_number
      )
      NODE_TYPES.each do |node_type|
        node.send("#{node_type}=", entity.classes.map{ |subnode| build_node(subnode) })
      end
      node
    end

  end
  extend ClassMethods
end
