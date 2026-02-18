SET u{ACTUAL} http://data.ga-group.nl/region/;

ECHO "canonifying subregions ... ";
-- this unwraps regions that are defined in terms
-- of former regions (of the same variant)
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
DELETE {
	?x lcc-cr:hasSubregion ?y
}
INSERT {
	?x lcc-cr:hasSubregion ?z
}
WHERE {
	?x lcc-cr:hasSubregion+ ?y ;
		rgn:hasCurrentVariant ?v .
	?y lcc-cr:hasSubregion ?z ;
		rgn:hasCurrentVariant ?v .
	OPTIONAL {
	?z rgn:hasCurrentVariant ?zv
	}
	FILTER(!BOUND(?zv) || ?zv != ?v)
}
;
ECHO $ROWCNT"\n";
