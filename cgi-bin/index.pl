#!/usr/bin/perl

##  Copyright 2021-2026 Eryk Wdowiak
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
use utf8;

use URI::Escape;
use Mojolicious::Lite -signatures;

my $home = "/home/eryk";

use lib "/home/eryk/.perl/lib/perl5";

use Napizia::Translator;
use Napizia::HtmlIndex;
use Napizia::SicilianLS2;
use Napizia::English;
use Napizia::Italian;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CONFIG
##  ======

my $topnav = '../config/eryk2-topnav.html';
my $footnv = '../config/eryk2-navbar.html';
my $italian = "enable";
my $landing = "index.pl";

#my $last_update = 'ultimu aggiurnamentu: 2023.05.20';
my $last_update = 'ultimu agg.: 2024.12.31';

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

get '/' => sub ($c) {
    my $par_intext = $c->param('intext');
    my $par_langs  = $c->param('langs');
    my $output = mk_htmlpage( $par_intext , $par_langs );
    $c->render(text => $output);
};

post '/' => sub ($c) {
    my $par_intext = $c->param('intext');
    my $par_langs  = $c->param('langs');
    my $output = mk_htmlpage( $par_intext , $par_langs );
    $c->render(text => $output);
};

app->start;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CREATE WEBPAGE
##  ====== =======

