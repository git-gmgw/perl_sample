use strict;
use warnings;

package MyEnv;

my $FROM_ADDRESS = 'hoge@example.com';
my $TO_ADDRESS = 'hoge@example.com';
my $SUBJECT = 'てすと￡ソッ～ス';

sub new{
	my $pkg = shift;
	bless {},$pkg;
}

sub fromadd {return $FROM_ADDRESS};
sub mailto {return $TO_ADDRESS};
sub subject {return $SUBJECT};
1;
