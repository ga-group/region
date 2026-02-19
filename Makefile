SHELL := /bin/zsh

include .make.env

all: .imported.wd-bloc .imported.wd-region .imported.wd-milcoal .imported.region .imported.region-align .imported.ISO3166-3-FormerCountries .imported.ISO3166-3-FormerCountries-Adjunct
check: check.region

TODAY := $(shell dateconv today)
NOW := $(shell dateconv now)

.inferred.region-inv: .imported.region
.inferred.region-inv2: .inferred.region-inv
.inferred.region-delta: .imported.region


stardogd.region: ADDITIONAL = 


%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql

.imported.%:: %.ttl.repl sql/repl-%.sql
	$(ttlck) $<
	$(csvsql) < sql/repl-$*.sql \
	&& touch $@ && $(RM) -- $<

.imported.%:: %.ttl sql/load-%.sql
	rapper -c -i turtle $<
	$(csvsql) < sql/load-$*.sql \
	&& touch $@

.imported.%:: sql/load-%.sql
	$(csvsql) < $< \
	&& touch $@

.inferred.%:: sql/infer-%.sql
	$(csvsql) < $< \
	&& touch $@

/var/scratch/lakshmi/freundt/%.ttl: sql/dump-%.sql .imported.%
	m4 $< | $(csvsql)

/var/scratch/lakshmi/freundt/%.ttl: sql/dump-%.sql .inferred.%
	m4 $< | $(csvsql)

export.%: /var/scratch/lakshmi/freundt/%.ttl
	-mawk 'END{if (x<3){exit 1}}(x+=$$0=="")<=3&&($$0==""||(x=0)||1)' $*.ttl > $@ \
	|| { grep -F @prefix $<; echo; echo; echo; } > $@
	sed 's/rdf:type/a/' $< \
	| ttl2ttl --sortable --expand-generic \
	| tr 'a' '\a' \
	| sort -u \
	| tr '\a' 'a' \
	| ttl2ttl -BQU \
	| sed '/^@/d;s@rdf:predicate\ta@rdf:predicate\trdf:type@' \
	>> $@
	mv $@ $*.ttl
	touch .*.$*

.PRECIOUS: .stardogd.%
.stardogd.%: %.ttl
	$(MAKE) $(ADDITIONAL)
	$(stardog) data add --server-side --remove-all -g http://data.ga-group.nl/$*/ eco $< $(ADDITIONAL) \
	&& touch $@

.check.dog.%: shacl/%.shacl.ttl .stardogd.%
	$(stardog) icv report --output-format PRETTY_TURTLE -g http://data.ga-group.nl/$*/ -l -1 eco $< $(ADDISHACL) \
	> $@.t && mv $@.t $@

.check.sql.%: shacl/%.shacl.sql .imported.%
	m4 shacl/$*.shacl.sql \
	| $(ttlsql) -u GRAPH="http://data.ga-group.nl/$*/" \
	> $@.t && mv $@.t $@

check.%: .check.dog.% .check.sql.%
	cat $^ > .$@.ttl
	$(sparql) --results text --data .$@.ttl --query sql/valrpt.sql

%.anno: /tmp/check.%.ttl
	mawk '!(/sh:violated-/||/sh:warned-/||/sh:infoed-/)||/\.$$/&&$$0="."' $*.ttl \
	> $@
	$(sparql) --data $< --query sql/rptanno.sql \
	>> $@ && mv $@ $*.ttl

tmp/%.out:: sql/%.sql
	$(csvsql) < $< \
        | unqpc --only-printable \
	$(if $(V),| tee $@.t,> $@.t) \
	&& mv $@.t $@

tmp/%.out:: tmp/%.sql
	$(csvsql) < $< \
        | unqpc --only-printable \
	| tee $@.t && mv $@.t $@

WDQS := https://query.wikidata.org/sparql
tmp/wd-%.out:: sql/wd-%.sql /data/data-source/stamp/today
	curl 'https://query.wikidata.org/sparql' -H 'Accept: text/turtle,text/tab-separated-values' --data-urlencode "query@$<" \
	$(if $(V),| tee $@.t,> $@.t) \
	&& mv $@.t $@

tmp/wd-%.out:: tmp/wd-%.sql /data/data-source/stamp/today
	curl 'https://query.wikidata.org/sparql' -H 'Accept: text/turtle,text/tab-separated-values' --data-urlencode "query@$<" \
	| tee $@.t && mv $@.t $@

wd-bloc.daily: tmp/wd-bloc.out tmp/wd-geogrp.out
	cat $^ >> wd-bloc.ttl.repl
	ttl-pav $^ >> wd-bloc.ttl.repl

wd-region.daily: tmp/wd-region.out tmp/wd-cultrgn.out tmp/wd-histrgn.out tmp/wd-macrorgn.out tmp/wd-transconti.out
	cat $^ >> wd-region.ttl.repl
	ttl-pav $^ >> wd-region.ttl.repl

wd-milcoal.daily: tmp/wd-milcoal.out tmp/wd-milcoal2.out
	cat $^ >> wd-milcoal.ttl.repl
	ttl-pav $^ >> wd-milcoal.ttl.repl

setup-stardog:
	$(stardog)-admin db create -o reasoning.sameas=OFF -n rgn

unsetup-stardog:
	$(stardog)-admin db drop rgn
