package Napizia::HtmlIndex;

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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(mk_header mk_footer mk_form mk_ottrans);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make HTML header
sub mk_header {

    ##  top navigation panel
    my $topnav = $_[0] ;

    ##  landing page
    my $landing   = $_[1];
    $landing = ( ! defined $landing ) ? "index.pl" : $landing;

    ##  landing hash
    my %lh = (
	"index.pl" => {
	    name => "Tradutturi Sicilianu",
	    langs => "Sicilian, English, Italian",
	    descrip => "Traduci tra Ngrisi, Talianu e Sicilianu. Translate between English, Italian and Sicilian.",
	},
	"miricanu.pl" => {
	    name => "Tradutturi Miricanu",
	    langs => "Sicilian, English, Italian",
	    descrip => "Traduci tra Ngrisi, Talianu e Sicilianu. Translate between English, Italian and Sicilian.",
	},
	);

    ##  prepare output HTML
    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' ."\n";
    $ottxt .= '<html>' ."\n";
    $ottxt .= '  <head>' ."\n";
    $ottxt .= '    <title>'. $lh{$landing}{name} .' :: Napizia</title>' ."\n";
    $ottxt .= '    <meta name="DESCRIPTION" content="'. $lh{$landing}{descrip} .'">' ."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translate, translations, translation, translator, '."\n";
    $ottxt .= '          machine translation, online translation, '. $lh{$landing}{langs} .'">' ."\n";
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' ."\n";
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_translator.css">' ."\n";
    $ottxt .= '    <link rel="icon" type="image/png" href="/config/napizia-icon.png">' ."\n";
    $ottxt .= "\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="SC-EN Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_sc-en.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="SC-IT Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_sc-it.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="EN-SC Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_en-sc.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="IT-SC Dieli Dict"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/dieli_it-sc.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Trova na Palora"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/trova-palora.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Cosine Sim Skipgram"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/cosine-sim_skip.xml">'."\n";
    ##  $ottxt .= '    <link rel="search" type="application/opensearchdescription+xml"'."\n";
    ##  $ottxt .= '          title="Cosine Sim CBOW"'."\n";
    ##  $ottxt .= '          href="https://www.napizia.com/pages/sicilian/search/cosine-sim_cbow.xml">'."\n";
    ##  $ottxt .= "\n";
    $ottxt .= '    <meta name="viewport" content="width=device-width, initial-scale=1">' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    $ottxt .= '      <h1>'. $lh{$landing}{name} .'</h1>'."\n";
    $ottxt .= '    </div>' . "\n" ;
    $ottxt .= '  </div>' . "\n" ;
    $ottxt .= '  <!-- end row div -->' . "\n" ;
    $ottxt .= '  ' . "\n" ;
    
    return $ottxt ;
}

