// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "lexer.h"
#include "util/compiler.h"
#include <cassert>
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <iostream>

using namespace std;

#define YYCTYPE  unsigned char
#define YYCURSOR yycursor
#define YYLIMIT  yylimit
#define YYTEXT   yytext
#define YYMARKER yymarker
#define YYLENGTH ((size_t)(YYCURSOR - YYTEXT))
#define YYFILL(n) do { if ((YYCURSOR + n) >= (YYLIMIT + YYMAXFILL)) \
                         { return END; } } while (0)

static const YYCTYPE *YYCURSOR;
static const YYCTYPE *YYLIMIT;
static const YYCTYPE *YYTEXT;
static const YYCTYPE *YYMARKER;
static const YYCTYPE *tag1, *yyt1;

#if 0
# define YYRESTART() cout << "restart line: " << yylineno << '\n'; goto restart
# define YYDEBUG(s, c) cout << "state: " << s << " char: " << c << '\n'
#else
# define YYRESTART() goto restart
# define YYDEBUG(s, c)
#endif

/*!max:re2c */
static_assert(YYMAXFILL <= parse::LEXER_READ_AHEAD);

namespace parse {

unsigned yylineno;
yylval_t yylval;

const char *const token_name[] = {
#define TOKEN(x) #x,
#include "tokens.h"
#undef TOKEN
};

static void error(string &&str) {
  throw LexException("[Lex] " + std::move(str), yylineno);
}

static void COPY_STR(unsigned off = 0) {
  assert(off <= YYLENGTH);
  yylval.str = { (const char*)YYTEXT + off, YYLENGTH - off };
}

void yylex_init(string_view str) {
  YYCURSOR = (const YYCTYPE*)str.data();
  YYLIMIT  = (const YYCTYPE*)str.data() + str.size();
  yylineno = 1;
}

token yylex() {
restart:
  if (YYCURSOR >= YYLIMIT)
    return END;
  YYTEXT = YYCURSOR;

/*!re2c
space = [ \t];
re2c:yyfill:check = 0;

"\r"? "\n" {
  ++yylineno;
  YYRESTART();
}

space+ {
  YYRESTART();
}

","  { return COMMA;  }


"("  { return LPAREN; }
")"  { return RPAREN; }

"{"  { return LCURLY; }
"}"  { return RCURLY; }

"copy" { return COPY; }

"bitreverse" { return BITREVERSE; }
"bswap"      { return BSWAP;      }
"ctpop"      { return CTPOP;      }
"ctlz"       { return CTLZ;       }
"cttz"       { return CTTZ;       }
"fneg"       { return FNEG;       }
"fabs"       { return FABS;       }
"fceil"      { return FCEIL;      }
"ffloor"     { return FFLOOR;     }
"frint"      { return FRINT;      }
"fnearbyint" { return FNEARBYINT; }
"fround"     { return FROUND;     }
"froundeven" { return FROUNDEVEN; }
"ftrunc"     { return FTRUNC;     }

"conv_fpext"   { return CONV_FPEXT;   }
"conv_fptrunc" { return CONV_FPTRUNC; }
"conv_uitofp"  { return CONV_UITOFP;  }
"conv_sitofp"  { return CONV_SITOFP;  }
"conv_fptoui"  { return CONV_FPTOUI;  }
"conv_fptosi"  { return CONV_FPTOSI;  }

"and"  { return BAND; }
"or"   { return BOR;  }
"xor"  { return BXOR; }

"add"  { return ADD;  }
"sub"  { return SUB;  }
"mul"  { return MUL;  }
"sdiv" { return SDIV; }
"udiv" { return UDIV; }

"lshr" { return LSHR; }
"ashr" { return ASHR; }
"shl"  { return SHL;  }

"umax" { return UMAX; }
"umin" { return UMIN; }
"smax" { return SMAX; }
"smin" { return SMIN; }

"fadd" { return FADD; }
"fsub" { return FSUB; }
"fmul" { return FMUL; }
"fdiv" { return FDIV; }

"fmaxnum" { return FMAXNUM; }
"fminnum" { return FMINNUM; }
"fmaximum" { return FMAXIMUM; }
"fminimum" { return FMINIMUM; }
"copysign" { return COPYSIGN; }

"icmp_eq"  { return EQ;  }
"icmp_ne"  { return NE;  }
"icmp_ult" { return ULT; }
"icmp_ule" { return ULE; }
"icmp_ugt" { return UGT; }
"icmp_uge" { return UGE; }
"icmp_slt" { return SLT; }
"icmp_sle" { return SLE; }
"icmp_sgt" { return SGT; }
"icmp_sge" { return SGE; }

"fcmp_t"   { return FCMP_TRUE;   }
"fcmp_oeq" { return FCMP_OEQ; }
"fcmp_ogt" { return FCMP_OGT; }
"fcmp_oge" { return FCMP_OGE; }
"fcmp_olt" { return FCMP_OLT; }
"fcmp_ole" { return FCMP_OLE; }
"fcmp_one" { return FCMP_ONE; }
"fcmp_ord" { return FCMP_ORD; }
"fcmp_ueq" { return FCMP_UEQ; }
"fcmp_ugt" { return FCMP_UGT; }
"fcmp_uge" { return FCMP_UGE; }
"fcmp_ult" { return FCMP_ULT; }
"fcmp_ule" { return FCMP_ULE; }
"fcmp_une" { return FCMP_UNE; }
"fcmp_uno" { return FCMP_UNO; }
"fcmp_f"   { return FCMP_FALSE; }

"blend"   { return BLEND;   }
"shuffle" { return SHUFFLE; }
"select"  { return SELECT;  }
"insertelement" { return INSERTELEMENT; }
"extractelement" { return EXTRACTELEMENT; }

"conv_zext"  { return CONV_ZEXT;  }
"conv_sext"  { return CONV_SEXT;  }
"conv_trunc" { return CONV_TRUNC; }

"var" { return VAR;  }
"reservedconst" { return CONST; }

"half"   { return HALF; }
"float"  { return FLOAT; }
"double" { return DOUBLE; }
"fp128"  { return FP128; }


"x86_" [a-zA-Z0-9_]+ { COPY_STR(); return X86BINARY; }

"%" [a-zA-Z0-9_.]+ {
  COPY_STR();
  return REGISTER;
}

"i" [1-9][0-9]* {
  yylval.num = strtoull((char*)YYTEXT+1, nullptr, 10);
  return INT_TYPE;
}

"<" space* @tag1 [1-9][0-9]* space* "x" {
  yylval.num = strtoull((char*)tag1, nullptr, 10);
  return VECTOR_TYPE_PREFIX;
}
">"  { return CSGT; }

"\|" @tag1 [<>0-9a-zA-Z- ,.\+]* "\|"  {
  COPY_STR();
  return LITERAL;
}

"b" "-"?[0-9]+ {
  yylval.num = strtoull((char*)YYTEXT + 1, nullptr, 10);
  return BITS;
}

"-"?[0-9]+ {
  COPY_STR();
  return NUM_STR;
}

* { error("couldn't parse: '" + string((char*)YYTEXT, 16) + '\''); }
*/

  UNREACHABLE();
}

}
