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
        ).to be_a(LibBEL::BelAst)
      end
    end

    it "BEL expressions' parsed AST is correct" do
      EXPRESSIONS.each do |term, ast_string|
        puts "testing expression: #{term}"
        expect(
          LibBEL::bel_ast_as_string(subject.parse(term))
        ).to eq(ast_string)
      end
    end

    EXPRESSIONS = {
      # simple term
      'p(HGNC:AKT1)' =>
      'TERM[1][0, 12] fx(p)[0, 1] ARG[1] NV[1][2, 11] pfx(HGNC)[2, 6] val(AKT1)[7, 11] ARG[0] (null) (null) ',
      # quoted parameter
      'bp(GOBP:"apoptotic process")' =>
      'TERM[1][0, 28] fx(bp)[0, 2] ARG[1] NV[1][3, 27] pfx(GOBP)[3, 7] val("apoptotic process")[8, 27] ARG[0] (null) (null) ',
      # multi-parameter term
      'p(HGNC:AKT1, pmod(P, S, 300))' =>
      'TERM[1][0, 26] fx(p)[0, 1] ARG[1] NV[1][2, 11] pfx(HGNC)[2, 6] val(AKT1)[7, 11] ARG[1] TERM[1][12, 25] fx(pmod)[12, 16] ARG[1] NV[1][17, 18] pfx((null)) val(P)[17, 18] ARG[1] NV[1][19, 20] pfx((null)) val(S)[19, 20] ARG[1] NV[1][21, 24] pfx((null)) val(300)[21, 24] ARG[0] (null) (null) ARG[0] (null) (null) ',
      # nested term
      'tscript(p(HGNC:AKT1))' =>
      'TERM[1][0, 21] fx(tscript)[0, 7] ARG[1] TERM[1][8, 20] fx(p)[8, 9] ARG[1] NV[1][10, 19] pfx(HGNC)[10, 14] val(AKT1)[15, 19] ARG[0] (null) (null) ARG[0] (null) (null) ',
      # multi-parameter nested term
      'complex(p(HGNC:AKT1), p(HGNC:AKT2), p(HGNC:AKT3))' =>
      'TERM[1][0, 47] fx(complex)[0, 7] ARG[1] TERM[1][8, 20] fx(p)[8, 9] ARG[1] NV[1][10, 19] pfx(HGNC)[10, 14] val(AKT1)[15, 19] ARG[0] (null) (null) ARG[1] TERM[1][21, 33] fx(p)[21, 22] ARG[1] NV[1][23, 32] pfx(HGNC)[23, 27] val(AKT2)[28, 32] ARG[0] (null) (null) ARG[1] TERM[1][34, 46] fx(p)[34, 35] ARG[1] NV[1][36, 45] pfx(HGNC)[36, 40] val(AKT3)[41, 45] ARG[0] (null) (null) ARG[0] (null) (null) ',
      # long form; quoted; multi-parameter
      'translocation(p(HGNC:FOXO1),GOCCACC:"GO:0005737",GOCCACC:"GO:0005634")' =>
      'TERM[1][0, 70] fx(translocation)[0, 13] ARG[1] TERM[1][14, 27] fx(p)[14, 15] ARG[1] NV[1][16, 26] pfx(HGNC)[16, 20] val(FOXO1)[21, 26] ARG[0] (null) (null) ARG[1] NV[1][28, 48] pfx(GOCCACC)[28, 35] val("GO:0005737")[36, 48] ARG[1] NV[1][49, 69] pfx(GOCCACC)[49, 56] val("GO:0005634")[57, 69] ARG[0] (null) (null) ',
    }
  end
end
