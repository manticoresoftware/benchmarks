#!/usr/bin/php
<?php
if (!isset($argv[1]) or !file_exists($argv[1]) or !isset($argv[2]) or !file_exists($argv[2])) die("Usage: ".__FILE__." <path to file with query types> <path to file with top keywords>
Example of query types:
100x 1-100
100x 100-200
100x 1-100 1-100
100x 100-200 100-200
100x 500-600 500-600 -100-200 
100x \"100-200 100-200\" 

	100x means generate 100 of such queries, this is mandatory (at least 1x)
	100-200 means take a random keyword from the keywords file at position 100-200
	-100-200 means the same, but put \"-\" before the keyword
	\" means put a double quote

Example of keywords file:
decent 125910
keywords 125700
playing 125690
servers 125310
extra 124840
ipad 124680
particularly 124590
The counts are optional, it doesn't change anything

");

function replace($matches) {
	global $keywords;
	foreach ($matches as $match) {
		list($from, $to) = explode('-', $match);
		$candidates = array_slice($keywords, $from-1, ($to - $from));
		shuffle($candidates);
		$candidates = explode(' ', $candidates[0]);
		return $candidates[0];
	}
}

$query_types = file($argv[1], FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES);
$keywords = file($argv[2], FILE_IGNORE_NEW_LINES|FILE_SKIP_EMPTY_LINES);
foreach ($query_types as $query_type) {
	if (!preg_match('/^(\d+)x(.*)$/', $query_type, $match)) continue;
	for ($n=0;$n<$match[1];$n++) {
		echo trim(preg_replace_callback('/\d+-\d+/', 'replace', $match[2]))."\n";
	}
}
