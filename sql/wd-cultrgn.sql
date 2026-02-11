PREFIX dct: <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX pq: <http://www.wikidata.org/prop/qualifier/>
PREFIX psv: <http://www.wikidata.org/prop/statement/value/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX tempo: <http://purl.org/tempo/>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX pav: <http://purl.org/pav/>
PREFIX schema: <http://schema.org/>
PREFIX fibo-eip: <https://spec.edmcouncil.org/fibo/ontology/IND/EconomicIndicators/EconomicIndicatorPublishers/>

##SELECT ?item
CONSTRUCT {
	?item a ?rkind ;
		rdfs:label ?itemLabel ;
		wdt:P527 ?memb ;
		wdt:P856 ?Xweb ;
		wdt:P1448 ?name ;
		wdt:P1813 ?sname ;

		dct:modified ?accd ;
		pav:version ?vers ;
		dct:replacedBy ?rby ;
		dct:replaces ?rpl ;
}
WHERE {
	VALUES ?rkind {
	wd:Q3502482
	}
	?item wdt:P31 ?rkind ;
		schema:dateModified ?accd ;
		schema:version ?vers .

	SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,mul,de,fr,es,it". }

	OPTIONAL {
		?item wdt:P527 ?memb
	}
	OPTIONAL {
		?item wdt:P856 ?web
	}
	OPTIONAL {
		?item wdt:P1448 ?name
	}
	OPTIONAL {
		?item wdt:P1813 ?sname
	}
	OPTIONAL {
		?item wdt:P1366 ?rby
	}
	OPTIONAL {
		?item wdt:P1365 ?rpl
	}
	BIND(STRDT(STR(?web),xsd:anyURI) AS ?Xweb)
}
