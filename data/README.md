Benchmark for imbalanced dataset
================================

A benchmark can be found at [http://www.cs.gsu.edu/~zding/research/benchmark-data.php](http://www.cs.gsu.edu/~zding/research/benchmark-data.php)

There is some code available in order to fetch and convert the data.

Three different format will be available:

* libsvm,
* matlab,
* numpy.

In order to proceed, fetch the data by moving to the directory `src/fetch_data` and executing `./script_fetch_data`.
Then, go to `src/data_conversion` and execute the command `ipython conversion.py`