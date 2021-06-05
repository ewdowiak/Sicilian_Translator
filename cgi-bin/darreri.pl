#!/usr/bin/perl

##  Copyright 2021 Eryk Wdowiak
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
no warnings qw(uninitialized numeric void);
use CGI qw(:standard);

use lib '/home/soul/.perl/lib/perl5';
use Napizia::Translator;
use Napizia::HtmlDarreri;
use Napizia::Italian;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $nbest  = 5;
my $topnav = '../config/topnav.html';
my $footnv = '../config/navbar-footer.html';
my $italian = "enable";
my $landing = "darreri.pl";

#my $last_update = 'urtimu aggiurnamentu: 2020.08.05';
my $last_update = 'urtimu agg.: 2021.06.05';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CHECK BLOCKED IP LIST
##  ===== ======= == ====

my $ip_addr = remote_addr();
my $block = "/home/soul/website/block.list";
my $blbkp = "/home/soul/website/block.list.bkp";

my $blocked = "FALSE";
open( CHECK , $block ) || open( CHECK , $blbkp );
while (<CHECK>) {
    chomp;
    my $line = $_;
    if ( $ip_addr eq $line ) {
	$blocked = "TRUE";
    }
}
close CHECK;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  if on blocked IP list return block page
##  otherwise, translate

