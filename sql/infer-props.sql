ECHO "+ " $u{PREDx} " <-> " $u{PREDy} " ";
SPARQL
DEFINE sql:log-enable 3
WITH <$u{GRAPH}>
INSERT {
	?x $u{PREDy} ?y
}
WHERE {
	?y $u{PREDx} ?x
	FILTER NOT EXISTS {
	?x $u{PREDy} ?y
	}
}
;
ECHO $ROWCNT " ";

SPARQL
DEFINE sql:log-enable 3
WITH <$u{GRAPH}>
INSERT {
	?x $u{PREDx} ?y
}
WHERE {
	?y $u{PREDy} ?x
	FILTER NOT EXISTS {
	?x $u{PREDx} ?y
	}
}
;
ECHO $ROWCNT "\n";
