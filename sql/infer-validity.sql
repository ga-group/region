-- expects uGRAPH to be set
ECHO "complementing validity intervals ... ";
SPARQL
DEFINE sql:log-enable 3
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX rgn: <http://data.ga-group.nl/region/>

WITH <$u{GRAPH}>
INSERT {
	?x tempo:validTill ?from
}
WHERE {
	?x dct:isReplacedBy ?y .
	?y tempo:validFrom ?from .
	FILTER NOT EXISTS {
	?x tempo:validTill ?any
	}
}
;
ECHO $ROWCNT"\n";
CHECKPOINT;
