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

##  perl script to assemble parallel text

use strict;
use warnings;
use File::Copy;

my %as = (
    "as31" => [ 40..45,  48..59,   72..93,  122..141 ],
    "as30" => [ 42..57,  60..75,   78..91,  112..119, 142..143, 146..147 ],
    "as29" => [ 44..85, 104..105, 124..129, 138..141 ],
    "as28" => [ 50..99, 112..121, 130..135 ],
    "as27" => [ 34..55,  58..69,  122..133, 136..137, 138..153 ],
    );

foreach my $key (sort keys %as) {
    my $asfile = "links/" . $key . ".pdf";
    my $scfile = $key . "_sc.tex";
    my $enfile = $key . "_en.tex";

    open( SCFILE , ">$scfile") || die "could not overwrite $scfile";
    open( ENFILE , ">$enfile") || die "could not overwrite $enfile";

    print SCFILE mk_head();
    print ENFILE mk_head();
    
    foreach my $page (@{$as{$key}}) {
	my $pdfpage = $page + 1;
	if (0 == $page % 2) {
	    ## PAGE NUMBER is even, so Sicilian
	    print SCFILE mk_page( $asfile, $pdfpage );
	} else {
	    ## PAGE NUMBER is odd, so English
	    print ENFILE mk_page( $asfile, $pdfpage );
	}
    }
    
    print SCFILE mk_foot();
    print ENFILE mk_foot();

    close ENFILE;
    close SCFILE;

    my $sclatex = 'pdflatex \\\\nonstopmode\\\\input ' . $scfile ;
    my $enlatex = 'pdflatex \\\\nonstopmode\\\\input ' . $enfile ;
    my $scpdf = $key . "_sc.pdf";
    my $enpdf = $key . "_en.pdf";
    my $scpdfcmd = "pdftotext " . $scpdf;
    my $enpdfcmd = "pdftotext " . $enpdf;
    my $sctxt = $key . "_sc.txt";
    my $entxt = $key . "_en.txt";
    
    system( $sclatex );
    system( $enlatex );
    system( $scpdfcmd );
    system( $enpdfcmd );

    move( $scfile , 'output_pdf/'. $scfile);
    move( $enfile , 'output_pdf/'. $enfile);
    move( $scpdf  , 'output_pdf/'. $scpdf);
    move( $enpdf  , 'output_pdf/'. $enpdf);
    move( $sctxt  , 'output_txt/'. $sctxt);
    move( $entxt  , 'output_txt/'. $entxt);
    
    my $scaux   = $key . "_sc.aux";
    my $enaux   = $key . "_en.aux";
    my $sclog   = $key . "_sc.log";
    my $enlog   = $key . "_en.log";
    unlink( $scaux , $enaux , $sclog , $enlog );
}


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_page {
    my $file = $_[0];
    my $page = $_[1];
    my $txt;
    $txt .= "\n";
    $txt .= '\includegraphics[page='. $page .',angle=180,'."\n";
    $txt .= '  %% trim={"left"}{"bottom"}{"right"}{"top"}'."\n";
    $txt .= '  viewport={0.00in} {1.21in} {6.02222in} {8.34722in},'."\n";
    $txt .= '  clip=true]{'. $file .'}'."\n";
    $txt .= "\n";
    return $txt;
}

sub mk_head {
    my $txt;
    $txt .= '\documentclass[10pt,letterpaper]{article}'."\n";
    $txt .= "\n";
    $txt .= '\usepackage{graphicx}'."\n";
    $txt .= "\n";
    $txt .= '%%  margins and indentations'."\n";
    $txt .= '\setlength{\tabcolsep}{0em}'."\n";
    $txt .= '\setlength\topmargin{-1.00in}'."\n";
    $txt .= '\setlength\textheight{11.00in}'."\n";
    $txt .= '\setlength\textwidth{8.50in}'."\n";
    $txt .= '\setlength\oddsidemargin{-0.50in}'."\n";
    $txt .= '\setlength\evensidemargin{-0.50in}'."\n";
    $txt .= '\setlength\parindent{0.00in}'."\n";
    $txt .= '\setlength\parskip{0.0em}'."\n";
    $txt .= "\n";
    $txt .= '\pagestyle{empty}'."\n";
    $txt .= "\n";
    $txt .= '\begin{document}'."\n";
    $txt .= "\n";
    return $txt;
}

sub mk_foot {
    my $txt;
    $txt .= "\n";
    $txt .= '\end{document}'."\n";
    $txt .= "\n";
    return $txt;
}
