#ifndef WJR_CALC_LEXER_HPP__
#define WJR_CALC_LEXER_HPP__

#if !defined(yyFlexLexerOnce)
    #include <FlexLexer.h>
#endif

#include <wjr/biginteger.hpp>
#include <wjr/memory/object_pool.hpp>

namespace wjr {

extern object_pool<biginteger> g_biginteger_pool;
extern object_pool<std::string> g_string_pool;

enum NodeKind {
    Binary,
};

class AstNode {
public:
    AstNode(NodeKind kind) : m_kind(kind) {}

    virtual ~AstNode() = 0;

    NodeKind kind() const { return m_kind; }

private:
    NodeKind m_kind;
};

class BinaryNode : AstNode {
public:
    enum Token { ADD, SUB, MUL, DIV };

    BinaryNode(Token token, AstNode *left, AstNode *right)
        : AstNode(Binary), m_token(token), m_left(left), m_right(right) {}

private:
    Token m_token;
    AstNode *m_left;
    AstNode *m_right;
};

union value {
    uint64_t integerVal;
    biginteger *bigintegerVal;
    std::string *strVal;
};

class calc_lexer : public yyFlexLexer {
public:
    int yylex(value *const yylval);
};
} // namespace wjr

#endif // WJR_CALC_LEXER_HPP__