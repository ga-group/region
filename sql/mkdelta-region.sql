log_enable(3,1);

SET u{ACTUAL} http://data.ga-group.nl/region/;
SET u{GRAPH} region-pretend;
SET u{STAGE} region-staging;
SET u{DIFFG} region-diff;

SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;

SPARQL CREATE SILENT GRAPH <$u{STAGE}>;
SPARQL CLEAR GRAPH <$u{STAGE}>;

SPARQL
WITH <$u{GRAPH}>
INSERT {
	?x ?p ?o
}
USING <$u{ACTUAL}>
WHERE {
	?x dct:replaces ?y .
	?y ?p ?o .
	FILTER(?p != dct:isReplacedBy)
}
;
ECHO $ROWCNT"\n";

SPARQL
WITH <$u{STAGE}>
INSERT {
	?x ?p ?o
}
USING <$u{ACTUAL}>
WHERE {
	?x dct:replaces ?y ;
		?p ?o .
	FILTER(?p != dct:isReplacedBy)
}
;
ECHO $ROWCNT"\n";

LOAD '/home/freundt/author/region/sql/diff-mkdelta.sql';
LOAD '/home/freundt/author/region/sql/unify-delta.sql';
LOAD '/home/freundt/author/region/sql/fixup-delta.sql';

SPARQL ADD <$u{DIFFG}> TO <$u{ACTUAL}>;

SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;

LOAD '/home/freundt/author/region/sql/prov-massage.sql';
