SET u{GRAPH} http://data.ga-group.nl/region.align/;
SET u{FILE} /home/freundt/author/region/region-align.ttl;
LOAD '/home/freundt/author/region/sql/load-generic.sql';

SET u{PREDx} dct:replaces;
SET u{PREDy} dct:isReplacedBy;
LOAD '/home/freundt/author/region/sql/infer-props.sql';
