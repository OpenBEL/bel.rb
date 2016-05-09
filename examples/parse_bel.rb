require 'bel'

include BEL::Language
include BEL::Namespace

# BEL Script is parsed top-down.

# BEL statement iteration order is as follows:
# - Subject Term (innermost parameters first)
# - Relationship (optional)
# - Object       (optional)
#   * Term       (innermost parameters first)
#   * Statement

# BEL Content is provided as data in this script (Accessible with the DATA global).
# You will find the BEL Script at the end of this file starting from __END__.
BEL_SCRIPT = DATA.read

# Parse BEL script and output object name and BEL serialization
BEL::Script.parse(BEL_SCRIPT).each do |bel_object|
  bel_class_name = bel_object.class.name.split('::').last
  puts "#{bel_class_name}: #{bel_object.to_bel}"
end

# Collect set of BEL Terms (includes inner Terms)
term_set = BEL::Script.parse(BEL_SCRIPT).
  find_all { |bel_object|
    bel_object.is_a?(Term)
  }.to_a.uniq
puts "\nContains #{term_set.length} terms: \n#{term_set.join(', ')}"

# Find set of BEL Parameters referencing HGNC namespace
hgnc = BEL::Script.parse(BEL_SCRIPT).
  find_all { |bel_object|
    bel_object.is_a?(Parameter) && bel_object.ns == HGNC
  }.
  to_a.uniq!.
  sort_by! { |parameter| parameter.value }
puts "\nContains #{hgnc.length} HGNC identifiers: \n#{hgnc.join(', ')}"

# Find nested BEL Statements
nested = BEL::Script.parse(BEL_SCRIPT).
  find_all { |bel_object|
    bel_object.is_a?(Statement) && bel_object.nested?
  }.
  to_a.uniq
puts "\nContains #{nested.length} nested statements: \n#{nested.join(', ')}"

# Group statements by annotations
puts "\nStatements by Annotation"
statements_by_annotation = BEL::Script.parse(BEL_SCRIPT).
  find_all { |bel_object|
    bel_object.is_a?(Statement)
  }.
  flat_map { |statement|
    statement.annotations.map { |name, annotation|
      [ annotation, statement.to_bel ]
    }
  }.
  group_by { |statement_annotation_pair|
    statement_annotation_pair.first
  }.
  each do |annotation, pairs|
    puts "#{annotation.name}: #{annotation.value}"
    pairs.each do |pair|
      puts "  #{pair[1]}"
    end
  end

__END__
###################################################################################
# Document Properties Section
SET DOCUMENT Name = "BEL Framework Example 1 Document"
SET DOCUMENT Description = "Example of modeling a full abstract taken from the BEL V1.0 Language Overview. "
SET DOCUMENT Version = 20131211
SET DOCUMENT Copyright = "Copyright (c) 2011, Selventa. All Rights Reserved."
SET DOCUMENT ContactInfo = "support@belframework.org"
SET DOCUMENT Authors = Selventa
SET DOCUMENT Licenses = "Creative Commons Attribution-Non-Commercial-ShareAlike 3.0 Unported License"

##################################################################################
# Definitions Section

DEFINE NAMESPACE CHEBI AS URL "http://resource.belframework.org/belframework/latest-release/namespace/chebi.belns"
DEFINE NAMESPACE HGNC AS URL "http://resource.belframework.org/belframework/latest-release/namespace/hgnc-human-genes.belns"
DEFINE NAMESPACE SCOMP AS URL "http://resource.belframework.org/belframework/latest-release/namespace/selventa-named-complexes.belns"
DEFINE NAMESPACE SFAM AS URL "http://resource.belframework.org/belframework/latest-release/namespace/selventa-protein-families.belns"

DEFINE ANNOTATION CellLine AS URL "http://resource.belframework.org/belframework/latest-release/annotation/cell-line.belanno"
DEFINE ANNOTATION Species AS URL "http://resource.belframework.org/belframework/latest-release/annotation/species-taxonomy-id.belanno"

##################################################################################
# Statements Section
SET Citation = {"PubMed","J Biol Chem. 1997 Jul 4;272(27):16917-23.","9202001"}

