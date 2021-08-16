//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar cadl;
import cadl_primitives, odin, base_expressions;

//
//  ======================= Top-level Objects ========================
//

c_complex_object: rm_type_id '[' ( ROOT_ID_CODE | ID_CODE ) ']' c_occurrences? ( SYM_MATCHES '{' c_attribute_def+ default_value? '}' )? ;

// ======================== Components =======================

c_objects: c_regular_object_ordered+ | c_inline_primitive_object ;

sibling_order: ( SYM_AFTER | SYM_BEFORE ) '[' ID_CODE ']' ;

c_regular_object_ordered: sibling_order? c_regular_object ;

c_regular_object:
      c_complex_object
    | c_archetype_root
    | c_complex_object_proxy
    | archetype_slot
    | c_regular_primitive_object
    ;

c_archetype_root: SYM_USE_ARCHETYPE rm_type_id '[' ID_CODE ',' ARCHETYPE_REF ']' c_occurrences? ;

c_complex_object_proxy: SYM_USE_NODE rm_type_id '[' ID_CODE ']' c_occurrences? ADL_PATH ;

archetype_slot: SYM_ALLOW_ARCHETYPE rm_type_id '[' ID_CODE ']' (( c_occurrences? ( SYM_MATCHES '{' c_includes? c_excludes? '}' )? ) | SYM_CLOSED ) ;

c_attribute_def:
      c_attribute
    | c_attribute_tuple
    ;

default_value: SYM_DEFAULT SYM_EQ '<' odin_text '>';

c_regular_primitive_object: rm_type_id '[' ID_CODE ']' c_occurrences? ( SYM_MATCHES '{' c_inline_primitive_object '}' )? ;

// We match regexes here, even though technically they are C_STRING instances. This is because the only
// workable solution to match a regex unambiguously appears to be to match with enclosing {}, which means
// as a C_OBJECT alternative, not as a C_STRING.
c_attribute: (ADL_PATH | rm_attribute_id) c_existence? c_cardinality? ( SYM_MATCHES '{' c_objects '}' )? ;

c_attribute_tuple : '[' rm_attribute_id ( ',' rm_attribute_id )* ']' SYM_MATCHES '{' c_primitive_tuple ( ',' c_primitive_tuple )* '}' ;

c_primitive_tuple : '[' '{' c_inline_primitive_object '}' ( ',' '{' c_inline_primitive_object '}' )* ']' ;

c_includes : SYM_INCLUDE assertion+ ;
c_excludes : SYM_EXCLUDE assertion+ ;

c_existence: SYM_EXISTENCE SYM_MATCHES '{' existence '}' ;
existence: INTEGER | INTEGER '..' INTEGER ;

c_cardinality    : SYM_CARDINALITY SYM_MATCHES '{' cardinality '}' ;
cardinality      : multiplicity ( multiplicity_mod multiplicity_mod? )? ; // max of two
ordering_mod     : ';' ( SYM_ORDERED | SYM_UNORDERED ) ;
unique_mod       : ';' SYM_UNIQUE ;
multiplicity_mod : ordering_mod | unique_mod ;

c_occurrences : SYM_OCCURRENCES SYM_MATCHES '{' multiplicity '}' ;
multiplicity  : INTEGER | '*' | INTEGER '..' ( INTEGER | '*' ) ;

//
// ---------- Lexer patterns -----------------
//

// CADL keywords
SYM_EXISTENCE   : [Ee][Xx][Ii][Ss][Tt][Ee][Nn][Cc][Ee] ;
SYM_OCCURRENCES : [Oo][Cc][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Ee][Ss] ;
SYM_CARDINALITY : [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy] ;
SYM_ORDERED     : [Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNORDERED   : [Uu][Nn][Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNIQUE      : [Uu][Nn][Ii][Qq][Uu][Ee] ;
SYM_USE_NODE    : [Uu][Ss][Ee][_][Nn][Oo][Dd][Ee] ;
SYM_USE_ARCHETYPE : [Uu][Ss][Ee][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_ALLOW_ARCHETYPE : [Aa][Ll][Ll][Oo][Ww][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_INCLUDE     : [Ii][Nn][Cc][Ll][Uu][Dd][Ee] ;
SYM_EXCLUDE     : [Ee][Xx][Cc][Ll][Uu][Dd][Ee] ;
SYM_AFTER       : [Aa][Ff][Tt][Ee][Rr] ;
SYM_BEFORE      : [Bb][Ee][Ff][Oo][Rr][Ee] ;
SYM_CLOSED      : [Cc][Ll][Oo][Ss][Ee][Dd] ;

SYM_DEFAULT     : '_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt] ;
