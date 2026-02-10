changequote()changequote([,])
DB.DBA.XML_SET_NS_DECL('rdfs', 'http://www.w3.org/2000/01/rdf-schema#', 3);
DB.DBA.XML_SET_NS_DECL('tempo', 'http://purl.org/tempo/', 3);
DB.DBA.XML_SET_NS_DECL('lcc-3166-1-adj', 'https://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes-Adjunct/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-3166-2-adj', 'https://www.omg.org/spec/LCC/Countries/ISO3166-2-SubdivisionCodes-Adjunct/', 3);
DB.DBA.XML_SET_NS_DECL('lcc-m49', 'https://www.omg.org/spec/LCC/Countries/UN-M49-RegionCodes/', 3);
DB.DBA.XML_SET_NS_DECL('lcc-cr', 'https://www.omg.org/spec/LCC/Countries/CountryRepresentation/', 3);
DB.DBA.XML_SET_NS_DECL('dct', 'http://purl.org/dc/terms/', 3);
DB.DBA.XML_SET_NS_DECL('gr', 'http://purl.org/goodrelations/v1#', 3);
DB.DBA.XML_SET_NS_DECL('time', 'http://www.w3.org/2006/time#', 3);
DB.DBA.XML_SET_NS_DECL('dbr', 'http://dbpedia.org/resource/', 3);
DB.DBA.XML_SET_NS_DECL('skos', 'http://www.w3.org/2004/02/skos/core#', 3);
DB.DBA.XML_SET_NS_DECL('skos-xl', 'http://www.w3.org/2008/05/skos-xl#', 3);
DB.DBA.XML_SET_NS_DECL('ao', 'http://purl.org/ontology/ao/core#', 3);
DB.DBA.XML_SET_NS_DECL('dbo', 'https://dbpedia.org/ontology/', 3);
DB.DBA.XML_SET_NS_DECL('wd', 'http://www.wikidata.org/entity/', 3);
DB.DBA.XML_SET_NS_DECL('wdt', 'http://www.wikidata.org/prop/direct/', 3);
DB.DBA.XML_SET_NS_DECL('wikibase', 'http://wikiba.se/ontology#', 3);
DB.DBA.XML_SET_NS_DECL('pav', 'http://purl.org/pav/', 3);
DB.DBA.XML_SET_NS_DECL('org', 'http://www.w3.org/ns/org#', 3);
DB.DBA.XML_SET_NS_DECL('prov', 'http://www.w3.org/ns/prov#', 3);
DB.DBA.XML_SET_NS_DECL('euvoc', 'http://publications.europa.eu/ontology/euvoc#', 1);
DB.DBA.XML_SET_NS_DECL('eurovoc-schema', 'http://eurovoc.europa.eu/schema#', 1);
DB.DBA.XML_SET_NS_DECL('country', 'http://publications.europa.eu/resource/authority/country/', 1);
DB.DBA.XML_SET_NS_DECL('lemon', 'http://lemon-model.net/lemon#', 3);
DB.DBA.XML_SET_NS_DECL('lexvo', 'http://lexvo.org/ontology#', 1);
DB.DBA.XML_SET_NS_DECL('rgn', 'http://ga.local/rgn#', 1);
DB.DBA.XML_SET_NS_DECL('sov', 'http://ga.local/sov#', 1);

include(/home/freundt/author/region/sql/dump-generic.sql)
CREATE DUMP_PROCEDURE(dump_country,
SPARQL
DEFINE input:storage ""
PREFIX delta: <http://www.w3.org/2004/delta#>
SELECT ?s ?p ?o
FROM <http://publications.europa.eu/resource/authority/countries/>
WHERE {
	?s ?p ?o .
}
);

dump_country('/var/scratch/lakshmi/freundt/countries.ttl');
CHECKPOINT;
