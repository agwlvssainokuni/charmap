copyFromLocal ../エンコーディング変換比較.txt wincharset.tsv;

wincharset = LOAD 'wincharset.tsv' AS (
	wincode:chararray, unicode:chararray,
	cp932x1:chararray, cp932x2:chararray,
	win31jx1:chararray, win31jx2:chararray,
	comment:chararray
);

ucgroup = GROUP wincharset BY unicode;
ucgroup_cond = FOREACH ucgroup {

	wincode = wincharset.(wincode, comment);
	cp932 = wincharset.(wincode, cp932x1, cp932x2);
	cp932_fail = FILTER cp932 BY cp932x1 == 'false' OR cp932x2 == 'false';
	win31j = wincharset.(wincode, win31jx1, win31jx2);
	win31j_fail = FILTER win31j BY win31jx1 == 'false' OR win31jx2 == 'false';

	GENERATE
		group AS unicode,
		COUNT(wincharset) AS cnt,
		wincode,
		cp932_fail,
		win31j_fail;
};

cp932_ng = FILTER ucgroup_cond BY NOT IsEmpty(cp932_fail);
STORE cp932_ng INTO '0_cp932_ng';

win31j_ng = FILTER ucgroup_cond BY NOT IsEmpty(win31j_fail);
STORE win31j_ng INTO '1_win31j_ng';

copyToLocal 0_cp932_ng .;
copyToLocal 1_win31j_ng .;
rm wincharset.tsv;
rm 0_cp932_ng;
rm 1_win31j_ng;
