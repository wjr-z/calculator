%require "3.2"
%language "c++"

%code requires {
    #include <string>
    
    #include <calc_lexer.hpp>
}

%define api.value.type {value}
%define api.namespace {wjr}

%parse-param {calc_lexer &lexer}

%code {
    #define yylex lexer.yylex
}

%token <integerVal> NUMBER
%token <bigintegerVal> BIGNUM
%token <strVal> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE 
%token LPAREN RPAREN EOL ASSIGN
%type <astNode> exp term factor program

%destructor {  
    std::destroy_at($$);
    g_biginteger_pool.deallocate($$);
} BIGNUM

%destructor { 
    std::destroy_at($$);
    g_string_pool.deallocate($$);
} IDENTIFIER
 
%right ASSIGN
%left PLUS MINUS
%left MULTIPLY DIVIDE
%nonassoc EOL
 
%%
 
program:
        exp EOL { }
        | program exp EOL { }
        ;
 
exp     : term { }
        | exp PLUS term { }
        | exp MINUS term { }
        | IDENTIFIER ASSIGN exp { }
        ;
 
term    : factor { }
        | term MULTIPLY factor { }
        | term DIVIDE factor { }
        ;
 
factor  : NUMBER { }
        | BIGNUM { std::cout << *$1 << std::endl; }
        | IDENTIFIER { }
        | LPAREN exp RPAREN { }
        ;
 
%%

void wjr::parser::error(const std::string &message)
{
    std::cerr << "Error: " << message << std::endl;
}