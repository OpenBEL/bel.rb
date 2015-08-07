require 'bel'

describe BEL::Parser do

  describe "#parse" do

    it "nil expressions yield nil" do
      expect(
        subject.parse(nil)
      ).to eq(nil)
    end

    it "BEL expressions parse to an AST class" do
      EXPRESSIONS.each do |term, _|
        expect(
          subject.parse(term)
        ).to be_a(BEL::LibBEL::BelAst)
      end
    end

    it "BEL expressions' parsed AST is correct" do
      EXPRESSIONS.each do |term, ast_string|
        expect(
          BEL::LibBEL::bel_ast_as_string(subject.parse(term))
        ).to eq(ast_string)
      end
    end

    EXPRESSIONS = {
      # simple term
      'p(HGNC:AKT1)' =>
      'STATEMENT SUBJECT TERM fx(p) ARG NV pfx(HGNC) val(AKT1) ARG (null) (null) (null) (null) ',
      # quoted parameter
      'bp(GOBP:"apoptotic process")' =>
      'STATEMENT SUBJECT TERM fx(bp) ARG NV pfx(GOBP) val("apoptotic process") ARG (null) (null) (null) (null) ',
      # multi-parameter term
      'p(HGNC:AKT1, pmod(P, S, 300))' =>
      'STATEMENT SUBJECT TERM fx(p) ARG NV pfx(HGNC) val(AKT1) ARG TERM fx(pmod) ARG NV pfx((null)) val(P) ARG NV pfx((null)) val(S) ARG NV pfx((null)) val(300) ARG (null) (null) ARG (null) (null) (null) (null) ',
      # nested term
      'tscript(p(HGNC:AKT1))' =>
      'STATEMENT SUBJECT TERM fx(tscript) ARG TERM fx(p) ARG NV pfx(HGNC) val(AKT1) ARG (null) (null) ARG (null) (null) (null) (null) ',
      # multi-parameter nested term
      'complex(p(HGNC:AKT1), p(HGNC:AKT2), p(HGNC:AKT3))' =>
      'STATEMENT SUBJECT TERM fx(complex) ARG TERM fx(p) ARG NV pfx(HGNC) val(AKT1) ARG (null) (null) ARG TERM fx(p) ARG NV pfx(HGNC) val(AKT2) ARG (null) (null) ARG TERM fx(p) ARG NV pfx(HGNC) val(AKT3) ARG (null) (null) ARG (null) (null) (null) (null) ',
      # long form; quoted; multi-parameter
      'translocation(p(HGNC:FOXO1),GOCCACC:"GO:0005737",GOCCACC:"GO:0005634")' =>
      'STATEMENT SUBJECT TERM fx(translocation) ARG TERM fx(p) ARG NV pfx(HGNC) val(FOXO1) ARG (null) (null) ARG NV pfx(GOCCACC) val("GO:0005737") ARG NV pfx(GOCCACC) val("GO:0005634") ARG (null) (null) (null) (null) ',
      # simple statement
      'p(HGNC:AKT1) -> bp(GOBP:"apoptotic process")' =>
      'STATEMENT SUBJECT TERM fx(p) ARG NV pfx(HGNC) val(AKT1) ARG (null) (null) (null) OBJECT REL rel(->) (null) TERM fx(bp) ARG NV pfx(GOBP) val("apoptotic process") ARG (null) (null) '
    }
  end
end
