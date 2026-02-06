changequote()changequote([,])
define([DUMP_PROCEDURE],[
	pushdef(NAME,$1)
	pushdef(SPARQL_QUERY,$2)
PROCEDURE NAME (IN out_file VARCHAR)
{
	DECLARE env, ses ANY;
	SET ISOLATION = 'uncommitted';

	env := vector (dict_new (16000), 0, '', '', '', 0, 0, 0, 0, 0);
	ses := string_output();
	file_delete(out_file, 1);
	FOR (SELECT * FROM (
SPARQL_QUERY
) AS sub OPTION (LOOP)) DO {
	http_ttl_triple(env, "s","p","o", ses);
	IF (LENGTH(ses) > 16277216) {
		string_to_file(out_file, ses, -1);
		ses := string_output();
	}
}
IF (LENGTH(ses)) {
	http(' .\n', ses);
	string_to_file(out_file, ses, -1);
}
}
	popdef(SPARQL_QUERY)
	popdef(NAME)
])
changequote()
