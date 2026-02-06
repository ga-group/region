log_enable(3,1);
SPARQL CREATE SILENT GRAPH <http://data.ga-group.nl/wd-bloc/>;
SPARQL CLEAR GRAPH <http://data.ga-group.nl/wd-bloc/>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/region/wd-bloc.ttl';
ld_add('/home/freundt/author/region/wd-bloc.ttl', 'http://data.ga-group.nl/wd-bloc/');
rdf_loader_run();
CHECKPOINT;

SET u{GRAPH} http://data.ga-group.nl/wd-bloc/;
LOAD '/home/freundt/author/region/sql/prov-massage.sql';
