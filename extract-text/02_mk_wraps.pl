#!/usr/bin/env perl

##  Copyright 2019 Eryk Wdowiak
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

##  perl script to clean and wrap text

use strict;
use warnings;
no warnings "uninitialized";

my @infiles = ("as31_en.txt","as31_sc.txt", "as30_en.txt","as30_sc.txt",
	       "as29_en.txt","as29_sc.txt", "as28_en.txt","as28_sc.txt",
	       "as27_en.txt","as27_sc.txt");

foreach my $infile (@infiles) {

    ( my $otfile = $infile ) =~ s/\.txt/-wrap.txt/;
    open( INFILE , "output_txt/$infile" ) || die "could not open $infile";
    open( OTFILE , ">wrapped/$otfile" ) || die "could not overwrite $otfile";

    while (<INFILE>) {
	chomp;
	my $line = $_ ;

	##  strip excess periods
	#$line =~ s/\.\.\.\.\.+/ /g;
	
	##  strip excess space 
	$line =~ s/\s+/ /g;
		
	##  add a single space to end of line
	$line .= " ";
	
	##  fix apostrophes
	$line =~ s/‘/'/g;
	$line =~ s/’/'/g;

	##  fix double quotes
	$line =~ s/“/"/g;
	$line =~ s/”/"/g;

	##  clean dot
	$line =~ s/•//g;

	##  add new line after period, exclaim or question
	$line =~ s/\.(")? /\.$1\n/g;
	$line =~ s/\!(")? /\!$1\n/g;
	$line =~ s/\?(")? /\?$1\n/g;
    
	##  print it out
	print OTFILE $line ;
    }

    close OTFILE;
    close INFILE;
}
