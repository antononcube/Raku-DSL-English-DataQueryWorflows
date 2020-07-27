use v6;
use lib 'lib';
use DSL::English::DataQueryWorkflows::Grammar;
use Test;

plan 11;

# Shortcut
my $pCOMMAND = DSL::English::DataQueryWorkflows::Grammar;

#-----------------------------------------------------------
# Creation
#-----------------------------------------------------------

ok $pCOMMAND.parse('use data frame dfTitanic'),
        'use data frame dfTitanic';

ok $pCOMMAND.parse('select passengerAge'),
        'select passengerAge';

ok $pCOMMAND.parse('select passengerAge and passengerSex'),
        'select passengerAge and passengerSex';

ok $pCOMMAND.parse('select passengerAge, passengerClass, and passengerSex'),
        'select passengerAge, passengerClass, and passengerSex';

ok $pCOMMAND.parse('drop passengerAge, passengerClass, and passengerSex'),
        'drop passengerAge, passengerClass, and passengerSex';

ok $pCOMMAND.parse('delete passengerAge and passengerSex'),
        'delete passengerAge and passengerSex';

ok $pCOMMAND.parse('drop passengerAge, passengerClass, and passengerSex'),
        'drop passengerAge, passengerClass, and passengerSex';

ok $pCOMMAND.parse('transform bmi1 = mass1 and bmi2 = mass2'),
        'transform bmi1 = mass1 and bmi2 = mass2';

ok $pCOMMAND.parse('transform bmi1 = mass1, bmi2 = mass2'),
        'transform bmi1 = mass1, bmi2 = mass2';

ok $pCOMMAND.parse('mutate bmi = `mass/height^2`'),
        'mutate bmi = `mass/height^2`';

ok $pCOMMAND.parse('mutate bmi = `mass/height^2` and bmi2 = `masx/height^2`'),
        'mutate bmi = `mass/height^2` and bmi2 = `masx/height^2`';

done-testing;