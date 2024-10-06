# Description
This repository is for the presentation **'Erlang: Network Distributed Systems.'**

It demonstrates the evolution of factorial calculation, starting from single-threaded core calculation to calculation in a network-distributed cluster using pure Erlang.

Use the following tags to explore the corresponding algorithm:

1. **v0.0.1**: single-threaded
2. **v0.1.1**: all cores on a single machine
3. **v0.2.0**: all cores in a network-distributed cluster

# How to Run

1. Clone this repository:
```
git clone https://github.com/koctep/factorial
```
2. Checkout the chosen tag:
```
git checkout <tag>
```
3. Build the project:
```
make
```
4.  Run the tests:
```
make tests
```
5. Start the Erlang virtual machine:
```
make shell
```
6. Calculate the factorial:
```
factorial:calc(5).
```

7. Measure the execution time (in microseconds):
```
factorial:measure(5).
```

# Setup Network Cluster

Cluster hosts are defined in the configuration file `etc/factorial.config`.
