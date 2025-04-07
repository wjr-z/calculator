%{
    #include <iostream>

    #include "calc.tab.hpp"

    #include <calc_lexer.hpp>
    #include <wjr/charconv.hpp>

    #undef  YY_DECL
    #define YY_DECL int wjr::calc_lexer::yylex(value *const yylval)

    using std::cin;
    using std::cout;
%}

%option c++ noyywrap
%option yyclass="calc_lexer"

%%

[0-9]+                  {
    auto* ptr = g_biginteger_pool.allocate();
    wjr::construct_at(ptr, span<const char>(yytext, yytext + yyleng));
    yylval->bigintegerVal = ptr;
    return parser::token::BIGNUM;
}
[[:alpha:]][[:alnum:]]* { 
    auto* ptr = g_string_pool.allocate();
    wjr::construct_at(ptr, yytext, yytext + yyleng);
    yylval->strVal = ptr;
    return parser::token::IDENTIFIER;
}
"\n"                    { return parser::token::EOL; }
[ \t\r]                 { /* skip white space */ }
"+"                     { return parser::token::PLUS; }
"-"                     { return parser::token::MINUS; }
"*"                     { return parser::token::MULTIPLY; }
"/"                     { return parser::token::DIVIDE; }
"("                     { return parser::token::LPAREN; }
")"                     { return parser::token::RPAREN; }
"="                     { return parser::token::ASSIGN; }
.                       {
    fprintf(stderr, "lexical error at line %d: unexpected character '%s'\n", yylineno, yytext);
    return yytext[0]; 
}

%%