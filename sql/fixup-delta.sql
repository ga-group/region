log_enable(3,1);

ECHO "fixing ... ";
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:deletion ?del ;
		delta:insertion ?ins .
}
WHERE {
	?x a delta:Hunk ;
		delta:deletion ?del ;
		delta:insertion ?ins .
	FILTER(STR(?del) = STR(?ins) && LANG(?del) = LANG(?ins) && DATATYPE(?del) = DATATYPE(?ins))
}
;
ECHO $ROWCNT;

## if there was previously a similar hunk marked as error
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{STAGE}>
INSERT {
	?s ?p ?del
}
DELETE {
	?s ?p ?ins
}
USING <$u{DIFFG}>
USING <$u{GRAPH}>
WHERE {
	GRAPH <$u{DIFFG}> {
		[] rdf:subject ?s ;
			delta:hunk ?x .
		?x a delta:Hunk ;
			delta:deletion ?del ;
			delta:insertion ?ins ;
			rdf:predicate ?p .
	}
	GRAPH <$u{GRAPH}> {
		[] rdf:subject ?s ;
			delta:hunk ?y .
		?y a delta:Hunk , delta:Error ;
			delta:deletion ?del ;
			delta:insertion ?ins ;
			rdf:predicate ?p .
	}
}
;
ECHO " + "$ROWCNT"/";
## if there was previously a similar hunk marked as error
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{STAGE}>
DELETE {
	?s ?p ?ins
}
USING <$u{DIFFG}>
USING <$u{GRAPH}>
WHERE {
	GRAPH <$u{DIFFG}> {
		[] rdf:subject ?s ;
			delta:hunk ?x .
		?x a delta:Hunk ;
			delta:insertion ?ins ;
			rdf:predicate ?p .
	}
	GRAPH <$u{GRAPH}> {
		[] rdf:subject ?s ;
			delta:hunk ?y .
		?y a delta:Hunk , delta:Error ;
			delta:insertion ?ins ;
			rdf:predicate ?p .
	}
}
;
ECHO " + "$ROWCNT"/";
## now delete the hunk in the diff
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:deletion ?del ;
		delta:insertion ?ins .
}
USING <$u{DIFFG}>
USING <$u{GRAPH}>
WHERE {
	GRAPH <$u{DIFFG}> {
		?x a delta:Hunk ;
			delta:deletion ?del ;
			delta:insertion ?ins .
	}
	GRAPH <$u{GRAPH}> {
		[] a delta:Hunk , delta:Error ;
			delta:deletion ?del ;
			delta:insertion ?ins .
	}
}
;
ECHO " + "$ROWCNT"/";
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:insertion ?ins .
}
USING <$u{DIFFG}>
USING <$u{GRAPH}>
WHERE {
	GRAPH <$u{DIFFG}> {
		?x a delta:Hunk ;
			delta:insertion ?ins .
	}
	GRAPH <$u{GRAPH}> {
		[] a delta:Hunk , delta:Error ;
			delta:insertion ?ins .
	}
}
;
ECHO $ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x ?p ?o
}
WHERE {
	?x a delta:Hunk ;
		?p ?o .
	FILTER(NOT EXISTS{?x delta:deletion ?del})
	FILTER(NOT EXISTS{?x delta:insertion ?ins})
}
;
ECHO " + "$ROWCNT;

## should be penultimate as this clears out delta:hunk links
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x delta:hunk ?y
}
WHERE {
	?x delta:hunk ?y .
	FILTER(NOT EXISTS{?y a delta:Hunk})
}
;
ECHO " + "$ROWCNT;

## must be last as this clears out a whole Delta when there are no hunks
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>

WITH <$u{DIFFG}>
DELETE {
	?x ?p ?o
}
WHERE {
	?x a delta:Delta ;
		?p ?o
	FILTER(NOT EXISTS{?x delta:hunk ?y})
}
;
ECHO " + "$ROWCNT"\n";

CHECKPOINT;
