PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX : <http://ga.local/stk#>

CONSTRUCT {
	?fn ?p ?sch .
	?fn ?q ?v
}
WHERE {
	VALUES (?sev ?p ?q) {
	(sh:Violation sh:violated-shape sh:violated-value)
	(sh:Warning sh:warned-shape sh:warned-value)
	(sh:Info sh:infoed-shape sh:infoed-value)
	}
	?x a sh:ValidationResult ;
		sh:resultSeverity ?sev ;
		sh:focusNode ?fn ;
		sh:sourceShape ?sh .
	OPTIONAL {
	?x sh:value ?v
	}
	OPTIONAL {
		?x sh:sourceConstraintComponent ?sc
	}
	BIND(IF(!BOUND(?sc), ?sh, IRI(CONCAT(STR(?sh),'+',STRAFTER(STR(?sc),"#")))) AS ?sch)
}
