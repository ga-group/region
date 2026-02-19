changequote()changequote([,])
DB.DBA.XML_SET_NS_DECL('rdfs', 'http://www.w3.org/2000/01/rdf-schema#', 3);
DB.DBA.XML_SET_NS_DECL('tempo', 'http://purl.org/tempo/', 3);
DB.DBA.XML_SET_NS_DECL('lcc-3166-1-adj', 'https://www.omg.org/spec/LCC/Countries/ISO3166-1-CountryCodes-Adjunct/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-3166-3-adj', 'https://www.omg.org/spec/LCC/Countries/ISO3166-3-FormerCountries-Adjunct/', 1);
DB.DBA.XML_SET_NS_DECL('lcc-m49', 'https://www.omg.org/spec/LCC/Countries/UN-M49-RegionCodes/', 3);
DB.DBA.XML_SET_NS_DECL('lcc-cr', 'https://www.omg.org/spec/LCC/Countries/CountryRepresentation/', 3);
DB.DBA.XML_SET_NS_DECL('dct', 'http://purl.org/dc/terms/', 3);
DB.DBA.XML_SET_NS_DECL('gr', 'http://purl.org/goodrelations/v1#', 3);
DB.DBA.XML_SET_NS_DECL('gas', 'http://schema.ga-group.nl/symbology#', 3);
DB.DBA.XML_SET_NS_DECL('mic', 'http://fadyart.com/markets#', 3);
DB.DBA.XML_SET_NS_DECL('time', 'http://www.w3.org/2006/time#', 3);
DB.DBA.XML_SET_NS_DECL('dbo', 'http://dbpedia.org/ontology/', 3);
DB.DBA.XML_SET_NS_DECL('dbr', 'http://dbpedia.org/resource/', 1);
DB.DBA.XML_SET_NS_DECL('wd', 'http://www.wikidata.org/entity/', 3);
DB.DBA.XML_SET_NS_DECL('stw', 'http://zbw.eu/stw/descriptor/', 3);
DB.DBA.XML_SET_NS_DECL('skos', 'http://www.w3.org/2004/02/skos/core#', 3);
DB.DBA.XML_SET_NS_DECL('bps', 'http://bsym.bloomberg.com/pricing_source/', 3);
DB.DBA.XML_SET_NS_DECL('intr', 'http://ga.local/intr#', 3);
DB.DBA.XML_SET_NS_DECL('ccy', 'http://ga.local/ccy#', 3);
DB.DBA.XML_SET_NS_DECL('cfi', 'http://schema.ga-group.nl/meta/classification/CFI/', 3);
DB.DBA.XML_SET_NS_DECL('cic', 'http://schema.ga-group.nl/meta/classification/CIC/', 3);
DB.DBA.XML_SET_NS_DECL('ccat', 'http://data.ga-group.nl/comcat/', 3);
DB.DBA.XML_SET_NS_DECL('rgn', 'http://data.ga-group.nl/region/', 3);
DB.DBA.XML_SET_NS_DECL('delta', 'http://www.w3.org/2004/delta#', 3);

include(/home/freundt/author/region/sql/dump-generic.sql)
CREATE DUMP_PROCEDURE(dump_rgn_dlt,
SPARQL
DEFINE input:storage ""
PREFIX lcc-cr: <https://www.omg.org/spec/LCC/Countries/CountryRepresentation/>
PREFIX delta: <http://www.w3.org/2004/delta#>
SELECT ?s ?p ?o
FROM <http://data.ga-group.nl/region.delta/>
WHERE {
	?s ?p ?o .
}
);

dump_rgn_dlt('/var/scratch/lakshmi/freundt/region-delta.ttl');
CHECKPOINT;
