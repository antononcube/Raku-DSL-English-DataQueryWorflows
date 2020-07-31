=begin comment
#==============================================================================
#
#   Data transformation workflows grammar in Raku Perl 6
#   Copyright (C) 2018  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================
=end comment

use v6;

use DSL::Shared::Roles::English::CommonParts;
use DSL::Shared::Roles::English::PipelineCommand;
use DSL::Shared::Roles::PredicateSpecification;
use DSL::Shared::Roles::ErrorHandling;

use DSL::English::DataQueryWorkflows::Grammar::DataQueryPhrases;

grammar DSL::English::DataQueryWorkflows::Grammar
        does DSL::Shared::Roles::ErrorHandling
        does DSL::English::DataQueryWorkflows::Grammar::DataQueryPhrases
        does DSL::Shared::Roles::PredicateSpecification
        does DSL::Shared::Roles::English::PipelineCommand {
    # TOP
    rule TOP {
        <pipeline-command> |
        <data-load-command> |
        <select-command> |
        <filter-command> |
        <mutate-command> |
        <group-command> |
        <ungroup-command> |
        <arrange-command> |
        <rename-columns-command> |
        <drop-columns-command> |
        <statistics-command> |
        <join-command> |
        <reshape-command> |
        <cross-tabulation-command> }

    # Load data
    rule data-load-command { <load-data-table> | <use-data-table> }
    rule data-location-spec { <dataset-name> }
    rule load-data-table { <.load-data-directive> <data-location-spec> }
    rule use-data-table { [ <.use-verb> | <.using-preposition> ] <.the-determiner>? <.data>? <variable-name> }

    # Select command
    rule select-command { <select> <.the-determiner>? [ <.variables-noun> | <.variable-noun> | <.columns> ]? <variable-names-list> }

    # Filter command
    rule filter-command { <filter> <.the-determiner>? <.rows>? [ <.for-which-phrase>? | <.by-preposition> ] <filter-spec> }
    rule filter-spec { <predicates-list> }

    # Mutate command
    rule mutate-command { [ <mutate> | <assign> | <transform-verb> ] <.by-preposition>? <assign-pairs-list> }
    rule assign-pair { <assign-pair-lhs> <.assign-to-symbol> <assign-pair-rhs> }
    rule assign-pair-lhs { <quoted-variable-name> }
    rule assign-pair-rhs { <quoted-variable-name> | <wl-expr> }
    rule assign-pairs-list { <assign-pair>+ % <.list-separator> }

    # Group command
    rule group-command { <group-by> <variable-names-list> }

    # Ungroup command
    rule ungroup-command { <ungroup-simple-command> }
    rule ungroup-simple-command { <ungroup-verb> | <combine-verb> }

    # Arrange command
    rule arrange-command { <arrange-command-descending> | <arrange-command-ascending> }
    rule arrange-command-filler { <by-preposition> <the-determiner>? [ <variables-noun> | <variable-noun> ]? }
    rule arrange-simple-spec { <.by-preposition>? <.the-determiner>? [ <.variables-noun> | <.variable-noun> ]? <variable-names-list> }
    rule arrange-command-ascending {
        <.arrange> <.ascending>? <arrange-simple-spec> |
        <.arrange>  <arrange-simple-spec> <.ascending> }
    rule arrange-command-descending {
        <.arrange> <.descending> <arrange-simple-spec> |
        <.arrange> <arrange-simple-spec> <.descending> }

    # Rename columns
    rule rename-columns-command { <rename-columns-simple> }
    rule rename-columns-simple { <.rename-directive> <.the-determiner>? [ <.columns> | <.variable-noun> | <.variables-noun> ]?
                                 <current=.quoted-variable-names-list>
                                 [ <.to-preposition> | <.into-preposition> | <.as-preposition> ]
                                 <new=.quoted-variable-names-list> }

    # Drop columns
    rule drop-columns-command { <drop-columns-simple> }
    rule drop-columns-simple { <.delete-directive> <.the-determiner>? [ <.columns> | <.variable-noun> | <.variables-noun> ]? <todrop=.quoted-variable-names-list> }

    # Statistics command
    rule statistics-command { <count-command> | <glimpse-data> | <summarize-data> | <summarize-all-command> }
    rule count-command { <compute-directive> <.the-determiner>? [ <count-verb> | <counts-noun> ] | <count-verb> }
    rule glimpse-data { <.display-directive>? <.a-determiner>? <.glimpse-verb> <.at-preposition>? <.the-determiner>? <data>  }
    rule summarize-data { [ <summarize-verb> | <summarise-verb> ] <data> | <display-directive> <data>? <summary> }
    rule summarize-all-command { [ <summarize-verb> | <summarise-verb> ] <them-pronoun>? <all-determiner>? }

    # Join command
    rule join-command { <inner-join-spec> | <left-join-spec> | <right-join-spec> | <semi-join-spec> | <full-join-spec> }
    rule join-by-spec { <assign-pairs-list> | <quoted-variable-names-list> }
    rule full-join-spec  { <.full-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule inner-join-spec { <.inner-adjective> <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule left-join-spec  { <.left-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule right-join-spec { <.right-adjective> <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule semi-join-spec  { <.semi-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }

    # Cross tabulate command
    rule cross-tabulate-command { <cross-tabulate-command> | <contingency-matrix-command> }
    rule cross-tabulation-command { <.cross-tabulate-phrase> <cross-tabulation-formula> }
    rule contingency-matrix-command { <.create-directive> [ <.the-determiner> | <.a-determiner>]? <.contingency-matrix-phrase> [ <.using-preposition> | <.with-formula-phrase> ] <cross-tabulation-formula> }
    rule cross-tabulation-formula { <.variable-noun>? <rows-variable-name> [ <.list-separator-symbol> | <.with-preposition> ] <.variable-noun>? <columns-variable-name> [ <.over-preposition> <values-variable-name> ]? }
    rule rows-variable-name { <variable-name> }
    rule columns-variable-name { <variable-name> }
    rule values-variable-name { <variable-name> }

    # Reshape command
    rule reshape-command { <pivot-longer-command> | <pivot-wider-command> }

    # To long form command
    rule pivot-longer-command { <.convert-verb>? <.to-long-form-phrase>  <pivot-longer-arguments-list> }
    regex pivot-longer-arguments-list { <pivot-longer-argument>+ % [ <list-separator> | <ws> ] }
    regex pivot-longer-argument { <pivot-longer-columns-spec> | <pivot-longer-variable-column-name-spec> | <pivot-longer-value-column-name-spec> }

    rule filler-separator { <with-preposition> | <using-preposition> | <for-preposition> }

    rule pivot-longer-columns-spec { <.filler-separator>? <.the-determiner>? <.pivot-columns-phrase> <quoted-variable-names-list> }

    rule pivot-longer-variable-column-name-spec { <.filler-separator>? <.the-determiner>? <.variable-column-name-phrase> <quoted-variable-name> }

    rule pivot-longer-value-column-name-spec { <.filler-separator>? <.the-determiner>? <.value-column-name-phrase> <quoted-variable-name> }

    # To wide form command
    rule pivot-wider-command { <?> }
}
