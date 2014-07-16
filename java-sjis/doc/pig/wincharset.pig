copyFromLocal ../エンコーディング変換比較.txt wincharset.tsv;

wincharset = LOAD 'wincharset.tsv' AS (
	wincode:chararray, unicode:chararray,
	ms932x1:chararray, ms932x2:chararray,
	cp943x1:chararray, cp943x2:chararray,
	win31jx1:chararray, win31jx2:chararray,
	comment:chararray
);

ucgroup = GROUP wincharset BY unicode;
ucgroup_cond = FOREACH ucgroup {

	wincode = wincharset.(wincode, comment);
	ms932 = wincharset.(wincode, ms932x1, ms932x2);
	ms932_fail = FILTER ms932 BY ms932x1 == 'false' OR ms932x2 == 'false';
	cp943 = wincharset.(wincode, cp943x1, cp943x2);
	cp943_fail = FILTER cp943 BY cp943x1 == 'false' OR cp943x2 == 'false';
	win31j = wincharset.(wincode, win31jx1, win31jx2);
	win31j_fail = FILTER win31j BY win31jx1 == 'false' OR win31jx2 == 'false';

	GENERATE
		group AS unicode,
		COUNT(wincharset) AS cnt,
		wincode,
		ms932_fail,
		cp943_fail,
		win31j_fail;
};

ms932_ng = FILTER ucgroup_cond BY NOT IsEmpty(ms932_fail);
STORE ms932_ng INTO '0_ms932_ng';

cp943_ng = FILTER ucgroup_cond BY NOT IsEmpty(cp943_fail);
STORE cp943_ng INTO '1_cp943_ng';

win31j_ng = FILTER ucgroup_cond BY NOT IsEmpty(win31j_fail);
STORE win31j_ng INTO '2_win31j_ng';

copyToLocal 0_ms932_ng .;
copyToLocal 1_cp943_ng .;
copyToLocal 2_win31j_ng .;
rm wincharset.tsv;
rm 0_ms932_ng;
rm 1_cp943_ng;
rm 2_win31j_ng;