##  make footer
sub mk_footer {

    ##  footer navigation
    my $footnv = $_[0] ; 

    ##  landing page
    my $landing  = $_[1];
    $landing = ( ! defined $landing ) ? "index.pl" : $landing;

    ##  landing hash
    my %lh = (
	"index.pl" => {
	    name => "Tradutturi Sicilianu",
	    behind => "darreri.pl",
	    other => "miricanu.pl",
	    otname => "Tradutturi Miricanu",
	    opus => "yes",
	},
	"miricanu.pl" => {
	    name => "Tradutturi Miricanu",
	    behind => "darreri-usa.pl",
	    other => "index.pl",
	    otname => "Tradutturi Sicilianu",
	    opus => "yes",
	},
	);
    
    ##  prepare output
    my $othtml ;
    
    ##  open instruction div
    $othtml .= '<div class="row" style="margin: 5px 0px 5px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 bnotes1" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    $othtml .= 'Si&nbsp;preja di leggiri la '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentazioni</a>';
    $othtml .= ', '."\n".'taliari lu <a href="https://youtu.be/w5_InALARi0" target="_blank">videu</a>';
    $othtml .= ' '."\n".'o veniri <a href="/cgi-bin/'. $lh{$landing}{behind} .'"><i>Darreri lu Sipariu</i></a>.</p>'."\n";
    $othtml .= '  </div>'."\n";

    $othtml .= '<div class="col-m-12 bnotes2" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">'; ## ."\n";
    $othtml .= 'Please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a>';
    $othtml .= ', '."\n".'watch the <a href="https://youtu.be/w5_InALARi0" target="_blank">video</a>';
    $othtml .= ' '."\n".'or come <a href="/cgi-bin/'. $lh{$landing}{behind} .'"><i>Behind the Curtain</i></a>.</p>'."\n";
    #$othtml .= 'O, si prifirisci, prova lu nostru '."\n";
    #$othtml .= '<a href="/cgi-bin/'. $lh{$landing}{other} .'"><i>'. $lh{$landing}{otname} .'</i></a>.</p>'."\n";
    $othtml .= '</div>'."\n";
    
    $othtml .= '<div class="col-m-12 bnotes3" style="padding: 0px 5px;">'."\n";
    $othtml .= '<p class="bnotes">Grazzi a '."\n";
    $othtml .= '<a href="http://www.arbasicula.org/" target="_blank">Arba Sicula</a>,'."\n";
    $othtml .= '<a href="https://en.wikipedia.org/wiki/Gaetano_Cipolla" target="_blank">Gaetano Cipolla</a>'."\n";
    $othtml .= ' and <a href="http://www.dieli.net" target="_blank">Arthur Dieli</a>.';
    # if ( ! defined $lh{$landing}{opus} ) {
    # 	$othtml .= ' e&nbsp;<a href="https://awslabs.github.io/sockeye/" target="_blank">Sockeye</a>.';
    # } else {
    # 	$othtml .= ', <a href="https://awslabs.github.io/sockeye/" target="_blank">Sockeye</a>'."\n";
    # 	$othtml .= ' e&nbsp;<a href="https://opus.nlpl.eu/" target="_blank">OPUS</a>.';
    # }
    $othtml .= '</p>'."\n";
    #$othtml .= '</div>'."\n";
    $othtml .= '</div>'."\n";

    ##  close instruction div
    $othtml .= '</div>'."\n";

    open( FOOTNAV , $footnv ) || die "could not read:  $footnv";
    while(<FOOTNAV>){ chomp;  $othtml .= $_ ."\n"; };
    close FOOTNAV ;
    
    return $othtml ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make form
sub mk_form {

    ##  embedding and search
    my $lgparm  = $_[0]; 
    my $intext = $_[1];
    
    my $italian  = $_[2];
    $italian = ( ! defined $italian ) ? "FALSE" : $italian;

    my $landing  = $_[3];
    $landing = ( ! defined $landing ) ? "index.pl" : $landing;

    my $ottxt ;
    $ottxt .= '<!-- begin row div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";
    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/'. $landing .'" method="post">'."\n";
    $ottxt .= '<table style="width: 100%; padding: 0px 3px 0px 0px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">' ;
    $ottxt .= '<textarea name="intext" maxlength="500" class="intrans">'."\n";
    $ottxt .= $intext ;
    $ottxt .= '</textarea>'."\n";
    $ottxt .= '</td></tr>'."\n";
    $ottxt .= '<tr>'."\n"; 
    $ottxt .= '<td>'."\n"; 

    $ottxt .= '<select name="langs">'."\n";

    if ( $lgparm ne "ensc" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  the default case where lgparm is "scen"
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	}
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";
	    $ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	    $ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	}

    } elsif ( $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to sicilian
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";
	}
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";
	if ( $italian eq "enable" ) {
	    $ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	    $ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	    $ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	}

    } elsif ( $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  italian to english
	$ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";

    } elsif ( $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to italian
	$ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";

    } elsif ( $lgparm ne "itsc" ) {

	##  sicilian to italian
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";	

    } else {
	##  italian to sicilian
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi</option>'."\n";
	$ottxt .= '<option value="enit">Ngrisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu</option>'."\n";
    }    
    $ottxt .= '</select>'."\n";

    $ottxt .= '</td>'."\n";
    $ottxt .= '<td align="right">'.'<input type="submit" value="Traduci">'."\n";
    ## $ottxt .= '<input type=reset value="Clear Form">'."\n"; 
    $ottxt .= '</td>'."\n";
    $ottxt .= '</tr>'."\n";
    $ottxt .= '</tbody></table>'."\n";
    $ottxt .= '</form>'."\n";
        
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end box div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_ottrans {

    ##  output translation and language direction
    my $ottrans = $_[0];
    my $orgl    = $_[1];

    ##  new and original language parameters
    my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" &&
					    $orgl ne "itsc" && $orgl ne "scit" ) ) ? "scen" : $orgl;
    my %newhash = ( "scen" => "ensc", "ensc" => "scen",
		    "iten" => "enit", "enit" => "iten",
		    "itsc" => "scit", "scit" => "itsc");
    my $new_lgparm = $newhash{$org_lgparm};

    ##  switch, spoken form, last update and landing
    my $switch  = $_[2];
    $switch = ( ! defined $switch || $switch ne "FALSE" ) ? "TRUE" : "FALSE";
    
    my $spoken_form = $_[3];
    my $last_update = $_[4];
    my $landing     = $_[5];
    $landing = ( ! defined $landing ) ? "index.pl" : $landing;
    
    ##  prepare quotes for form value
    ( my $ottrans_form = $ottrans ) =~ s/"/\&quot;/g;

    ##  set form to empty if False
    $ottrans_form = ( $switch eq "FALSE" ) ? "" : $ottrans_form ;
    
    ##  initialize output
    my $ottxt ;
    
    ##  switch direction
    $ottxt .= '<!-- begin switch -->'."\n";
    $ottxt .= '<div class="col-m-12 col-1 switch">'."\n";
    $ottxt .= '  <form enctype="multipart/form-data" action="/cgi-bin/'. $landing .'" method="post">'."\n";
    $ottxt .= '    <table><tbody><tr><td>'."\n";
    $ottxt .= '	    <input type="submit" value="&harr;" class="switchlr">'."\n";
    $ottxt .= '	    <input type="submit" value="&#8597;" class="switchud">'."\n";
    $ottxt .= '    </td></tr></tbody></table>'."\n";
    $ottxt .= '    <input type="hidden" name="langs" value="'. $new_lgparm .'">'."\n";
    $ottxt .= '    <input type="hidden" name="intext" value="'. $ottrans_form .'">'."\n";
    $ottxt .= '  </form>'."\n";
    $ottxt .= '</div>'."\n";
    $ottxt .= '<!-- end switch -->'."\n";

    ##  if En->Sc or It->Sc, prepare spoken voice
    my $spoken = ( $new_lgparm eq "ensc" || $new_lgparm eq "itsc" ||
		   $new_lgparm eq "enit" || $new_lgparm eq "iten" ) ? $ottrans : $spoken_form;
    
    ##  output translation
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-6">'."\n";
    $ottxt .= '<div class="ottrans">'."\n";
    
    ##  if Sicilian to English, just output translation
    ##  if English to Sicilian AND difference between literary and spoken voices, then offer switch
    if ( $ottrans eq $spoken ) {
	$ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    } else {
	$ottxt .= '<input type=radio id="spoken" name="voice">'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice" checked>'."\n";
	$ottxt .= "\n";
	$ottxt .= '<span id="spkvoice">' . $spoken . '</span>'."\n";
	$ottxt .= '<span id="litvoice">' . $ottrans . '</span>'."\n";
	$ottxt .= "\n";
	$ottxt .= '<label for="spoken" id="showspk">'."\n";
	$ottxt .= '  <span>Mostra la forma parrata.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="spoken" name="voice">'."\n";
	$ottxt .= '<label for="literary" id="showlit">'."\n";
	$ottxt .= '  <span>Mostra la forma litteraria.</span>'."\n";
	$ottxt .= '</label>'."\n";
	$ottxt .= '<input type=radio id="literary" name="voice">'."\n";
    }
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
