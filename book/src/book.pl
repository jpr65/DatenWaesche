﻿# Buch

use warnings;
use strict;
use v5.18;

use FileHandle;

use lib '../../../AndroidPerl/spartanic/lib';

use Scalar::Validation qw(:all);

my @book_files = qw (

0_einband
0_1_zuallererst

1_einleitung
1_validierung_einfuehrung
1_dimensionen

2_anforderungen_sw
2_dimensionen

3_problemfall_entschaerfung
3_einzelwert_validierung
3_dimensionen

5_anderes
5_index_links
);

my $complete_book_pod = "./gen/DatenWaesche_book.pod";
my $output_dir        = "gen";

my @comment_lines;

sub add_comment {
    push (@comment_lines, par Comment  => Filled => shift);
}

sub write_comments {
    my $fh   = par fh => FileHandle => shift;
    # my $fh = par is_a FileHandle => shift;

    return unless @comment_lines;

    say $fh "\n=begin comment\n";

    foreach my $comment_line (@comment_lines) {
        say $fh $comment_line;
    }

    say $fh "\n=end comment\n";

    @comment_lines = ();
}

sub parse_book_pod {
    my $book_pod_file = par file_bpod   => Filled     => shift;
    my $book_out_fh   = par book_out_fh => FileHandle => shift;
    
    say "require $book_pod_file";

    my $result_pod_file = "$book_pod_file.pod";
    $book_pod_file      = "$book_pod_file.bpod";
   
    add_comment "### include '$book_pod_file'";

    open (INP, $book_pod_file) or die "can't read book content $book_pod_file: $!"; 
    
    my $first_line = 1;
    while (<INP>) {
        my $line = $_;
        if ($first_line) {
            $line =~ s/.{0,5}#\s*Buch/# Buch/oi;
            add_comment "#$line";
            write_comments $book_out_fh;
        }
        elsif ($line =~ /^##/) {
            add_comment $line;
        }
        else {
            write_comments $book_out_fh if @comment_lines;
            print $book_out_fh $line;
        }
        $first_line = 0;
    }
    
    write_comments $book_out_fh;
}

say "gen $complete_book_pod ....";

my $book_out_fh = new FileHandle;

$book_out_fh->open(">$complete_book_pod") or die "can't write book $complete_book_pod: $!"; 

say $book_out_fh "=encoding utf8";

foreach my $book_file (@book_files) {
    parse_book_pod($book_file, $book_out_fh);
    say $book_out_fh qq();
    say $book_out_fh qq();
}

say "Done.";

# s/^$/;
