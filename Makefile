SHELL := /bin/zsh

include .make.env

all: .imported.wd-bloc
check: check.region

TODAY := $(shell dateconv today)
NOW := $(shell dateconv now)


check.region: ADDITIONAL = 

check.%: %.ttl shacl/%.shacl.ttl
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/region/" rgn $< $(ADDITIONAL)
	$(stardog) icv report --output-format PRETTY_TURTLE -g "http://data.ga-group.nl/region/" -r -l -1 rgn shacl/$*.shacl.ttl \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

check.%: %.ttl shacl/%.shacl.sql
	$(RM) tmp/shacl-*.qry
	mawk 'BEGIN{f=0}/\f/{f++;next}{print>"tmp/shacl-"f".qry"}' $(filter %.sql, $^)
	truncate -s 0 /tmp/$@.ttl
	$(stardog) data add --remove-all -g "http://data.ga-group.nl/region/" rgn $< $(ADDITIONAL)
	for i in tmp/shacl-*.qry; do \
		$(stardog) query execute --format PRETTY_TURTLE -g "http://data.ga-group.nl/region/" -r -l -1 rgn $${i}; \
	done \
        >> /tmp/$@.ttl || true
	$(MAKE) $*.rpt

%.rpt: /tmp/check.%.ttl
	$(sparql) --results text --data $< --query sql/valrpt.sql

.imported.%:: %.ttl.repl sql/repl-%.sql
	rapper -c -i turtle $<
	$(csvsql) < sql/repl-$*.sql \
	&& touch $@ && $(RM) -- $<

.imported.%:: %.ttl sql/load-%.sql
	rapper -c -i turtle $<
	$(csvsql) < sql/load-$*.sql \
	&& touch $@

.imported.%:: sql/load-%.sql
	$(csvsql) < $< \
	&& touch $@

/var/scratch/lakshmi/freundt/%.ttl: sql/dump-%.sql .imported.%
	m4 $< | $(csvsql)

export.%: /var/scratch/lakshmi/freundt/%.ttl
	-mawk '(x+=$$0=="")<=3&&($$0==""||(x=0)||1)' $*.ttl > $@
	sed 's/rdf:type/a/' $< \
	| ttl2ttl --sortable --expand-generic \
	| tr 'a' '\a' \
	| sort -u \
	| tr '\a' 'a' \
	| ttl2ttl -BQU \
	| sed '/^@/d;s@rdf:predicate\ta@rdf:predicate\trdf:type@' \
	>> $@
	mv $@ $*.ttl
	touch .imported.$*

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

wd-bloc.daily: tmp/wd-bloc.out tmp/wd-geogrp.out
	cat $^ >> wd-bloc.ttl.repl
	ttl-pav $^ >> wd-bloc.ttl.repl


setup-stardog:
	$(stardog)-admin db create -o reasoning.sameas=OFF -n rgn

unsetup-stardog:
	$(stardog)-admin db drop rgn