if ( $blocked ne "FALSE" ) {

    my $lgparm = "scen";
    my $intext = "Scusami! Lu tò IP ha statu bluccatu picchì sta facennu troppi richiesti.";
    my $ottrans = "I'm sorry! Your IP has been blocked because it is making too many requests. ";
    $ottrans .= '<br><br>';
    $ottrans .= "When bots make too many requests, human beings do not get served. ";
    $ottrans .= "So if you are a human being, please accept our apologies and write to: ";
    $ottrans .= '<a href='."'".'mailto:admin@napizia.com'."'".'>admin@napizia.com</a> for assistance.';
    my $switch = "FALSE";

    ##  PRINT HTML
    ##  ===== ====
    
    print mk_header( $topnav );
    print mk_form( $lgparm , $intext ,"","", "EMPTY", $italian);
    print mk_ottrans( $ottrans , $lgparm , $last_update );
    print mk_footer( $footnv );

} else {

    ##  INPUT
    ##  =====

    my $lgparm = ( ! defined param('langs')  ) ? "scen" : lc( param('langs'));
    $lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" &&
		$lgparm ne "iten" && $lgparm ne "enit" &&
		$lgparm ne "itsc" && $lgparm ne "scit") ? "scen" : $lgparm;
    
    my $intext = ( ! defined param('intext') ) ? "" : param('intext');
    $intext = rm_malice( $intext );
    $intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
    $intext =~ s/\n/ /g;
    $intext =~ s/\s+/ /g;
    $intext =~ s/^ //g;
    $intext =~ s/ $//g;
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  TRANSLATE and DETOKENIZE
    ##  ========= === ==========
    
    my $sockeye  = "/home/soul/.local/bin/sockeye-translate";
    my $subwdnmt = "/home/soul/.local/bin/subword-nmt";

    my %sbwhash = ( "scen" => "subwords/subwords.sc", "ensc" => "subwords/subwords.en",
		    "iten" => "subwords/subwords.it", "enit" => "subwords/subwords.en",
		    "itsc" => "subwords/subwords.it", "scit" => "subwords/subwords.sc");
    my %tnfhash = ( "scen" => "tnf_scen", "ensc" => "tnf_ensc",
		    "iten" => "tnf_scen", "enit" => "tnf_ensc",
		    "itsc" => "tnf_m2m",  "scit" => "tnf_m2m");
    my %dirhash = ( "scen" => "",       "ensc" => "<2sc> ",
		    "iten" => "",       "enit" => "<2it> ",
		    "itsc" => "<2sc> ", "scit" => "<2it> ");

    my $subwords = $sbwhash{$lgparm};
    my $tnfmodel = $tnfhash{$lgparm};
    my $dirtoken = $dirhash{$lgparm};
    
    ##  reserve for input form
    my $tokenized;
    my $subsplit;

    ##  reserve for output form
    my @scores;
    my @ottrans;
    
    if ( $intext ne "" ) {

	##  tokenization
	if (  $lgparm ne "ensc" && $lgparm ne "enit" && $lgparm ne "iten" && $lgparm ne "itsc" ) {
	    ##  cases:  Sc->En and Sc->It
	    $tokenized = sc_tokenizer($intext);
	} elsif ($lgparm ne "ensc" && $lgparm ne "enit" ) {
	    ##  cases:  It->En and It->Sc
	    $tokenized = it_tokenizer($intext) ;
	} else {
	    ##  cases:  En->Sc and En->It
	    $tokenized = en_tokenizer($intext);
	}
	$tokenized =~ s/ '/ ' /g;
	$tokenized =~ s/^'/ ' /g;
	$tokenized =~ s/\s+/ /g;
	$tokenized =~ s/^ //;
	$tokenized =~ s/ $//;
	$tokenized =~ s/"/\\"/g;

	##  subword splitting
	$subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
	chomp( $subsplit );
	$subsplit =~ s/"/\\"/g;

	##  append directional token
	my $intrans = $dirtoken . $subsplit;
	
	##  translation
	my $output    = `/bin/echo "$intrans" | $sockeye --models $tnfmodel --nbest-size $nbest --use-cpu 2> /dev/null`;
	chomp( $output );
	$output =~ s/\@\@ //g;
	$output =~ s/ ~~'s/'s/g;

	##  separate translations
	my $raw_tran = $output;
	$raw_tran =~ s/^.*translations": \[//;
	$raw_tran =~ s/\]}$//;
	$raw_tran =~ s/\\"/"/g;
	$raw_tran =~ s/^"//;
	$raw_tran =~ s/", "/~/g;
	$raw_tran =~ s/"$//;
	my @raw_trans = split( /~/ , $raw_tran );
	
	##  separate scores
	my $raw_score = $output;
	$raw_score =~ s/^.*scores": \[//;
	$raw_score =~ s/\].*$//;
	$raw_score =~ s/,//g;
	my @raw_scores = split( /\s+/ , $raw_score );
	
	##  scores and detokenization
	foreach my $raw (@raw_scores) {
	    my $score = sprintf("%.03f",$raw);
	    push( @scores , $score );
	}
	foreach my $raw (@raw_trans) {
	    my $ottran;
	    if (  $lgparm ne "scen" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "scit" ) {
		##  cases:  En->Sc and It->Sc
		$ottran = sc_detokenizer($raw);
	    } elsif ( $lgparm ne "scen" && $lgparm ne "iten" ) {
		##  cases:  Sc->It and En->It
		$ottran = it_detokenizer($raw);
	    } else {
		##  cases:  Sc->En and It->En
		$ottran = en_detokenizer($raw);
	    }	    
	    push( @ottrans , $ottran );
	}
    }
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

    ##  what to do if no input
    my $empty = 'On this page, you can see the tokenization and subword splitting of an input sentence. ';
    $empty .= 'And you can see the Top&nbsp;5 translations with their scores.'."\n";
    $empty .= '<br><br>'."\n";
    $empty .= 'Type a sentence into the box, then press "Translate."'."\n";
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

    ##  PRINT HTML
    ##  ===== ====
    print mk_header( $topnav , $landing );
    print mk_form( $lgparm , $intext , $tokenized , $subsplit , "FALSE", $italian , $landing );
    if ( $intext ne "" ) {
    	print mk_otmenu( \@scores , \@ottrans , $lgparm , $last_update , $nbest , $landing );
    } else {
    	print mk_ottrans( $empty , $lgparm , $last_update );
    }
    print mk_footer( $footnv , $landing );
}
