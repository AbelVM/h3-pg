Tree(statements, ['', <__main__.Function object at 0x0000025255D85108>, <__main__.Function object at 0x0000025255D85688>, '', <__main__.Function object at 0x0000025255D85C08>, '', <__main__.Function object at 0x0000025255DBC1C8>, '', <__main__.Function object at 0x0000025255DBC848>, '', <__main__.Function object at 0x0000025255DBCEC8>, '', <__main__.Function object at 0x0000025255D91588>, '', <__main__.Function object at 0x0000025255D91B88>, '', <__main__.Function object at 0x0000025255D91F48>, '', <__main__.Function object at 0x0000025255DB7348>, '', <__main__.Function object at 0x0000025255DB76C8>, '', <__main__.Function object at 0x0000025255DB7A48>, '', <__main__.Function object at 0x0000025255DB7DC8>, ''])

## Custom Type

Tree(statements, [<__main__.Function object at 0x0000025255AE59C8>, 'Indexes the location at the specified resolution', <__main__.Function object at 0x0000025255D88688>, 'Finds the centroid of the index', <__main__.Function object at 0x0000025255D9DB08>, 'Finds the boundary of the index, second argument extends coordinates when crossing 180th meridian to help visualization'])

## Indexing Functions (indexing.c)

Tree(statements, [<__main__.Function object at 0x0000025255F15148>, 'Returns the resolution of the index', <__main__.Function object at 0x0000025255D91B88>, 'Returns the base cell number of the index', <__main__.Function object at 0x0000025255D913C8>, 'Returns true if the given H3Index is valid', <__main__.Function object at 0x0000025255ADE948>, 'Returns true if this index has a resolution with Class III orientation', <__main__.Function object at 0x0000025255ADED88>, 'Returns true if this index represents a pentagonal cell', <__main__.Function object at 0x0000025255D86488>, 'Find all icosahedron faces intersected by a given H3 index'])

## Index Inspection Functions (inspection.c)

Tree(statements, [<__main__.Function object at 0x0000025255DBC408>, 'Produces indices within "k" distance of the origin index', <__main__.Function object at 0x0000025255DBD3C8>, 'Produces indices within "k" distance of the origin index paired with their distance to the origin', <__main__.Function object at 0x0000025255DBDE08>, 'Returns the hollow hexagonal ring centered at origin with distance "k"', <__main__.Function object at 0x0000025255F12088>, 'Given two H3 indexes, return the line of indexes between them (inclusive).\n\nThis function may fail to find the line between two indexes, for\nexample if they are very far apart. It may also fail when finding\ndistances for indexes on opposite sides of a pentagon.', <__main__.Function object at 0x0000025255DB6288>, 'Returns the distance in grid cells between the two indices', <__main__.Function object at 0x0000025255DB62C8>, 'Produces local IJ coordinates for an H3 index anchored by an origin.\nThis function is experimental, and its output is not guaranteed to be compatible across different versions of H3.', <__main__.Function object at 0x0000025255DB67C8>, 'Produces an H3 index from local IJ coordinates anchored by an origin.\nThis function is experimental, and its output is not guaranteed to be compatible across different versions of H3.'])

## Grid Traversal Functions (traversal.c)

Tree(statements, [<__main__.Function object at 0x0000025255ADE608>, 'Returns the parent of the given index', <__main__.Function object at 0x0000025255DBCD08>, 'Returns the set of children of the given index', <__main__.Function object at 0x0000025255F15148>, 'Returns the center child (finer) index contained by input index at given resolution', <__main__.Function object at 0x0000025255DB6A08>, 'Compacts the given array as best as possible', <__main__.Function object at 0x0000025255DB6388>, 'Uncompacts the given array at the given resolution. If no resolution is given, then it is chosen as one higher than the highest resolution in the set', None, <__main__.Function object at 0x0000025255DB7448>, 'Slower version of H3ToChildren but allocates less memory'])

## Hierarchical Grid Functions (hierarchy.c)

Tree(statements, [<__main__.Function object at 0x0000025255D86188>, 'Takes an exterior polygon [and a set of hole polygon] and returns the set of hexagons that best fit the structure', <__main__.Function object at 0x0000025255D9DB48>, 'Create a LinkedGeoPolygon describing the outline(s) of a set of hexagons. Polygon outlines will follow GeoJSON MultiPolygon order: Each polygon will have one outer loop, which is first in the list, followed by any holes'])

## Region Functions (regions.c)

Tree(statements, [<__main__.Function object at 0x0000025255DB6048>, 'Returns true if the given indices are neighbors', <__main__.Function object at 0x0000025255ADE948>, 'Returns a unidirectional edge H3 index based on the provided origin and destination.', <__main__.Function object at 0x0000025255D91388>, 'Returns true if the given edge is valid.', <__main__.Function object at 0x0000025255D91588>, 'Returns the origin index from the given edge.', <__main__.Function object at 0x0000025255F129C8>, 'Returns the destination index from the given edge.', <__main__.Function object at 0x0000025255DB4108>, 'Returns the pair of indices from the given edge.', <__main__.Function object at 0x0000025255DB4508>, 'Returns all unidirectional edges with the given index as origin', <__main__.Function object at 0x0000025255DB4908>, 'Provides the coordinates defining the unidirectional edge.'])

## Unidirectional Edge Functions (uniedges.c)

Tree(statements, [<__main__.Function object at 0x0000025255AE53C8>, 'Average hexagon area in square (kilo)meters at the given resolution.', <__main__.Function object at 0x0000025255DBD688>, 'Average hexagon edge length in (kilo)meters at the given resolution.', <__main__.Function object at 0x0000025255DBD748>, 'Number of unique H3 indexes at the given resolution.', <__main__.Function object at 0x0000025255F12788>, 'Returns all 122 resolution 0 indexes.', <__main__.Function object at 0x0000025255AFC4C8>, 'All the pentagon H3 indexes at the specified resolution.'])

## Miscellaneous H3 Functions (miscellaneous.c)

Tree(statements, [<__main__.Function object at 0x0000025255D88448>, 'Get the currently installed version of the extension.'])

## Extension Specific Functions (extension.c)

Tree(statements, [<__main__.Function object at 0x0000025255DBD488>, ''])

## B-tree Operator Class (opclass_btree.c)

Tree(statements, [<__main__.Function object at 0x0000025255DBDE08>, ''])

## Hash Operator Class (opclass_hash.c)

Tree(statements, [<__main__.Function object at 0x0000025255D913C8>, <__main__.Function object at 0x0000025255D91BC8>, <__main__.Function object at 0x0000025255D91508>, <__main__.Function object at 0x0000025255AFC788>, <__main__.Function object at 0x0000025255DB6448>, <__main__.Function object at 0x0000025255DB66C8>, <__main__.Function object at 0x0000025255DB6108>, <__main__.Function object at 0x0000025255AF5D48>, '', 'Allow casts from h3index to native point', '', 'Allow casts from h3index to PostGIS geometry', '', 'Allow casts from h3index to PostGIS geography'])

## PostGIS Functions

