module AstVisualizer
  class AstNode

    attr_accessor :name, :node_type, :location, :line_number, :neo_id
    attr_reader :node

    def self.create(attrs)
      node = Neo4j::Node.create(attrs, :ast_node)
      new(attrs, node)
    end

    def initialize(args, node)
      args.each{ |arg| self.send("#{arg[0]}=", arg[1])}
      @node = node
    end

    def relate(child, type)
      self.node.create_rel(type, child.node)
    end

 end
end
