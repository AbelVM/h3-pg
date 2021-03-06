/*
 * Copyright 2018-2019 Bytes & Brains
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

-- ---------- ---------- ---------- ---------- ---------- ---------- ----------
-- Grid Traversal Functions (traversal.c)
-- ---------- ---------- ---------- ---------- ---------- ---------- ----------

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_k_ring(h3index, k integer DEFAULT 1) RETURNS SETOF h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_k_ring(h3index, k integer) IS
'Produces indices within "k" distance of the origin index';

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_k_ring_distances(h3index, k integer DEFAULT 1, OUT index h3index, OUT distance int) RETURNS SETOF record
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_k_ring_distances(h3index, k integer) IS
'Produces indices within "k" distance of the origin index paired with their distance to the origin';

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_hex_ring(h3index, k integer DEFAULT 1) RETURNS SETOF h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_hex_ring(h3index, k integer) IS
'Returns the hollow hexagonal ring centered at origin with distance "k"';

-- Availability: 0.4.0
CREATE OR REPLACE FUNCTION h3_line(h3index, h3index) RETURNS SETOF h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_line(h3index, h3index) IS
'Given two H3 indexes, return the line of indexes between them (inclusive).

This function may fail to find the line between two indexes, for
example if they are very far apart. It may also fail when finding
distances for indexes on opposite sides of a pentagon.';

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_distance(h3index, h3index) RETURNS integer
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_distance(h3index, h3index) IS
'Returns the distance in grid cells between the two indices';    

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_experimental_h3_to_local_ij(origin h3index, index h3index) RETURNS POINT
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_experimental_h3_to_local_ij(origin h3index, index h3index) IS
'Produces local IJ coordinates for an H3 index anchored by an origin.
This function is experimental, and its output is not guaranteed to be compatible across different versions of H3.';

-- Availability: 0.2.0
CREATE OR REPLACE FUNCTION h3_experimental_local_ij_to_h3(origin h3index, coord POINT) RETURNS h3index
    AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
    COMMENT ON FUNCTION h3_experimental_local_ij_to_h3(origin h3index, coord POINT) IS
'Produces an H3 index from local IJ coordinates anchored by an origin.
This function is experimental, and its output is not guaranteed to be compatible across different versions of H3.';
