log_enable(3,1);

ECHO "unifying ... 0";

-- unify by mark and sweep
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?x delta:hunk [
		a delta:keep ;
		a delta:Hunk ;
		rdf:predicate ?w
	] .
}
WHERE {
	?x rdf:subject ?s ;
		delta:hunk [
			rdf:predicate ?w
		] .
}
GROUP BY ?D ?s ?w
;
ECHO " + "$ROWCNT;
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
INSERT {
	?y ?q ?v
}
WHERE {
	?x rdf:subject ?s ;
		delta:hunk ?y .
	?y a delta:keep ;
		rdf:predicate ?w .

	[] rdf:subject ?s ;
		delta:hunk [
			rdf:predicate ?w ;
			?q ?v
		] .
}
;
ECHO " + "$ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:hunk ?y .
	?y ?p ?o .
}
WHERE {
	?x delta:hunk ?y .
	?y ?p ?o
	FILTER(ISBLANK(?y))
	FILTER NOT EXISTS {
	?y a delta:keep
	}
}
-- LIMIT 4000000
;
ECHO " - "$ROWCNT;
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x a delta:keep
}
WHERE {
	?x a delta:keep
}
-- LIMIT 4000000
;
ECHO " - "$ROWCNT"\n";

CHECKPOINT;
