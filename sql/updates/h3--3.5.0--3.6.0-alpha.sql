/*
 * Copyright 2019 Bytes & Brains
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "ALTER EXTENSION h3 UPDATE TO '3.6.0-alpha'" to load this file. \quit

-- Hierarchical grid functions (hierarchy.c)
CREATE OR REPLACE FUNCTION h3_to_center_child(h3index, resolution integer DEFAULT -1) RETURNS h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_to_parent(h3index, resolution integer) IS
'Returns the center child (finer) index contained by input index at given resolution';

-- Miscellaneous H3 functions (miscellaneous.c)
CREATE OR REPLACE FUNCTION h3_get_pentagon_indexes(resolution integer) RETURNS SETOF h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_get_res_0_indexes() IS
'All the pentagon H3 indexes at the specified resolution.';

-- PostgreSQL operators
DROP FUNCTION IF EXISTS h3_to_string(h3index);
DROP FUNCTION IF EXISTS h3_string_to_h3(cstring);

CREATE OR REPLACE FUNCTION h3index_overlap(h3index, h3index) RETURNS boolean
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_contains(h3index, h3index) RETURNS boolean
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_contained(h3index, h3index) RETURNS boolean
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR <-> (
  LEFTARG = h3index,
  RIGHTARG = h3index,
  PROCEDURE = h3_distance,
  COMMUTATOR = <->
);
CREATE OPERATOR && (
	LEFTARG = h3index,
	RIGHTARG = h3index,
	PROCEDURE = h3index_overlap,
	COMMUTATOR = &&,
    RESTRICT = contsel,
    JOIN = contjoinsel
);
CREATE OPERATOR @> (
    LEFTARG = h3index,
    RIGHTARG = h3index,
    PROCEDURE = h3index_contains,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);
CREATE OPERATOR <@ (
    LEFTARG = h3index,
    RIGHTARG = h3index,
    PROCEDURE = h3index_contained,
    COMMUTATOR = @>,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);

-- GiST operator class
CREATE OR REPLACE FUNCTION h3index_gist_consistent(internal, h3index, smallint, oid, internal) RETURNS boolean
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_union(internal, internal) RETURNS h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_compress(internal) RETURNS internal
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_decompress(internal) RETURNS internal
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_penalty(internal, internal, internal) RETURNS internal
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_picksplit(internal, internal) RETURNS internal
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_same(h3index, h3index, internal) RETURNS internal
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_gist_distance(internal, h3index, smallint, oid, internal) RETURNS integer
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR CLASS gist_h3index_ops DEFAULT FOR TYPE h3index USING gist AS
    OPERATOR  3   &&  ,
    OPERATOR  6   =   ,
    OPERATOR  7   @>  ,
    OPERATOR  8   <@  ,
    OPERATOR  15  <-> (h3index, h3index) FOR ORDER BY integer_ops,

    FUNCTION  1  h3index_gist_consistent(internal, h3index, smallint, oid, internal),
    FUNCTION  2  h3index_gist_union(internal, internal),
    FUNCTION  3  h3index_gist_compress(internal),
    FUNCTION  4  h3index_gist_decompress(internal),
    FUNCTION  5  h3index_gist_penalty(internal, internal, internal),
    FUNCTION  6  h3index_gist_picksplit(internal, internal),
    FUNCTION  7  h3index_gist_same(h3index, h3index, internal),
    FUNCTION  8  h3index_gist_distance(internal, h3index, smallint, oid, internal);

-- SP-GiST operator class
CREATE OR REPLACE FUNCTION h3index_spgist_config(internal, internal) RETURNS void
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_spgist_choose(internal, internal) RETURNS void
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_spgist_picksplit(internal, internal) RETURNS void
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_spgist_inner_consistent(internal, internal) RETURNS void
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE OR REPLACE FUNCTION h3index_spgist_leaf_consistent(internal, internal) RETURNS bool
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR CLASS spgist_h3index_ops DEFAULT FOR TYPE h3index USING spgist AS
    OPERATOR  6   =   ,
    OPERATOR  7   @>  ,
    OPERATOR  8  <@   ,
   
    FUNCTION  1  h3index_spgist_config(internal, internal),
    FUNCTION  2  h3index_spgist_choose(internal, internal),
    FUNCTION  3  h3index_spgist_picksplit(internal, internal),
    FUNCTION  4  h3index_spgist_inner_consistent(internal, internal),
    FUNCTION  5  h3index_spgist_leaf_consistent(internal, internal);