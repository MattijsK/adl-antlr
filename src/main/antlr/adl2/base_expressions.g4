//
//  description: Antlr4 grammar for openEHR Rules core syntax.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar base_expressions;

//
//  ============== Parser rules ==============
//

assertion: ( identifier ':' )? boolean_expr ;

//
// Expressions evaluating to boolean values
//

boolean_expr: boolean_expr boolean_binop boolean_leaf
    | boolean_leaf
    ;

boolean_leaf:
      boolean_literal
    | '(' boolean_expr ')'
    | arithmetic_relop_expr
    | SYM_NOT boolean_leaf
    ;

boolean_binop:
    | SYM_AND
    | SYM_XOR
    | SYM_OR
    | SYM_IMPLIES
    ;

boolean_literal:
      SYM_TRUE
    | SYM_FALSE
    ;

//
// Expressions evaluating to arithmetic values
//

arithmetic_relop_expr: arithmetic_arith_expr relational_binop arithmetic_arith_expr ;

arithmetic_leaf:
      integer_value
    | real_value
    | '(' arithmetic_arith_expr ')'
    | '-' arithmetic_leaf
    ;

arithmetic_arith_expr: arithmetic_arith_expr arithmetic_binop arithmetic_leaf
    | arithmetic_arith_expr '^'<assoc=right> arithmetic_leaf
    | arithmetic_leaf
    ;

relational_binop:
      SYM_EQ
    | SYM_NE
    | SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

arithmetic_binop:
      '/'
    | '*'
    | '+'
    | '-'
    ;