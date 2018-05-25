# SyntacticalAnalyzer
Finite Automata Syntactical Analyzer: BISON

## Pre-requisites

You should have flex and bison installed.

Finite Automatas have to had the following format:
```
	% Autómata Finito
	Alfabeto { símbolo , símbolo , ... }
	Estados { num }
	Transiciones { (num , símbolo ; num), ... }
	Inicial { num }
	Finales { num, ... }
```

## Functioning

Compile the program:
```
./make
```

Test it with files:
```
./a.out < example.txt
```

## Authors

* **Oscar Alber Cañamero** - [oscaralca](https://github.com/oscaralca)
* **Cristòfol Daudén Esmel** - [toful](https://github.com/toful)
