#!/bin/bash
echo "TEST 1: Top 1000 frequent terms from HackerNews collection"
for engine in sphinx manticore; do
    echo "===================== Testing $engine ====================="
    time (for n in `head -1000 hn_top.txt|awk '{print $1}'`; do
        mysql -P9306 -hhn_$engine -e "select * from full where match('@(comment_text,story_text,comment_author,story_author) $n') limit 10 option max_matches=1000" > /dev/null
    done)
done

echo "TEST 2: Top 1000 frequent terms from HackerNews colleciton by groups (top 1-50, top 50-100 etc.)"
for type in 1-50 50-100 100-150 150-200 200-250 250-300 300-350 350-400 400-450 450-500 500-550 550-600 600-650 650-700 700-750 750-800 800-850 850-900 900-950 950-1000; do echo "200x $type" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}_${type}; done; done;

echo "TEST 3: Top 1000 frequent terms from HackerNews colleciton by groups + 1 term from group 1-100"
for type in 1-50 50-100 100-150 150-200 200-250 250-300 300-350 350-400 400-450 450-500 500-550 550-600 600-650 650-700 700-750 750-800 800-850 850-900 900-950 950-1000; do echo "200x 1-100 $type" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}_${type}; done; done;

echo "TEST 4: - Top 1000 frequent terms from HackerNews colleciton by groups + 1 term from group 1-100, both terms enclosed in quotes to make a phrase" 
for type in 1-50 50-100 100-150 150-200 200-250 250-300 300-350 350-400 400-450 450-500 500-550 550-600 600-650 650-700 700-750 750-800 800-850 850-900 900-950 950-1000; do echo "500x \"1-100 $type\"" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}_${type}; done; done;

echo "TEST 5: - 2 terms each from group 600-750 under different concurrencies"
echo "10000x 600-750 600-750" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do for conc in 1 3 5 8 10 12 14; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=$conc --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}_${conc}; done; done;

echo "TEST 6: - 3 terms from groups 100-200 400-500 800-900"
echo "1000x 100-200 300-400 500-600 800-900" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}; done;

echo "TEST 7: - 4 terms from groups 100-200 300-400 500-600 800-900"
echo "1000x 100-200 300-400 500-600 800-900" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}; done;

echo "TEST 8: - 5 terms from groups 100-200 300-400 500-600 800-900 900-1000"
echo "1000x 100-200 300-400 500-600 800-900" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}; done;

echo "TEST 9: - 3 AND terms from groups 300-600 and 1 NOT from 300-400"
echo "1000x 300-600 300-600 300-600 -300-400" > queries_test.txt; php generate_queries.php queries_test.txt hn_top.txt|sort -R|uniq > q.txt; for engine in sphinx manticore; do php test.php --plugin=plain.php -b=100 --data=q.txt -c=1 --host=hn_$engine --port=9306 --index=full --csv --tag=${engine}; done;

