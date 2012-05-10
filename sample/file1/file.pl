#!/usr/bin/perl
use strict;
use warnings;
use IO::File;

if( @ARGV != 1 ){
    die "$0 [value] \n";
}
my ( $text, ) = @ARGV;

# ファイルへの出力
my $fh = IO::File->new("> file.txt");
for ( my $i=0; $i < 5; $i++){
	print $fh "$text$i\n";
}
if (defined($fh)){$fh->close;}

# ファイルからの読み込み
my $fhr = IO::File->new("< file.txt");
# ファイルがない（開けなかった）場合、ファイルハンドルは未定義(defined()がfalseになる)
if (defined($fhr)){
	print <$fhr>;
	# →
	# while (<$fhr>) {
	# 	print $_;
	# }
}
if (defined($fhr)){$fhr->close;}


__END__
