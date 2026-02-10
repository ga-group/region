log_enable(3,1);
SET u{GRAPH} http://eurovoc.europa.eu/;
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/data/data-source/onto/eurovoc-skos-ap-act.rdf';
ld_add('/data/data-source/onto/eurovoc-skos-ap-act.rdf', '$u{GRAPH}');
rdf_loader_run();
CHECKPOINT;
