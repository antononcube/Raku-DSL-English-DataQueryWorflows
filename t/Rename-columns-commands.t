use v6;
use lib 'lib';
use DSL::English::DataQueryWorkflows::Grammar;
use Test;

plan 4;

# Shortcut
my $pCOMMAND = DSL::English::DataQueryWorkflows::Grammar;

#-----------------------------------------------------------
# Separate column commands
#-----------------------------------------------------------

## 1
ok $pCOMMAND.parse('rename the columns creation_date as StartDate'),
        'rename the columns creation_date as StartDate';

## 2
ok $pCOMMAND.parse('rename the columns creation_date as StartDate and ID as Project, and title as Group'),
        'rename the columns creation_date as StartDate and ID as Project, and title as Group';

## 3
ok $pCOMMAND.parse('rename the columns creation_date, ID, title to StartDate, Project, Group'),
        'rename the columns creation_date, ID, title to StartDate, Project, Group';

## 4
ok $pCOMMAND.parse('rename the columns StartDate = creation_date, Project = ID, and Group = title'),
        'rename the columns StartDate = creation_date, Project = ID, and Group = title';

done-testing;