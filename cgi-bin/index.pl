#!/usr/bin/perl

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

use strict;
use warnings;
no warnings qw(uninitialized numeric void);
use CGI qw(:standard);

use lib '/home/soul/.perl/lib/perl5';
use Napizia::Translator;
use Napizia::HtmlIndex;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $topnav = '../config/topnav.html';
my $footnv = '../config/navbar-footer.html';

#my $last_update = 'urtimu aggiurnamentu: 2020.08.05';
my $last_update = 'urtimu agg.: 2020.09.07';

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
    print mk_form( $lgparm , $intext );
    print mk_ottrans( $ottrans , $lgparm , $switch , $last_update );
    print mk_footer( $footnv );

} else {

    ##  INPUT
    ##  =====

    my $lgparm = ( ! defined param('langs')  ) ? "scen" : lc( param('langs'));
    $lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" ) ? "scen" : $lgparm;
    
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
    my $subwords = ( $lgparm eq "scen" ) ? "subwords/subwords.sc" : "subwords/subwords.en";
    my $tnfmodel = ( $lgparm eq "scen" ) ? "tnf_scen" : "tnf_ensc";
    
    my $ottrans = "";
    my $spoken_form = "";
    my $switch = "TRUE";
    
    if ( $intext ne "" ) {
	my $tokenized = ( $lgparm eq "scen" ) ? sc_tokenizer($intext) : en_tokenizer($intext);
	$tokenized =~ s/"/\\"/g;
	my $subsplit  = `/bin/echo "$tokenized" | $subwdnmt apply-bpe -c $subwords`;
	chomp( $subsplit );
	$subsplit =~ s/"/\\"/g;
	my $output    = `/bin/echo "$subsplit" | $sockeye --models $tnfmodel --use-cpu 2> /dev/null`;
	chomp( $output );
	$output =~ s/\@\@ //g;
	$ottrans  = ( $lgparm eq "scen" ) ? en_detokenizer($output) : sc_detokenizer($output);
	
	$spoken_form = ( $lgparm eq "ensc" ) ? mk_spoken($ottrans) : $ottrans;
	
    } else {
	##  put some text in the box
	$ottrans .= 'Traduci frasi dî domini di cultura, littiratura e storia cû nostru '."\n";
	$ottrans .= '<i>Tradutturi Sicilianu!</i>'."\n";
	#$ottrans .= 'Scrivi na frasi nta la casedda e clicca: "Traduci."'."\n";
	$ottrans .= '<br><br>'."\n";
	$ottrans .= 'Translate sentences from the domains of culture, literature and history with our '."\n";
	$ottrans .= '<i>Sicilian Translator!</i>'."\n"; 
	#$ottrans .= 'Type a sentence into the box and click: "Translate."'."\n";

	##  prevent it from contracting by setting language parameter to Sc->En
	##  prevent it from translating by setting switch to False
	$lgparm = "scen";
	$switch = "FALSE";
    }
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  PRINT HTML
    ##  ===== ====

    print mk_header( $topnav );
    print mk_form( $lgparm , $intext );
    print mk_ottrans( $ottrans , $lgparm , $switch , $spoken_form, $last_update );
    print mk_footer( $footnv );
}
