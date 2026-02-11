log_enable(3,1);

SET u{GRAPH} http://data.ga-group.nl/wd-region/;
SET u{STAGE} region-staging;
SET u{DIFFG} region-diff;

SPARQL CREATE SILENT GRAPH <$u{STAGE}>;
SPARQL CLEAR GRAPH <$u{STAGE}>;

DELETE FROM DB.DBA.LOAD_LIST WHERE ll_file = '/home/freundt/author/region/wd-region.ttl.repl';
ld_add('/home/freundt/author/region/wd-region.ttl.repl', '$u{STAGE}');
rdf_loader_run();
CHECKPOINT;

LOAD '/home/freundt/author/region/sql/diff-noins.sql';
LOAD '/home/freundt/author/region/sql/unify-delta.sql';
LOAD '/home/freundt/author/region/sql/fixup-delta.sql';
LOAD '/home/freundt/author/region/sql/patch.sql';

SPARQL ADD <$u{STAGE}> TO <$u{GRAPH}>;
SPARQL ADD <$u{DIFFG}> TO <$u{GRAPH}>;

LOAD '/home/freundt/author/region/sql/prov-massage.sql';