SET Support = "Phorbol ester tumor promoters, such as phorbol\
12-myristate 13-acetate (PMA), are potent activators of\
extracellular signal-regulated kinase 2 (ERK2), stress-activated\
protein kinase (SAPK), and p38 mitogen-activated protein kinase\
(MAPK) in U937 human leukemic cells."
SET Species = 9606
SET CellLine = "U-937 cell"
# disambiguation ERK2 = HGNC MAPK1
a(CHEBI:"phorbol 13-acetate 12-myristate") -> kin(p(HGNC:MAPK1))
# disambiguation SAPK = HGNC MAPK8
a(CHEBI:"phorbol 13-acetate 12-myristate") -> kin(p(HGNC:MAPK8))
# disambiguation to p38 family because p38 isoform is not specified
a(CHEBI:"phorbol 13-acetate 12-myristate") -> kin(p(SFAM:"MAPK p38 Family"))

SET Support = "These kinases are regulated by the reversible dual\
phosphorylation of conserved threonine and tyrosine residues."
p(HGNC:MAPK1,pmod(P,T)) => kin(p(HGNC:MAPK1))
p(HGNC:MAPK1,pmod(P,Y)) => kin(p(HGNC:MAPK1))
p(HGNC:MAPK8,pmod(P,T)) => kin(p(HGNC:MAPK8))
p(HGNC:MAPK8,pmod(P,Y)) => kin(p(HGNC:MAPK8))
p(HGNC:MAPK14,pmod(P,T)) => kin(p(SFAM:"MAPK p38 Family"))
p(HGNC:MAPK14,pmod(P,Y)) => kin(p(SFAM:"MAPK p38 Family"))

SET Support = "The dual specificity protein phosphatase MAPK\
phosphatase-1(MKP-1) has been shown to dephosphorylate and inactivate ERK2, SAPK, and\
p38 MAPK in transient transfection studies."
# disambiguation MKP-1 = HGNC DUSP1
phos(p(HGNC:DUSP1)) =| p(HGNC:MAPK1,pmod(P))
phos(p(HGNC:DUSP1)) =| p(HGNC:MAPK8,pmod(P))
phos(p(HGNC:DUSP1)) =| p(SFAM:"MAPK p38 Family",pmod(P))
phos(p(HGNC:DUSP1)) =| kin(p(HGNC:MAPK1))
phos(p(HGNC:DUSP1)) =| kin(p(HGNC:MAPK8))
phos(p(HGNC:DUSP1)) =| kin(p(SFAM:"MAPK p38 Family"))

SET Support = "Here we demonstrate that PMA treatment induces MKP-1\
protein expression in U937 cells, which is detectable within 30 min\
with maximal levels attained after 4 h."
a(CHEBI:"phorbol 13-acetate 12-myristate") -> p(HGNC:DUSP1)

SET Support = "Conditional expression of MKP-1 inhibited PMA-induced\
ERK2, SAPK, and p38 MAPK activity."
# have already represented that PMA induces ERK2, SAPK, and p38 activities
# have already represented that MPK-1 inhibits ERK2, SAPK, and p38 activities

SET Support = "This differential substrate specificity of MKP-1 can be\
functionally extended to nuclear transcriptional events in that PMAinduced\
c-Jun transcriptional activity was more sensitive to inhibition by MKP-1\
than either Elk-1 or c-Myc."
a(CHEBI:"phorbol 13-acetate 12-myristate") -> tscript(p(HGNC:JUN))
phos(p(HGNC:DUSP1)) -| tscript(p(HGNC:JUN))
a(CHEBI:"phorbol 13-acetate 12-myristate") -> tscript(p(HGNC:ELK1))
a(CHEBI:"phorbol 13-acetate 12-myristate") -> tscript(p(HGNC:MYC))
# the extent of inhibition of ELK1 and MYC by DUSP1 is not clear.
# This could potentially be represented as "inhibits" or "causesNoChange"

SET Support = "Conditional expression of MKP-1 also abolished the\
induction of endogenous MKP-1 protein expression in response to\
PMA treatment."
p(HGNC:DUSP1) -| (a(CHEBI:"phorbol 13-acetate 12-myristate") -> p(HGNC:DUSP1))

SET Support = "This negative feedback regulatory mechanism is likely due to\
MKP-1-mediated inhibition of ERK2, as studies utilizing the MEK1/2\
inhibitor PD98059 suggest that ERK2 activation is required for PMA-induced MKP-1\
expression."
