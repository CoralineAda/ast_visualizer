require 'neo4j-core'
require 'analyst'

neo4j_url = ENV['NEO4J_URL'] || 'http://localhost:7474'
neo4j_username = "neo4j"
neo4j_password = "foo123"
Neo4j::Session.open(:server_db, neo4j_url, basic_auth: { username: neo4j_username, password: neo4j_password })

require_relative 'ast_visualizer/ast_node'

module AstVisualizer
  module ClassMethods

    NODE_TYPES = [
      :classes,
      :strings,
      :modules,
      # :constants,
      :constant_assignments,
      :method_calls,
      :methods,
      :conditionals,
      :variables
    ]

    def build_graph(*path_to_files)
      clean_database
      parser = Analyst::Parser.for_files(*path_to_files)
      parser.top_level_entities.each{ |entity| build_node(entity) }
    end

    def build_node(entity)
      node = AstVisualizer::AstNode.create(
        name: entity.name,
        node_type: entity.class.name.split("::").last,
        location: entity.location,
        line_number: entity.line_number
      )
      NODE_TYPES.each do |node_type|
        children = entity.send(node_type)
        children.each{ |child| node.relate(build_node(child), node_type) }
      end
      node
    end

    def clean_database
      Neo4j::Session.query("MATCH (a)-[r]->(b) DELETE r, a")
    end

  end
  extend ClassMethods
end
