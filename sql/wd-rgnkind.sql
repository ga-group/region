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

SELECT ?item ?itemLabel
WHERE {
	?item wdt:P31 wd:Q137022846 .
	SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,mul,de,fr,es,it". }
}
