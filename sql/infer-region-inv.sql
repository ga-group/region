SET u{TGTGR} http://data.ga-group.nl/region.inv/;
SET u{SRCGR} http://data.ga-group.nl/region/;
SPARQL CREATE SILENT GRAPH <$u{TGTGR}>;
SPARQL CLEAR GRAPH <$u{TGTGR}>;
CHECKPOINT;

ECHO "determining validity within variant ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{TGTGR}>
INSERT {
	?y a lcc-cr:GeographicRegion ;
	lcc-cr:isSubregionOf [
		a	lcc-cr:GeographicRegion ;
		tempo:validFrom ?from ;
		tempo:validTill ?till ;
		pav:derivedFrom ?z ;
	]
}
USING <$u{SRCGR}>
WHERE {
	?x a lcc-cr:GeographicRegion ;
		rgn:hasCurrentVariant ?z ;
		lcc-cr:hasSubregion+ ?y .

	## just so we dont infer anything on concepts in region.ttl
	FILTER NOT EXISTS {
	?y rgn:hasCurrentVariant ?some
	}

	OPTIONAL {
	?x tempo:validFrom ?from
	}
	OPTIONAL {
	?x tempo:validTill ?till
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

WITH <$u{TGTGR}>
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

WITH <$u{TGTGR}>
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

WITH <$u{TGTGR}>
DELETE {
	?x
		tempo:validFrom ?z ;
		tempo:validTill ?z .
}
WHERE {
	?x
		tempo:validFrom ?z ;
		tempo:validTill ?z .
}
;
ECHO $ROWCNT"\n";

ECHO "adding beef ... ";
SPARQL
DEFINE sql:log-enable 3
DEFINE input:same-as "yes"
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{TGTGR}>
INSERT {
	?z
		rdfs:label ?lbl ;
		foaf:name ?nam ;
		lcc-cr:isClassifiedBy ?cls ;
		dct:source ?src ;
		skos:definition ?def
}
USING <$u{SRCGR}>
WHERE {
	?z a rgn:keep ;
		pav:derivedFrom ?x .

	OPTIONAL {
	?x rdfs:label ?lbl
	}
	OPTIONAL {
	?x dct:source ?src
	}
	OPTIONAL {
	?x foaf:name ?nam
	}
	OPTIONAL {
	?x skos:definition ?def
	}
	OPTIONAL {
	?x lcc-cr:isClassifiedBy ?cls
	}
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;

ECHO "cleaning up ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{TGTGR}>
DELETE {
	?x a rgn:keep 
}
WHERE {
	?x a rgn:keep
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
