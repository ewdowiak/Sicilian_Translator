package Tradutturi::Controller::Api;

##  makes the API page
##  Copyright (C) 2018-2026 Eryk Wdowiak
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
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

use strict;
use warnings;
no warnings qw(uninitialized numeric void);
use utf8;

use URI::Escape;
# use JSON;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Napizia::Translator;
use Napizia::HtmlIndex;
use Napizia::SicilianLS2;
use Napizia::English;
use Napizia::Italian;

my $home = "/home/eryk";

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  WELCOME and HELLO and LANGS and AUDIO
##  ======= === ===== === ===== === =====

sub welcome ($self) {
    
    ##  this works with /cgi-bin/api.pl?request= 
    my $par_request = $self->param('request') || '';
    $par_request = ( $par_request eq '') ? undef : $par_request ;

    ##  make JSON
    my $otjson = mk_jsonpage( $par_request );

    ##  and render it
    # $self->render(json => encode_json($otjson));
    $self->render(htmlpage => $otjson);
}

sub hello ($self) {
    
    ##  this works with /api/v1/:src/:tgt/#txt 
    my $src = $self->param('src') || '';
    my $tgt = $self->param('tgt') || '';
    my $txt = $self->param('txt') || '';
    my $rqst = '/'. $src .'/'. $tgt .'/'. $txt ;
    my $par_request = ( $src eq '' || $tgt eq '' || $txt eq '' ) ? undef : $rqst ;
    
    ##  make JSON
    my $otjson = mk_jsonpage( $par_request );

    ##  and render it
    # $self->render(json => encode_json($otjson));
    $self->render(htmlpage => $otjson);
}

sub getlangs ($self) {
    ##  make JSON
    my $otjson = mk_langs();

    ##  and render it
    # $self->render(json => encode_json($otjson));
    $self->render(htmlpage => $otjson);
}

