DB.DBA.XML_SET_NS_DECL('sh', 'http://www.w3.org/ns/shacl#', 3);

SET BLOBS ON;

CREATE FUNCTION DB.DBA.CHECK_DT_INTV(in _from ANY, in _till ANY) RETURNS ANY
{
	DECLARE F ANY;
	DECLARE T ANY;
	FOR (DECLARE I INTEGER, I := 1; I < LENGTH(_from); I := I + 1) {
		F := AREF(_from, I);
		T := AREF(_till, I - 1);

		IF (F <= T) {
			RETURN F;
		}
	}
	RETURN NULL;
}

SPARQL
DEFINE output:format "NICE_TTL"
PREFIX tempo: <http://purl.org/tempo/>
PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX rgn: <http://data.ga-group.nl/region/>

CONSTRUCT {
rgn:cons.chronology.rpt
	a sh:ValidationReport ;
	sh:conforms false ;
	sh:result [
		a sh:ValidationResult ;
		sh:focusNode ?this ;
		sh:resultMessage "validity in focusNode shall be non-connected time intervals" ;
		sh:resultSeverity sh:Violation ;
		sh:sourceConstraintComponent sh:FirstLastBuggery ;
		sh:sourceShape rgn:cons.chronology ;
	] .
}
FROM <$u{GRAPH}>
WHERE {
	{
	SELECT ?this sql:VECTOR_AGG(?from) AS ?from
	FROM <$u{GRAPH}>
	WHERE {
		?this tempo:validFrom ?from
	} GROUP BY ?this ORDER BY ?this
	}
	{
	SELECT ?this sql:VECTOR_AGG(?till) AS ?till
	FROM <$u{GRAPH}>
	WHERE {
		?this tempo:validTill ?till
	} GROUP BY ?this ORDER BY ?this
	}
	BIND(sql:CHECK_DT_INTV(?from, ?till) AS ?value)
	FILTER(!bif:ISNULL(?value))
}
LIMIT 10000
;
