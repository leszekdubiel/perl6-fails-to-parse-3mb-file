# perl6-fails-to-parse-3mb-file

Here are two files -- small and big one. 
And two programs -- perl5 and perl6. 
For small data both run okey. 
For big data perl6 fails. 

```
$ time cat data_tiny.txt | ./parse_by_perl5.pl | wc -l 
24

real	0m0,039s
user	0m0,032s
sys	0m0,012s



$ time cat data_tiny.txt | ./parse_by_perl6.p6 | wc -l; echo $?
167

real	0m0,305s
user	0m0,439s
sys	0m0,063s
0



$ time cat data_more.txt | ./parse_by_perl5.pl | wc -l 
50862

real	0m1,608s
user	0m1,599s
sys	0m0,016s


$ time cat data_more.txt | ./parse_by_perl6.p6 | wc -l 
moar: src/unix/core.c:539: uv__close: Assertion `fd > STDERR_FILENO' failed.
0

real	0m0,611s
user	0m0,676s
sys	0m0,039s

```
