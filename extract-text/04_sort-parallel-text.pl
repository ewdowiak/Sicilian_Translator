#!/usr/bin/env perl

##  Sicilian_Translator/extract-text/04_sort-parallel-text.pl

##  Copyright 2020 Eryk Wdowiak
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      http://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

use strict;
use warnings;

##  parameters
my $minwords =  5;
my $maxwords = 50;
my $minratio =  0.75;
my $maxratio =  1.33;
my $minscore =  0.30;

##  hunaligned files
my @infiles = ("aligned/as31_ha.csv", "aligned/as30_ha.csv", "aligned/as29_ha.csv",
	       "aligned/as28_ha.csv", "aligned/as27_ha.csv",);

##  one file of "good lines" and one file of "unused lines" (we'll use them later)
my $csvfile = "AS27-31_aligned_set01.csv";
my $csvunus = "AS27-31_aligned_set02-unused.csv";

##  create header for CSV files
my $header = "line"."\t"."sicilian"."\t"."english"."\t"."score"."\t"."sc words"."\t"."en words";

##  open overwrites
open( CSVFILE , ">$csvfile" ) || die "could not overwrite $csvfile";
open( CSVUNUS , ">$csvunus" ) || die "could not overwrite $csvunus";

##  print header
print CSVFILE $header ."\n";
print CSVUNUS $header ."\n";

##  for each input file
foreach my $infile (@infiles) {

    ##  keep track of line count
    my $line_count = 0;
    
    ##  open input file
    open( INFILE , $infile ) || die "could not open $infile";
    while(<INFILE>) {
	chomp;
	my $line = $_;

	##  split columns
	my @cols = split(/\t/ , $line );
	my $sctxt = $cols[0];
	my $entxt = $cols[1];
	my $score = $cols[2];

	##  convert quotes, dashes
	$sctxt =~ s/\`/'/g; $entxt =~ s/\`/'/g;
	$sctxt =~ s/‘/'/g ; $entxt =~ s/‘/'/g ;
	$sctxt =~ s/’/'/g ; $entxt =~ s/’/'/g ;
	$sctxt =~ s/“/"/g ; $entxt =~ s/“/"/g ;
	$sctxt =~ s/”/"/g ; $entxt =~ s/”/"/g ;
	$sctxt =~ s/«/"/g ; $entxt =~ s/«/"/g ;
	$sctxt =~ s/»/"/g ; $entxt =~ s/»/"/g ;
	$sctxt =~ s/—/-/g ; $entxt =~ s/—/-/g ;
	
	##  convert braces
	$sctxt =~ s/\{/(/g; $entxt =~ s/\{/(/g;
	$sctxt =~ s/\}/)/g; $entxt =~ s/\}/)/g;
	$sctxt =~ s/\[/(/g; $entxt =~ s/\[/(/g;
	$sctxt =~ s/\]/)/g; $entxt =~ s/\]/)/g;

	##  convert elipses
	$sctxt =~ s/…/.../g; $entxt =~ s/…/.../g;
	
	##  strip breaks
	$sctxt =~ s/~~~/ /g;  $entxt =~ s/~~~/ /g;
	
	##  rid excess spaces
	$sctxt =~ s/\s+/ /g;  $entxt =~ s/\s+/ /g;
	$sctxt =~ s/^ //;     $entxt =~ s/^ //;
	$sctxt =~ s/ $//;     $entxt =~ s/ $//;
	
	##  does it contain unusual characters?
	my $sc_unusual = grep( !/[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú\.\?\!\,\;\:\"\'\s\(\)\-]*$/ , $sctxt);
	my $en_unusual = grep( !/[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú\.\?\!\,\;\:\"\'\s\(\)\-]*$/ , $entxt);

	##  anything with http? or email?
	my $sc_web = grep( /\@|http|www/i , $sctxt);
	my $en_web = grep( /\@|http|www/i , $entxt);

	##  add web stuff to unusual
	$sc_unusual = $sc_unusual + $sc_web;
	$en_unusual = $en_unusual + $en_web;
	
	##  word count and word ratio
	my @sc_words = split( / / , $sctxt );
	my @en_words = split( / / , $entxt );
	my $sc_count = $#sc_words +1;
	my $en_count = $#en_words +1;
	my $wd_ratio = ( $sc_count < 1 || $en_count < 1 ) ? 0 : $sc_count / $en_count ;

	##  update line count and create CSV line
	$line_count++;
	my $times_ten = 10 * $line_count ;
	my $csvline = $times_ten ."\t". $sctxt ."\t". $entxt ."\t". $score ."\t". $sc_count ."\t". $en_count;
	
	##  where should we print the lines?
	if ( $minwords < $sc_count && $sc_count < $maxwords &&
	     $minwords < $en_count && $en_count < $maxwords &&
	     $minratio < $wd_ratio && $wd_ratio < $maxratio &&
	     $sc_unusual == 0 && $en_unusual == 0 && $score > $minscore ) {
	    
	    ##  print this "good line" to the CSV file
	    print CSVFILE $csvline . "\n";
	} elsif ( $sc_count > 0 || $en_count > 0 ) {
	    ##  print line to another CSV file (for later use)
	    print CSVUNUS $csvline . "\n";	    
	}
    }
    close INFILE;
}
close CSVUNUS;
close CSVFILE;
