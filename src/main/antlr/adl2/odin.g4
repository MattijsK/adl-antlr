//
//	description: Antlr4 grammar for Object Data Instance Notation (ODIN)
//	author:      Thomas Beale <thomas.beale@openehr.org>
//	support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//	copyright:   Copyright (c) 2015 openEHR Foundation
//	license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar odin;
import odin_values;

//
// -------------------------- Parse Rules --------------------------
//

odin_text :
      attr_vals
    | object_value_block
	;

attr_vals : ( attr_val ';'? )+ ;

attr_val : rm_attribute_id '=' object_block ;

object_block :
      object_value_block
    | object_reference_block
    ;

object_value_block : ( '(' rm_type_id ')' )? '<' ( primitive_object | attr_vals? | keyed_object* ) '>' ;

keyed_object : '[' key_id ']' '=' object_block ;

key_id :
      string_value
    | integer_value
    | date_value
    | time_value
    | date_time_value
    ;

// ------ leaf types ------

primitive_object :
      primitive_value 
    | primitive_list_value 
    | primitive_interval_value 
    ;

primitive_value :
      string_value 
    | integer_value 
    | real_value 
    | boolean_value 
    | character_value 
    | term_code_value
    | date_value
    | time_value 
    | date_time_value 
    | duration_value 
    | uri_value 
    ;

primitive_list_value : 
      string_list_value 
    | integer_list_value 
    | real_list_value 
    | boolean_list_value 
    | character_list_value 
    | term_code_list_value
    | date_list_value
    | time_list_value 
    | date_time_list_value 
    | duration_list_value 
    ;

primitive_interval_value :
      integer_interval_value
    | real_interval_value
    | date_interval_value
    | time_interval_value
    | date_time_interval_value
    | duration_interval_value
    ;

object_reference_block : '<' odin_path_list '>' ;

odin_path_list     : odin_path ( ( ',' odin_path )+ | SYM_LIST_CONTINUE )? ;
odin_path          : '/' | odin_path_segment+ ;
odin_path_segment  : '/' odin_path_element ;
odin_path_element  : rm_attribute_id ( '[' ( STRING | INTEGER ) ']' )? ;
