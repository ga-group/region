log_enable(3,1);
SET u{GRAPH} http://data.ga-group.nl/wd-bloc/;
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/region/wd-bloc.ttl';
ld_add('/home/freundt/author/region/wd-bloc.ttl', '$u{GRAPH}');
rdf_loader_run();
CHECKPOINT;

LOAD '/home/freundt/author/region/sql/prov-massage.sql';
