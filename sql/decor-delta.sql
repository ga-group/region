log_enable(3,1);

ECHO "decorating ... ";
SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>
WITH <$u{DIFFG}>
DELETE {
	?x delta:hunk ?y
}
INSERT {
	?x delta:subject-old ?old ;
		delta:subject-new ?new
}
WHERE {
	## looking for the illusive rdf:subject hunk
	?x delta:hunk ?y .
	?y
		delta:deletion ?old ;
		delta:insertion ?new ;
		rdf:predicate rdf:subject.
}
;
ECHO $ROWCNT;

SPARQL
PREFIX delta: <http://www.w3.org/2004/delta#>
WITH <$u{DIFFG}>
DELETE {
	?y ?p ?o
}
WHERE {
	## looking for the illusive rdf:subject hunk
	?y
		delta:deletion ?old ;
		delta:insertion ?new ;
		rdf:predicate rdf:subject ;
		?p ?o
}
;
ECHO " + " $ROWCNT "\n";
