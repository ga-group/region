log_enable(3,1);

SPARQL CREATE SILENT GRAPH <$u{DIFFG}-tmp>;
SPARQL CLEAR GRAPH <$u{DIFFG}-tmp>;

ECHO "changes ... ";
## -s p A B
## +s p A C
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}-tmp>
INSERT {
	?d	a delta:Delta ;
		delta:not-yet-applied true ;
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
USING <$u{STAGE}>
USING <$u{GRAPH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{STAGE}> {
	?s ?p ?oin ;
		pav:sourceLastAccessedOn ?dd
	}
	GRAPH <$u{GRAPH}> {
	?s ?p ?oou
	}
	FILTER(?oin != ?oou)
	FILTER NOT EXISTS {
		GRAPH <$u{STAGE}> {
		?s ?p ?oou
		}
	}
	FILTER NOT EXISTS {
		GRAPH <$u{GRAPH}> {
		?s ?p ?oin
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != dct:modified)
	FILTER(!STRSTARTS(STR(?p),STR(pav:)))
	FILTER(!STRSTARTS(STR(?p),STR(prov:)))

	BIND(IRI(CONCAT(STR(?s),'_',STR(xsd:date(?dd)))) AS ?d)
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

WITH <$u{DIFFG}-tmp>
INSERT {
       ?d	a delta:Delta ;
		delta:not-yet-applied true ;
		delta:hunk [
			a delta:Hunk ;
			rdf:predicate ?p ;
			delta:deletion ?oou
		] ;
		rdf:subject ?s ;
		delta:patch-date ?dd ;
		prov:generatedAtTime ?now
}
USING <$u{STAGE}>
USING <$u{GRAPH}>
WHERE {
	BIND(NOW() AS ?now)

	GRAPH <$u{STAGE}> {
	?s ?p ?oin ;
		pav:sourceLastAccessedOn ?dd
	}
	GRAPH <$u{GRAPH}> {
	?s ?p ?oou
	}
	FILTER NOT EXISTS {
		GRAPH <$u{STAGE}> {
		?s ?p ?oou
		}
	}
	FILTER(?p != rdf:type)
	FILTER(?p != dct:modified)
	FILTER(!STRSTARTS(STR(?p),STR(pav:)))
	FILTER(!STRSTARTS(STR(?p),STR(prov:)))

	BIND(IRI(CONCAT(STR(?s),'_',STR(xsd:date(?dd)))) AS ?d)
}
LIMIT 200000
;
ECHO $ROWCNT "\n";
 
ECHO "insertions ... 0\n";

CHECKPOINT;
