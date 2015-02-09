#include <ruby.h>
#include <stdio.h>
#include <stdbool.h>
#include <bel-parser.h>

VALUE mBEL = Qnil;

VALUE cputs(VALUE value) {
    ID to_s;
    ID puts;
    VALUE rslt;
#ifdef BELEXT_DEBUG
    fprintf(stderr, "%s:%d <%s>\n", __FILE__, __LINE__, __func__);
#endif
    to_s = rb_intern("to_s");
    puts = rb_intern("puts");

    rslt = rb_funcall(value, to_s, 0);
    rslt = rb_funcall(rb_mKernel, puts, 1, rslt);
    fprintf(stderr, "done\n");
    return Qnil;
}

void Init_bel_ext() {
#ifdef BELEXT_DEBUG
    fprintf(stderr, "%s:%d <%s>\n", __FILE__, __LINE__, __func__);
#endif
	mBEL = rb_define_module("BEL");
    rb_define_singleton_method(mBEL, "cputs", cputs, 1);
}

