require          'rdf'
require_relative 'rdf_converter'

module BEL
  module BELRDF
    class StatementConverter
      include RDFConverter

      def initialize(term_converter, relationship_converter)
        @term_converter         = term_converter
        @rel_converter = relationship_converter
      end

      # Convert a {BELParser::Expression::Model::Statement} to {RDF::Graph} of
      # RDF statements.
      #
      # @param  [BELParser::Expression::Model::Statement] bel_statement
      # @return [RDF::Graph] graph of RDF statements representing the statement
      def convert(bel_statement)
        # Dive into subject
        sub_part, sub_uri, subg = @term_converter.convert(bel_statement.subject)

        # Dive into object
        case
        when bel_statement.simple?
          obj_part, obj_uri, objg = @term_converter.convert(bel_statement.object)
          rel_part, rel_uri       = @rel_converter.convert(bel_statement.relationship)
          path_part               = "#{sub_part}_#{rel_part}_#{obj_part}"
          stmt_uri                = BELR[URI::encode(path_part)]

          sg  = RDF::Graph.new
          sg << subg
          sg << objg
          sg << s(stmt_uri, RDF.type,           BELV2_0.Statement)
          sg << s(stmt_uri, BELV2_0.hasSubject,      sub_uri)
          sg << s(stmt_uri, BELV2_0.hasObject,       obj_uri)
          sg << s(stmt_uri, BELV2_0.hasRelationship, rel_uri) if rel_uri
        when bel_statement.nested?
          obj_part, obj_uri, objg = convert(bel_statement.object)
          rel_part, rel_uri       = @rel_converter.convert(bel_statement.relationship)
          path_part               = "#{sub_part}_#{rel_part}_#{obj_part}"
          stmt_uri                = BELR[URI::encode(path_part)]

          sg            = RDF::Graph.new
          sg << subg
          sg << objg
          sg << s(stmt_uri, RDF.type,           BELV2_0.Statement)
          sg << s(stmt_uri, BELV2_0.hasSubject, sub_uri)
          sg << s(stmt_uri, BELV2_0.hasObject,  obj_uri)
          sg << s(stmt_uri, BELV2_0.hasRelationship, rel_uri) if rel_uri
        else
          path_part      = sub_part
          stmt_uri       = BELR[URI::encode(path_part)]

          sg  = RDF::Graph.new
          sg << subg
          sg << s(stmt_uri, RDF.type,           BELV2_0.Statement)
          sg << s(stmt_uri, BELV2_0.hasSubject, sub_uri)
        end

        [path_part, stmt_uri, sg]
      end
    end
  end
end
