log_enable(3,1);

-- old stuff in u{ORIGG}
-- new stuff in u{PATCH}
-- deltas go to u{DIFFG}

ECHO "changes ... ";
## -s p A B
## +s p A C
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:insertion ?oin ;
			delta:deletion ?oou
		] ;
		delta:patch-date ?dd ;
		rdf:subject ?s ;
		prov:generatedAtTime ?now
}
USING <$u{ORIGG}>
USING <$u{PATCH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{PATCH}> {
	?s ?p ?oin
	}
	GRAPH <$u{ORIGG}> {
	?s ?p ?oou
	}
	FILTER(?oin != ?oou)
	FILTER NOT EXISTS {
		GRAPH <$u{PATCH}> {
		?s ?p ?oou
		}
	}
	FILTER NOT EXISTS {
		GRAPH <$u{ORIGG}> {
		?s ?p ?oin
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != dct:modified)
	FILTER(!STRSTARTS(STR(?p),STR(pav:)))
	FILTER(!STRSTARTS(STR(?p),STR(prov:)))

	BIND(IRI(CONCAT(STR(?s),'_delta')) AS ?d)
}
LIMIT 2000000
;
ECHO $ROWCNT "\n";

ECHO "deletions ... ";
## -s p A B
## +s p A
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:deletion ?oou
		] ;
		rdf:subject ?s ;
		delta:patch-date ?dd ;
		prov:generatedAtTime ?now
}
USING <$u{ORIGG}>
USING <$u{PATCH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{PATCH}> {
	?s ?p ?oin
	}
	GRAPH <$u{ORIGG}> {
	?s ?p ?oou
	}
	FILTER NOT EXISTS {
		GRAPH <$u{PATCH}> {
		?s ?p ?oou
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != dct:modified)
	FILTER(!STRSTARTS(STR(?p),STR(pav:)))
	FILTER(!STRSTARTS(STR(?p),STR(prov:)))

	BIND(IRI(CONCAT(STR(?s),'_delta')) AS ?d)
}
LIMIT 2000000
;
ECHO $ROWCNT "\n";
 
ECHO "insertions ... ";
## -s p A B
## +s p A B C
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?d	a delta:Delta ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:insertion ?oin
		] ;
		rdf:subject ?s ;
		delta:patch-date ?dd ;
		prov:generatedAtTime ?now
}
USING <$u{ORIGG}>
USING <$u{PATCH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{PATCH}> {
	?s ?p ?oin
	}
	FILTER NOT EXISTS {
		GRAPH <$u{ORIGG}> {
		?s ?p ?oin
		}
	}
	FILTER(!STRSTARTS(STR(?p),STR(pav:)))
	FILTER(!STRSTARTS(STR(?p),STR(prov:)))

	BIND(IRI(CONCAT(STR(?s),'_delta')) AS ?d)
}
;
ECHO $ROWCNT "\n";

CHECKPOINT;
