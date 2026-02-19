-- this guy will take region.inv graph and generate a region.inv.inv graph
-- that should resemble the original region graph
SET u{TGTGR} http://data.ga-group.nl/region.inv.inv/;
SET u{SRCGR} http://data.ga-group.nl/region.inv/;

SET IGNORE_PARAMS ON;

SPARQL CREATE SILENT GRAPH <$u{TGTGR}>;
SPARQL CLEAR GRAPH <$u{TGTGR}>;
CHECKPOINT;

ECHO "determining and enumerating individuals ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{TGTGR}>
INSERT {
	?_id a lcc-cr:GeographicRegion ;
		a owl:NamedIndividual ;
		foaf:name ?nam ;
		rdfs:isDefinedBy rgn: ;
		lcc-cr:hasSubregion ?x ;
		lcc-cr:isSubregionOf rgn:r01KH8R0PYDTV2B66AGWN37WS55 ;
		rdfs:label ?lbl ;
		lcc-cr:isClassifiedBy ?cls ;
		skos:definition ?def ;
		tempo:validFrom ?from
}
USING <$u{SRCGR}>
WHERE {
	?x a lcc-cr:GeographicRegion ;
		lcc-cr:isSubregionOf ?y .
	?y a lcc-cr:GeographicRegion ;
		pav:derivedFrom ?id ;
		rdfs:label ?lbl .
	OPTIONAL {
	?y tempo:validFrom ?from
	}
	OPTIONAL {
	?y tempo:validTill ?till
	}
	OPTIONAL {
	?y skos:definition ?def
	}
	OPTIONAL {
	?y foaf:name ?nam
	}
	OPTIONAL {
	?y lcc-cr:isClassifiedBy ?cls
	}

	BIND(IRI(CONCAT(STR(?id),'_',STR(?from))) AS ?_id)
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
