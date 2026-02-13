SET u{GRAPH} http://data.ga-group.nl/region.inv/;
SPARQL CREATE SILENT GRAPH <$u{GRAPH}>;
SPARQL CLEAR GRAPH <$u{GRAPH}>;
ECHO $ROWCNT"\n";
CHECKPOINT;

ECHO "determining validity within variant ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
INSERT {
	?y lcc-cr:isSubregionOf [
		a	lcc-cr:GeographicRegion ;
		tempo:validFrom ?from ;
		tempo:validTill ?till ;
		rdfs:label ?lbl ;
		pav:derivedFrom ?z
	]
}
USING <http://data.ga-group.nl/region/>
WHERE {
	?x a lcc-cr:GeographicRegion ;
		rgn:hasCurrentVariant ?z ;
		lcc-cr:hasSubregion+ ?y .
	FILTER NOT EXISTS {
	?y rgn:hasCurrentVariant ?some
	}

	OPTIONAL {
	?x tempo:validFrom ?from
	}
	OPTIONAL {
	?x tempo:validTill ?till
	}
	OPTIONAL {
	?z rdfs:label ?lbl
	}
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;

ECHO "condensing chains of validity ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
INSERT {
	?sub a rgn:keep ;
		tempo:validFrom ?from ;
		tempo:validTill ?till
}
WHERE {
	{
	SELECT ?x ?y MIN(?sub) AS ?sub
	WHERE {
		?x lcc-cr:isSubregionOf ?sub .
		?sub a lcc-cr:GeographicRegion ;
			pav:derivedFrom ?y .
		FILTER(ISBLANK(?sub))
	}
	GROUP BY ?x ?y
	}

	?x lcc-cr:isSubregionOf ?z .
	?z a lcc-cr:GeographicRegion ;
		pav:derivedFrom ?y .
	OPTIONAL {
	?z tempo:validFrom ?from
	}
	OPTIONAL {
	?z tempo:validTill ?till
	}
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;

ECHO "pruning ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
DELETE {
	?z ?p ?o .
	?x lcc-cr:isSubregionOf ?z .
}
WHERE {
	?x lcc-cr:isSubregionOf ?z .
	FILTER NOT EXISTS {
	?z a rgn:keep
	}
	?z ?p ?o .
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;

ECHO "condensing validity ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
DELETE {
	?x tempo:validFrom ?z ;
		tempo:validTill ?z .
}
WHERE {
	?x tempo:validFrom ?z ;
		tempo:validTill ?z .
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
