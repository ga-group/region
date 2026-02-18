-- expects uGRAPH to be set
ECHO "identifying chains of variants ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
DELETE {
	?x rgn:hasCurrentVariant ?w
}
INSERT {
	?x rgn:hasCurrentVariant ?zzz
}
WHERE {
	?x a lcc-cr:GeographicRegion ;
		dct:isReplacedBy* ?z .
	FILTER NOT EXISTS {
	?z dct:isReplacedBy ?some
	}
	OPTIONAL {
	?zz owl:sameAs ?z
	}
	BIND(COALESCE(?zz,?z) AS ?zzz)

	FILTER NOT EXISTS {
	?x rgn:hasCurrentVariant ?zzz
	}

	OPTIONAL {
	?x rgn:hasCurrentVariant ?w
	}
}
;
ECHO $ROWCNT"\n";

ECHO "aliasing latest variant ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
DELETE {
	?z owl:sameAs ?x
}
INSERT {
	?z owl:sameAs ?y
}
WHERE {
	?z owl:sameAs ?x .
	?x rgn:hasCurrentVariant ?z .
	?x dct:isReplacedBy ?y .
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