sub mk_htmlpage{ 

    my $par_intext = $_[0];
    my $par_langs  = $_[1];
    
    my $lgparm = ( ! defined $par_langs ) ? "ensc" : lc($par_langs);
    $lgparm = ( $lgparm ne "scen" && $lgparm ne "ensc" &&
		$lgparm ne "iten" && $lgparm ne "enit" &&
		$lgparm ne "itsc" && $lgparm ne "scit") ? "ensc" : $lgparm;
    
    my $intext = ( ! defined $par_intext ) ? "" : $par_intext;



##  CHECK BLOCKED IP LIST
##  ===== ======= == ====

## my $ip_addr = remote_addr();
my $ip_addr = $ENV{REMOTE_ADDR};

my $block = $home ."/website/block.list";
my $blbkp = $home ."/website/block.list.bkp";

my $hvlst = $home ."/website/heavy.list";
my $hvbkp = $home ."/website/heavy.list.bkp";

my $blocked = "FALSE";
open( my $fh_check , "<:encoding(utf-8)" , $block );
# || open( my $fh_check , "<:encoding(utf-8)" , $blbkp );
while (<$fh_check>) {
    chomp;
    my $line = $_;
    if ( $ip_addr eq $line ) {
	$blocked = "TRUE";
    }
}
close $fh_check;

my $heavied = "FALSE";
open( my $fh_ckhvy , "<:encoding(utf-8)" , $hvlst );
# || open( my $fh_ckhvy , "<:encoding(utf-8)" , $hvbkp );
while (<$fh_ckhvy>) {
    chomp;
    my $line = $_;
    if ( $ip_addr eq $line ) {
	$heavied = "TRUE";
    }
}
close $fh_ckhvy;

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  if on blocked IP list return block page
##  otherwise, translate

if ( $blocked ne "FALSE" ) {

    $lgparm = "ensc";
    $intext = "Scusami! Lu tò IP ha statu bluccatu picchì sta facennu troppi richiesti.";
    my $ottrans = "I'm sorry! Your IP has been blocked because it is making too many requests. ";
    $ottrans .= '<br><br>';
    $ottrans .= "When bots make too many requests, human beings do not get served. ";
    $ottrans .= "So if you are a human being, please accept our apologies and write to: ";
    $ottrans .= '<a href='."'".'mailto:admin@napizia.com'."'".'>admin@napizia.com</a> for assistance.';
    my $switch = "FALSE";
    
    ##  PRINT HTML
    ##  ===== ====
    
    my $othtml;
    $othtml .= mk_header( $topnav );
    $othtml .= mk_form( $lgparm , $intext , $italian );
    $othtml .= mk_ottrans( $ottrans , $lgparm , $switch , $last_update );
    $othtml .= mk_footer( $footnv );

    return $othtml;

} else {

    ##  INPUT
    ##  =====

    $intext = rm_malice( $intext );
    $intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
    $intext =~ s/\n/ /g;
    $intext =~ s/\s+/ /g;
    $intext =~ s/^ //g;
    $intext =~ s/ $//g;
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  TRANSLATE and DETOKENIZE
    ##  ========= === ==========
    
    my $sockeye  = $home ."/.local/bin/sockeye-translate";
    my $subwdnmt = $home ."/.local/bin/subword-nmt";

    my %sbwhash = ( "scen" => "subwords/subwords.sc", "ensc" => "subwords/subwords.en",
		    "iten" => "subwords/subwords.it", "enit" => "subwords/subwords.en",
		    "itsc" => "subwords/subwords.it", "scit" => "subwords/subwords.sc");
    my %tnfhash = ( "scen" => "tnf_scen", "ensc" => "tnf_ensc",
		    "iten" => "tnf_iten", "enit" => "tnf_enit",
		    "itsc" => "tnf_itsc", "scit" => "tnf_scit");
    my %dirhash = ( "scen" => "<2en> ", "ensc" => "<2sc> ",
		    "iten" => "<2en> ", "enit" => "<2it> ",
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
	my $output ;

	##  first try local URL
	my $local_url = 'http://127.0.0.1:8000/'. uri_escape($intrans) ;
	$output = `/usr/bin/curl "$local_url" 2> /dev/null`;
	chomp( $output );
	$output =~ s/^"//;
	$output =~ s/"$//;
	$output =~ s/\\"/"/g;

	my @topfive = split( / <SEP> / , $output);
	my @onlyone = split( / <TAB> / , $topfive[0]);
	my $ot_score = $onlyone[0];
	my $ot_trans = $onlyone[1];
	$output = $ot_trans ;

	##  fall back if FastAPI not running
	if ( ! defined $output || $output eq "" ) {
	    $output    = `/bin/echo "$intrans" | $sockeye --models $tnfmodel --use-cpu 2> /dev/null`;
	}

	##  clean subword splitting
	$output =~ s/\@\@ //g;
	$output =~ s/\@\@$//;
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
	
    } elsif ( $heavied ne "FALSE" ) {

	##  heavy user
	##  put some text in the box
	$ottrans .= '<i>Benturnatu!</i> '."\n";
	# $ottrans .= 'Semu cuntenti ca ti piaci lu nostru <i>Tradutturi Sicilianu.</i> '."\n";
	# $ottrans .= '<br><br>'."\n";
	$ottrans .= 'Si voi traduciri un documentu longu, vulemu aiutarti. Leggi '."\n"; 
	$ottrans .= '<a href="https://www.napizia.com/pages/sicilian/translator-sc.shtml#wholedoc">sta risposta</a> '."\n"; 
	# $ottrans .= 'e manna na posta elettronica a: '."\n"; 
	$ottrans .= 'e manna un missaggiu a: '."\n"; 
	$ottrans .= '<a href="mailto:eryk%20%5Bat%5D%20napizia%20%5Bdot%5D%20com">eryk@napizia.com</a>.'."\n"; 
	$ottrans .= '<br><br>'."\n";
	$ottrans .= '<i>Welcome back!</i> '."\n"; 
	# $ottrans .= "We're ". 'glad you like our <i>Sicilian Translator.</i> '."\n";
	# $ottrans .= '<br><br>'."\n";
	$ottrans .= 'If you want to translate a long document, we want to help you.  Read '."\n"; 
	$ottrans .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml#wholedoc">this reply</a> '."\n"; 
	$ottrans .= 'and send an email to: '."\n"; 
	$ottrans .= '<a href="mailto:eryk%20%5Bat%5D%20napizia%20%5Bdot%5D%20com">eryk@napizia.com</a>.'."\n"; 

	##  prevent it from contracting by setting $spoken_form to $ottrans
	##  prevent it from translating by setting switch to False
	$spoken_form = $ottrans;
	$lgparm = "ensc";
	$switch = "FALSE";
	
    } else {
	
	##  normal user
	##  put some text in the box
	#$ottrans .= 'Traduci frasi di cultura, littiratura e storia '."\n";
	$ottrans .= 'Traduci tra Nglisi, Talianu e Sicilianu '."\n";
	$ottrans .= 'cû nostru <i>Tradutturi Sicilianu!</i>'."\n";
	$ottrans .= '<br><br>'."\n";
	#$ottrans .= 'Translate sentences about culture, literature and history '."\n";
	$ottrans .= 'Translate between English, Italian and Sicilian '."\n";
	$ottrans .= 'with our <i>Sicilian Translator!</i>'."\n"; 

	##  prevent it from contracting by setting $spoken_form to $ottrans
	##  prevent it from translating by setting switch to False
	$spoken_form = $ottrans;
	$lgparm = "ensc";
	$switch = "FALSE";
    }
    
    ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
    
    ##  PRINT HTML
    ##  ===== ====

    my $othtml;
    $othtml .= mk_header( $topnav , $landing );
    $othtml .= mk_form( $lgparm , $intext , $italian , $landing );
    $othtml .= mk_ottrans( $ottrans , $lgparm , $switch , $spoken_form, $last_update , $landing );
    $othtml .= mk_footer( $footnv , $landing );

    return $othtml;
}
}
