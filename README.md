[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

region -- ontology for geographic, geoeconomic, and geopolitical regions
========================================================================

region is a lightweight, standards‑aligned ontology to describe and
interlink regional groupings of places, economies, and polities --
spanning geographic regions (e.g., Melanesia), geoeconomic blocs
(e.g., EU Single Market, ASEAN), and geopolitical alliances
(e.g. NATO, PIF).  It provides stable identifiers, a small but
expressive core vocabulary, and interoperable mappings to ISO
standards and widely used knowledge graphs.

Designed for analysts, data engineers, and researchers who need clean,
canonical concepts for “regions” that are not countries but are also
not vague text labels.


Why?
----

The ontology became necessary mainly because of

- Ambiguity: “Europe”, “EU”, “EEA”, "Eurozone" are often conflated,
  yet they refer to different membership sets and legal scopes.
- Volatility: Alliances evolve, references might or might not --
  accessions, suspensions, observer statuses.
- Interoperability: Regions should connect seamlessly to countries
  (ISO‑3166), currencies (ISO‑4217), languages (ISO‑639), and other
  authoritative references.
- Reusability: A consistent model enables reuse across trade
  analytics, sanctions monitoring, supply‑chain risk, climate and
  fisheries governance, and policy research.


Where?
------

The [official github repository](https://github.com/ga-group/region/) contains the
published ontology.

For ease of access the latest versions of the taxonomy can be downloaded here:

- [region.ttl](region.ttl)

Alignments can be obtained here:

- [region-align.ttl](region-align.ttl)

An inverted view of associations:

- [region-inv.ttl](region-inv.ttl)
