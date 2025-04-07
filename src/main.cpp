#include <calc_lexer.hpp>
#include <calc.tab.hpp>

int main() {
    wjr::calc_lexer lexer;
    wjr::parser parser(lexer);
    return parser();
}