sub getaudio ($self) {
    ##  make JSON
    my $otjson = mk_audio();

    ##  and render it
    # $self->render(json => encode_json($otjson));
    $self->render(htmlpage => $otjson);
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  CREATE JSON
##  ====== ====

sub mk_jsonpage{ 

    my $request = $_[0];
    $request =~ s/^\///;

##  now prepare what they really want
my $ottxt;

if ($request =~ /^scn?\/scn?\/|^scn?\/en\/|^scn?\/it\/|^en\/scn?\/|^en\/en\/|^en\/it\/|^it\/scn?\/|^it\/en\/|^it\/it\//) {

    ##  get translation direction
    my $lgparm = "";
    $lgparm = ( $request =~ /^scn?\/scn?\// ) ? "scsc" : $lgparm;
    $lgparm = ( $request =~ /^scn?\/en\//   ) ? "scen" : $lgparm;
    $lgparm = ( $request =~ /^scn?\/it\//   ) ? "scit" : $lgparm;
    $lgparm = ( $request =~ /^en\/scn?\//   ) ? "ensc" : $lgparm;
    $lgparm = ( $request =~ /^en\/en\//     ) ? "enen" : $lgparm;
    $lgparm = ( $request =~ /^en\/it\//     ) ? "enit" : $lgparm;
    $lgparm = ( $request =~ /^it\/scn?\//   ) ? "itsc" : $lgparm;
    $lgparm = ( $request =~ /^it\/en\//     ) ? "iten" : $lgparm;
    $lgparm = ( $request =~ /^it\/it\//     ) ? "itit" : $lgparm;
    
    ##  check blocked IP list
    ## my $ip_addr = remote_addr();
    my $ip_addr = $ENV{REMOTE_ADDR};

    my $block = $home ."/website/logs/translate/lists/block.list";
    my $blbkp = $home ."/website/logs/translate/lists/block.list.bkp";
    
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
    
    ##  block, return same or translate?
    
    if ( $blocked ne "FALSE" ) {

	##  if on blocked IP list return block page
	
	my $scn = "Scusami! Lu tò IP ha statu bluccatu picchì sta facennu troppi richiesti.";
	my $ita = "Scusami! Il tuo IP è stato bloccato perchè sta facendo troppe richieste.";
	my $eng = "I'm sorry! Your IP has been blocked because it is making too many requests.";

	if ( $lgparm eq "scsc" || $lgparm eq "ensc" || $lgparm eq "itsc" ) {
	    $ottxt .= mk_trans($scn);
	} elsif ( $lgparm eq "scit" || $lgparm eq "enit" || $lgparm eq "itit" ) {
	    $ottxt .= mk_trans($ita);
	} else {
	    $ottxt .= mk_trans($eng);
	}

    } elsif ( $lgparm ne "ensc" && $lgparm ne "itsc" && 
	      $lgparm ne "enit" && $lgparm ne "scit" &&
	      $lgparm ne "scen" && $lgparm ne "iten" ) {

	##  same language, so return same
	
	my $intext = $request;
	$intext =~ s/^scn?\/scn?\/|^scn?\/en\/|^scn?\/it\/|^en\/scn?\/|^en\/en\/|^en\/it\/|^it\/scn?\/|^it\/en\/|^it\/it\///;
	$intext = rm_malice( $intext );
	$intext = ( $intext !~ /[0-9A-Za-zÀàÂâÁáÇçÈèÊêÉéÌìÎîÍíÏïÒòÔôÓóÙùÛûÚú]/ ) ? "" : $intext;
	$intext =~ s/\n/ /g;
	$intext =~ s/\s+/ /g;
	$intext =~ s/^ //g;
	$intext =~ s/ $//g;

	$ottxt .= mk_trans($intext);

    } else {

	##  not blocked or same, so translate

	my $intext = $request;
	$intext =~ s/^scn?\/scn?\/|^scn?\/en\/|^scn?\/it\/|^en\/scn?\/|^en\/en\/|^en\/it\/|^it\/scn?\/|^it\/en\/|^it\/it\///;
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
	
	my $subwords = $home .'/website/translate/lib/model/'. $sbwhash{$lgparm};
	my $tnfmodel = $home .'/website/translate/lib/model/'. $tnfhash{$lgparm};
	my $dirtoken = $dirhash{$lgparm};
    
	##  initialize holder
	my $ottrans = "";
	
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
	    $output    = `/usr/bin/curl "$local_url" 2> /dev/null`;
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
		$ottrans = mk_spoken($ottrans);
	    } elsif ( $lgparm ne "scen" && $lgparm ne "iten" ) {
		##  cases:  Sc->It and En->It
		$ottrans = it_detokenizer($output);
	    } else {
		##  cases:  Sc->En and It->En
		$ottrans = en_detokenizer($output);
	    }
	    
	    $ottxt .= mk_trans($ottrans);
	    
	} else {
	    $ottxt .= mk_trans($intext);
	}
    }
    
} elsif ($request =~ /^languages/) {
    $ottxt .= mk_langs();
} elsif ($request =~ /^audio/) {
    $ottxt .= mk_audio();    
} else {
    $ottxt .= mk_error();
}
return $ottxt ;
}


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES without use JSON
##  =========== ======= === ====

sub mk_trans {
    my $trans = $_[0];
    $trans =~ s/"/\\"/g;
    my $txt ;
    # $txt .= 'Content-type: application/json'."\n\n";
    $txt .= '{"translation":';
    $txt .= '"'. $trans .'",';
    $txt .= '"info":{"pronunciation":{},"definitions":[],"examples":[],"similar":[],"extraTranslations":[]}}';
    return $txt;
}

sub mk_langs {
    my $txt ;
    # $txt .= 'Content-type: application/json'."\n\n";
    $txt .= '{"languages":[';
    $txt .= '{"code":"en","name":"English"},';
    ##  repeat because no auto-detect
    $txt .= '{"code":"en","name":"English"},';
    $txt .= '{"code":"it","name":"Italian"},';
    # $txt .= '{"code":"sc","name":"Sicilian"}';
    $txt .= '{"code":"scn","name":"Sicilian"}';
    $txt .= ']}';
    return $txt;
}

sub mk_audio {
    my $txt ;
    # $txt .= 'Content-type: application/json'."\n\n";
    $txt .= '{';
    $txt .= '"audio":[]';
    $txt .= '}';
    return $txt;
}

sub mk_error {
    my $txt ;
    # $txt .= 'Content-type: application/json'."\n\n";
    $txt .= '{';
    $txt .= '"error": "There was an error."';
    $txt .= '}';
    return $txt;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  SUBROUTINES with use JSON
##  =========== ==== === ====

# sub mk_trans {
#     my $trans = $_[0];
#     my @empty_array = ();
#     my %empty_hash = ();
#     my %oth;
#     $oth{"translation"} = $trans;
#     $oth{"info"}{"pronunciation"} = \%empty_hash;
#     $oth{"info"}{"definitions"} = \@empty_array;
#     $oth{"info"}{"examples"} = \@empty_array;
#     $oth{"info"}{"similar"} = \@empty_array;
#     $oth{"info"}{"extraTranslations"} = \@empty_array;
#     return \%oth ;
# }

# sub mk_langs {
#     my %oten;
#     $oten{"code"} = "en";
#     $oten{"name"} = "English";
#     my %otit;
#     $otit{"code"} = "it";
#     $otit{"name"} = "Italian";
#     my %otsc;
#     $otsc{"code"} = "scn";
#     $otsc{"name"} = "Sicilian";
#     my @otlangs = ( \%oten , \%oten , \%otsc , \%otit );
#     my %oth;
#     $oth{"languages"} = \@otlangs;
#     return \%oth ;
# }

# sub mk_audio {
#     my @empty_array = ();
#     my %oth;
#     $oth{"audio"} = \@empty_array;
#     return \%oth ;
# }

# sub mk_error {
#     my %oth;
#     $oth{"error"} = "There was an error.";
#     return \%oth ;
# }

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
# ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ## #
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
