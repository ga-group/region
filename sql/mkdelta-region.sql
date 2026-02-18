log_enable(3,1);

SET u{ORIGG} region-origg;
SET u{PATCH} region-patch;

SPARQL CREATE SILENT GRAPH <$u{ORIGG}>;
SPARQL CLEAR GRAPH <$u{ORIGG}>;
SPARQL CREATE SILENT GRAPH <$u{PATCH}>;
SPARQL CLEAR GRAPH <$u{PATCH}>;

ECHO "preparing pretend orig graph ... ";
SPARQL
WITH <$u{ORIGG}>
INSERT {
	?x ?p ?o ;
		rdf:subject ?y
}
USING <$u{GRAPH}>
WHERE {
	?x dct:replaces ?y .
	## go with a whitelist
	VALUES ?p {
	lcc-cr:hasSubregion
	lcc-cr:isClassifiedBy
	foaf:name
	rdfs:label
	skos:definition
	}
	?y ?p ?o .
}
;
ECHO $ROWCNT"\n";

ECHO "preparing pretend patch graph ... ";
SPARQL
WITH <$u{PATCH}>
INSERT {
	?x ?p ?o ;
		rdf:subject ?x
}
USING <$u{GRAPH}>
WHERE {
	?x dct:replaces ?y .
	## go with a whitelist
	VALUES ?p {
	lcc-cr:hasSubregion
	lcc-cr:isClassifiedBy
	foaf:name
	rdfs:label
	skos:definition
	}
	?x ?p ?o .
}
;
ECHO $ROWCNT"\n";

SET u{DIFFG} $u{GRAPH};
LOAD '/home/freundt/author/region/sql/diff-mkdelta.sql';
LOAD '/home/freundt/author/region/sql/sweep-delta.sql';
LOAD '/home/freundt/author/region/sql/fixup-delta.sql';
LOAD '/home/freundt/author/region/sql/decor-delta.sql';
