# Data Query Workflows

## Introduction

This Raku (Perl 6) package has grammar and action classes for the parsing and interpretation of natural language
commands that specify data queries in the style of Standard Query Language (SQL) or
[RStudio](https://rstudio.com)'s library [`tidyverse`](https://tidyverse.tidyverse.org).

The interpreters (actions) have as targets different programming languages (and packages in them).
The currently implemented language-and-package targets are:
Julia::DataFrames, Mathematica, Python::pandas, R::base, R::tidyverse, Raku::Reshapers.

There are also interpreters to natural languages: Bulgarian, Korean, Russian, Spanish.

------

## Installation

From GitHub:

```
zef install https://github.com/antononcube/Raku-DSL-English-DataQueryWorkflows.git
```

------

## Examples

Here is example code:

```perl6
use DSL::English::DataQueryWorkflows;

say ToDataQueryWorkflowCode('select mass & height', 'R-tidyverse');
```
```
# dplyr::select(mass, height)
```

Here is a longer data wrangling command:

```perl6
my $command = 'use starwars;
select mass & height;
mutate bmi = `mass/height^2`;
arrange by the variable bmi descending';
```
```
# use starwars;
# select mass & height;
# mutate bmi = `mass/height^2`;
# arrange by the variable bmi descending
```
Here we translate that command into executable code for Julia, Mathematica, Python, R, and Raku:

```perl6
{say $_.key,  ":\n", $_.value, "\n"} for <Julia Mathematica Python R R::tidyverse Raku>.map({ $_ => ToDataQueryWorkflowCode($command, $_ ) });
```
```
# Julia:
# obj = starwars
# obj = obj[ : , [:mass, :height]]
# obj = transform( obj, mass/height^2 => :bmi )
# obj = sort( obj, [:bmi], rev=true )
# 
# Mathematica:
# obj = starwars
# obj = Map[ KeyTake[ #, {"mass", "height"} ]&, obj]
# obj = Map[ Join[ #, <|"bmi" -> mass/height^2|> ]&, obj]
# obj = ReverseSortBy[ obj, {#["bmi"]}& ]
# 
# Python:
# obj = starwars.copy()
# obj = obj[["mass", "height"]]
# obj = obj.assign( bmi = mass/height^2 )
# obj = obj.sort_values( ["bmi"], ascending = False )
# 
# R:
# obj <- starwars ;
# obj <- obj[, c("mass", "height")] ;
# {obj[["bmi"]] <- mass/height^2} ;
# obj <- obj[ rev(order(obj[ ,c("bmi")])), ]
# 
# R::tidyverse:
# starwars %>%
# dplyr::select(mass, height) %>%
# dplyr::mutate(bmi = mass/height^2) %>%
# dplyr::arrange(desc(bmi))
# 
# Raku:
# $obj = starwars ;
# $obj = select-columns($obj, ("mass", "height") ) ;
# note "mutate by pairs is not implemented" ;
# $obj = $obj.sort({($_{"bmi"}) })>>.reverse
```


Additional examples can be found in this file:
[DataQueryWorkflows-examples.raku](./examples/DataQueryWorkflows-examples.raku).

### Translation to other human languages

```perl6
{say $_.key,  ":\n", $_.value, "\n"} for <Bulgarian English Korean Russian Spanish>.map({ $_ => ToDataQueryWorkflowCode($command, $_ ) });
```
```
# Bulgarian:
# използвай таблицата: starwars
# избери колоните: "mass", "height"
# присвои: bmi = mass/height^2
# сортирай в низходящ ред с колоните: "bmi"
# 
# English:
# use the data table: starwars
# select the columns: "mass", "height"
# assign: bmi = mass/height^2
# sort in descending order with the columns: "bmi"
# 
# Korean:
# 테이블 사용: starwars
# "mass", "height" 열 선택
# 양수인: bmi = mass/height^2
# 열과 함께 내림차순으로 정렬: "bmi"
# 
# Russian:
# использовать таблицу: starwars
# выбрать столбцы: "mass", "height"
# присваивать: bmi = mass/height^2
# сортировать в порядке убывания по столбцам: "bmi"
# 
# Spanish:
# utilizar la tabla: starwars
# escoger columnas: "mass", "height"
# apropiado: bmi = mass/height^2
# ordenar en orden descendente con columnas: "bmi"
```

-------

## Testing

There are three types of unit tests for:

1. Parsing abilities; see [example](./t/Basic-commands.t)

2. Interpretation into correct expected code; see [example](./t/Basic-commands-R-tidyverse.t)

3. Data transformation correctness;
   see [example](https://github.com/antononcube/R-packages/tree/master/DataQueryWorkflowsTests)

The unit tests R-package [AAp2] can be used to test both R and Python translations and equivalence between them.

There is a similar WL package, [AAp3].
(The WL unit tests package *can* have unit tests for Julia, Python, R -- not implemented yet.)

------

## On naming of translation packages

WL has a `System` context where usually the built-in functions reside. WL adepts know this, but others do not.
(Every WL package provides a context for its functions.)

My naming convention for the translation files so far is `<programming language>::<package name>`. 
And I do not want to break that invariant.

Knowing the package is not essential when invoking the functions. For example `ToDataQueryWorkflowCode[_,"R"]` produces
same results as `ToDataQueryWorkflowCode[_,"R-base"]`, etc.

------

## Versions

The original version of this Raku package was developed/hosted at
[ [AAp1](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/DataQueryWorkflows) ].

A dedicated GitHub repository was made in order to make the installation with Raku's `zef` more direct.
(As shown above.)

------

## TODO

- [ ] Implement SQL actions.

- [ ] Implement [Swift::TabularData](https://developer.apple.com/documentation/tabulardata) actions.
  
- [ ] Implement [Raku::Dan](https://github.com/p6steve/raku-Dan) actions.

- [ ] Make sure "round trip" translations work. 

------

## References

[AAp1] Anton Antonov,
[Data Query Workflows Raku Package](https://github.com/antononcube/ConversationalAgents/tree/master/Packages/Perl6/DataQueryWorkflows)
,
(2020),
[ConversationalAgents at GitHub/antononcube](https://github.com/antononcube/ConversationalAgents).

[AAp2] Anton Antonov,
[Data Query Workflows Tests](https://github.com/antononcube/R-packages/tree/master/DataQueryWorkflowsTests),
(2020),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).

[AAp3] Anton Antonov,
[Data Query Workflows Mathematica Unit Tests](https://github.com/antononcube/ConversationalAgents/blob/master/UnitTests/WL/DataQueryWorkflows-Unit-Tests.wlt),
(2020),
[ConversationalAgents at GitHub/antononcube](https://github.com/antononcube/ConversationalAgents).