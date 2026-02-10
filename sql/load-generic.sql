log_enable(3,1);
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '$u{FILE}';
ld_add('$u{FILE}', '$u{GRAPH}');
rdf_loader_run();
CHECKPOINT;
