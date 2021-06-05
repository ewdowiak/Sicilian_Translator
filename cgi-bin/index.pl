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
use Napizia::HtmlIndex;
use Napizia::Italian;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $topnav = '../config/topnav.html';
my $footnv = '../config/navbar-footer.html';
my $italian = "enable";
my $landing = "index.pl";

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
    print mk_form( $lgparm , $intext , $italian );
    print mk_ottrans( $ottrans , $lgparm , $switch , $last_update );
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
    
    ##  initialize holders
    my $ottrans = "";
    my $spoken_form = "";
    my $switch = "TRUE";
    
    if ( $intext ne "" ) {

	my $tokenized;
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
	my $subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
	chomp( $subsplit );
	$subsplit =~ s/"/\\"/g;

	##  append directional token
	my $intrans = $dirtoken . $subsplit;
	
	##  translation
	my $output    = `/bin/echo "$intrans" | $sockeye --models $tnfmodel --use-cpu 2> /dev/null`;
	chomp( $output );
	$output =~ s/\@\@ //g;
	$output =~ s/ ~~'s/'s/g;
	
	##  detokenization
	if (  $lgparm ne "scen" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "scit" ) {
	    ##  cases:  En->Sc and It->Sc
	    $ottrans = sc_detokenizer($output);
	} elsif ( $lgparm ne "scen" && $lgparm ne "iten" ) {
	    ##  cases:  Sc->It and En->It
	    $ottrans = it_detokenizer($output);
	} else {
	    ##  cases:  Sc->En and It->En
	    $ottrans = en_detokenizer($output);
	}
	
	$spoken_form = ( $lgparm eq "ensc" || $lgparm eq "itsc" ) ? mk_spoken($ottrans) : $ottrans;
	
    } else {
	##  put some text in the box
	$ottrans .= 'Traduci frasi di cultura, littiratura e storia '."\n";
	#$ottrans .= 'Traduci tra Ngrisi, Talianu e Sicilianu '."\n";
	$ottrans .= 'cû nostru <i>Tradutturi Sicilianu!</i>'."\n";
	#$ottrans .= 'Scrivi na frasi nta la casedda e clicca: "Traduci."'."\n";
	$ottrans .= '<br><br>'."\n";
	$ottrans .= 'Translate sentences about culture, literature and history '."\n";
	#$ottrans .= 'Translate between English, Italian and Sicilian '."\n";
	$ottrans .= 'with our <i>Sicilian Translator!</i>'."\n"; 
	#$ottrans .= 'Type a sentence into the box and click: "Translate."'."\n";

	##  prevent it from contracting by setting language parameter to Sc->En
	##  prevent it from translating by setting switch to False
	$lgparm = "scen";
	$switch = "FALSE";
    }
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  PRINT HTML
    ##  ===== ====

    print mk_header( $topnav , $landing );
    print mk_form( $lgparm , $intext , $italian , $landing );
    print mk_ottrans( $ottrans , $lgparm , $switch , $spoken_form, $last_update , $landing );
    print mk_footer( $footnv , $landing );
}
