SET u{GRAPH} http://data.ga-group.nl/region/;
SET u{FILE} /home/freundt/author/region/region.ttl;
LOAD '/home/freundt/author/region/sql/load-generic.sql';

SET u{PREDx} dct:replaces;
SET u{PREDy} dct:isReplacedBy;
LOAD '/home/freundt/author/region/sql/infer-props.sql';

SET u{PREDx} geopol:isSuccessorOf;
SET u{PREDy} geopol:isPredecessorOf;
LOAD '/home/freundt/author/region/sql/infer-props.sql';

LOAD '/home/freundt/author/region/sql/infer-variant.sql';

LOAD '/home/freundt/author/region/sql/prov-massage.sql';
CHECKPOINT;
