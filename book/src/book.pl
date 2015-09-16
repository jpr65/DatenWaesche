# Buch

use warnings;
use strict;
use v5.18;

use lib '../../../AndroidPerl/spartanic/lib';

use Scalar::Validation qw(:all);

my @book_files = qw (

einband
1_zuallererst
einleitung
validierung_einfuehrung
anderes
);

my $complete_book_pod = "./gen/DatenWaesche_book.pod";
my $output_dir        = "gen";

sub parse_book_pod {
    my $book_pod_file = par file_bpod  => Filled      => shift;
    my $output_dir    = par output_dir => ExistingDir => shift;
    
    say "require $book_pod_file";

    my $result_pod_file = "$book_pod_file.pod";
    $book_pod_file      = "$book_pod_file.bpod";
   
    say OUTP "# include '$book_pod_file'";

    open (INP, $book_pod_file) or die "can't read book content $book_pod_file: $!"; 
    
    my $first_line = 1;
    while (<INP>) {
        my $line = $_;
        if ($first_line) {
            $line =~ s/.{0,5}#\s*Buch/# Buch/oi;
            print OUTP "#$line";
        }
        else {
            print OUTP $line;
        }
        $first_line = 0;
    }
}

say "gen $complete_book_pod ....";

open (OUTP, ">$complete_book_pod") or die "can't write book $complete_book_pod: $!"; 

say OUTP "=encoding utf8";

foreach my $book_file (@book_files) {
    parse_book_pod($book_file, $output_dir);
    say OUTP qq();
    say OUTP qq();
}

say "Done.";

# s/^$/;
