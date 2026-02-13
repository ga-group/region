SPARQL
DEFINE sql:log-enable 3
PREFIX rgn: <http://data.ga-group.nl/region/>
WITH <http://data.ga-group.nl/region/>
INSERT {
	?Xx ?p ?Xo ;
		pav:derivedFrom ?z
}
WHERE {
	## navigate through ?y variants
	?x rgn:cosumSummand ?y .
	?y dct:replaces* ?z .

	## only massage stuff that containes the cosummand
	FILTER(STRSTARTS(STR(?z),STR(?y)))
	BIND(IRI(REPLACE(STR(?z),STR(?y),STR(?x))) AS ?Xx)

	?z ?p ?o .
	FILTER NOT EXISTS {
	?Xx ?p ?some
	}
	FILTER(?p != lcc-cr:hasSubregion)
	BIND(IF(STRSTARTS(STR(?o),STR(?y)),IRI(REPLACE(STR(?o),STR(?y),STR(?x))),?o) AS ?Xo)
}
;
ECHO $ROWCNT"\n";

-- and reconstruct the sum
SPARQL
DEFINE sql:log-enable 3
PREFIX rgn: <http://data.ga-group.nl/region/>
WITH <http://data.ga-group.nl/region/>
INSERT {
	?Xx lcc-cr:hasSubregion ?z , ?rgn
}
WHERE {
	## navigate through ?y variants
	?x rgn:cosumSummand ?y .
	?y dct:replaces* ?z .

	## only massage stuff that containes the cosummand
	FILTER(STRSTARTS(STR(?z),STR(?y)))
	BIND(IRI(REPLACE(STR(?z),STR(?y),STR(?x))) AS ?Xx)

	FILTER NOT EXISTS {
	?Xx lcc-cr:hasSubregion ?some
	}
	?x lcc-cr:hasSubregion ?rgn .
	FILTER(?rgn != ?y)
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
