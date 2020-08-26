/*
 * Copyright 2020 Bytes & Brains
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
\echo Use "ALTER EXTENSION h3 UPDATE TO 'unreleased'" to load this file. \quit

CREATE OPERATOR <-> (
  LEFTARG = h3index,
  RIGHTARG = h3index,
  PROCEDURE = h3_distance,
  COMMUTATOR = <->
);

-- Broken since 1.0.0 on update path
CREATE OR REPLACE FUNCTION h3_to_geometry(h3index) RETURNS geometry
  AS $$ SELECT ST_SetSRID(h3_to_geo($1)::geometry, 4326) $$ IMMUTABLE STRICT PARALLEL SAFE LANGUAGE SQL;
CREATE OR REPLACE FUNCTION h3_to_geography(h3index) RETURNS geography
  AS $$ SELECT h3_to_geometry($1)::geography $$ IMMUTABLE STRICT PARALLEL SAFE LANGUAGE SQL;

-- ---------- ---------- ---------- ---------- ---------- ---------- ----------
-- GiST Operator Class (opclass_gist.c)
-- ---------- ---------- ---------- ---------- ---------- ---------- ----------

CREATE OR REPLACE FUNCTION h3index_gist_consistent(internal, h3index, smallint, oid, internal) RETURNS boolean
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_union(internal, internal) RETURNS h3index
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_compress(internal) RETURNS internal
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_decompress(internal) RETURNS internal
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_penalty(internal, internal, internal) RETURNS internal
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_picksplit(internal, internal) RETURNS internal
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_same(h3index, h3index, internal) RETURNS internal
    AS 'h3' LANGUAGE C STRICT;
CREATE OR REPLACE FUNCTION h3index_gist_distance(internal, h3index, smallint, oid, internal) RETURNS float8
    AS 'h3' LANGUAGE C STRICT;

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
    FUNCTION  8  (h3index, h3index) h3index_gist_distance(internal, h3index, smallint, oid, internal);
