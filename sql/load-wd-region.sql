log_enable(3,1);
SET u{GRAPH} http://data.ga-group.nl/wd-region/;
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/region/wd-region.ttl';
ld_add('/home/freundt/author/region/wd-region.ttl', '$u{GRAPH}');
rdf_loader_run();
CHECKPOINT;

LOAD '/home/freundt/author/region/sql/prov-massage.sql';
