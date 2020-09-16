package Napizia::HtmlDarreri;

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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(mk_header mk_footer mk_form mk_ottrans mk_otmenu);

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make HTML header
sub mk_header {

    ##  top navigation panel
    my $topnav = $_[0] ;

    ##  prepare output HTML
    my $ottxt ;
    $ottxt .= "Content-type: text/html\n\n";
    $ottxt .= '<!DOCTYPE html>' . "\n" ;
    $ottxt .= '<html>' . "\n" ;
    $ottxt .= '  <head>' . "\n" ;
    $ottxt .= '    <title>Darreri lu Sipariu :: Tradutturi Sicilianu :: Napizia</title>' ."\n";
    $ottxt .= '    <meta name="DESCRIPTION" content="Behind the curtain of '."\n";
    $ottxt .= '          Napizia'."'".'s Sicilian Translator.">' ."\n";
    $ottxt .= '    <meta name="KEYWORDS" content="translate, translations, translation, translator, '."\n";
    $ottxt .= '          machine translation, online translation, Sicilian, English">' ."\n";
    $ottxt .= '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' . "\n" ;
    $ottxt .= '    <meta name="Author" content="Eryk Wdowiak">' . "\n" ;
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_theme-blue.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/eryk_widenme.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/dieli_forms.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_translator.css">' ."\n";
    $ottxt .= '    <link rel="stylesheet" type="text/css" href="/css/napizia_darreri.css">' ."\n";
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
    $ottxt .= '    <style>' . "\n" ;
    $ottxt .= '      p.lastupdate {'."\n";
    $ottxt .= '        font-size: 0.75em;'."\n";
    $ottxt .= '        text-align: right;'."\n";
    $ottxt .= '        margin: 0px 10px 0px 0px;'."\n";
    $ottxt .= '      }'."\n";
    $ottxt .= '      @media only screen and (max-width: 599px) {'."\n";
    $ottxt .= '        p.lastupdate {'."\n";
    $ottxt .= '          margin: 0px 5px 0px 0px;'."\n";
    $ottxt .= '        }'."\n";
    $ottxt .= '      }'."\n";
    $ottxt .= '    </style>' . "\n" ;
    $ottxt .= '  </head>' . "\n" ;

    open( TOPNAV , $topnav ) || die "could not read:  $topnav";
    while(<TOPNAV>){ chomp;  $ottxt .= $_ . "\n" ; };
    close TOPNAV ;

    $ottxt .= '  <!-- begin row div -->' . "\n" ;
    $ottxt .= '  <div class="row">' . "\n" ;
    $ottxt .= '    <div class="col-m-12 col-12">' . "\n" ;
    ##  $ottxt .= '      <h1>Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h1 style="margin-bottom: 0.15em;">Darreri lu Sipariu</h1>'."\n";
    $ottxt .= '      <h2 style="margin-top: 0.15em;">dû Tradutturi Sicilianu</h2>'."\n";
    ##  $ottxt .= '      <h2 style="margin-top: 0.15em; font-family: Arial, '."'Liberation Sans'".',';
    ##  $ottxt .= ' sans-serif;">Behind the Curtain</h2>'."\n";
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

    ##  prepare output
    my $othtml ;
    
    ##  open instruction div
    $othtml .= '<div class="row" style="margin: 15px 0px 5px 0px; border: 1px solid black; background-color: rgb(255,255,204);">'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'Back here, "behind the curtain," you can see how the ';
    $othtml .= '<a href="/cgi-bin/index.pl"><i>Sicilian Translator</i></a> works.</p>'."\n";

    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.25em; padding-left: 0px;">'."\n";
    $othtml .= 'First, it tokenizes the input sentence to a reduced form. '."\n";
    $othtml .= 'Then subword splitting breaks the words into shorter units, '."\n";
    $othtml .= 'which are then passed to the translator.</p>'."\n";
    $othtml .= '</div>'."\n";

    $othtml .= '<div class="col-m-12 col-6" style="padding: 0px 10px;">'."\n";
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'The translator returns the Top&nbsp;5 translations of the input sentence, '."\n";
    $othtml .= 'which this page displays in detokenized form along with the translation score. '."\n";
    $othtml .= 'Like golf, a lower score is a better score.</p>'."\n";
    
    $othtml .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em; padding-left: 0px;">'."\n";
    $othtml .= 'For more information, please read the '."\n";
    $othtml .= '<a href="https://www.napizia.com/pages/sicilian/translator.shtml">documentation</a>.</p>'."\n";
    
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
    my $lgparm     = $_[0]; 
    my $intext     = $_[1];
    (my $tokenized = $_[2]) =~ s/\\"/"/g;
    (my $subsplit  = $_[3]) =~ s/\\"/"/g;
    my $empty = $_[4] ;
    $empty = ( ! defined $empty || $empty ne "EMPTY" ) ? "FALSE" : "EMPTY";
    
    my $ottxt ;
    $ottxt .= '<!-- begin row div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";
    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";

    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/darreri.pl" method="post">'."\n";
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
    if ( $lgparm ne "scen" ) {
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu' ."\n";
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi' ."\n";
    } else {
	$ottxt .= '<option value="scen">Sicilianu-Ngrisi' ."\n";
	$ottxt .= '<option value="ensc">Ngrisi-Sicilianu' ."\n";
    }
    $ottxt .= '</select>'."\n";
    $ottxt .= '</td>'."\n";
    $ottxt .= '<td align="right">' . '<input type="submit" value="Traduci">'."\n";
    ## $ottxt .= '<input type=reset value="Clear Form">'."\n"; 
    $ottxt .= '</td>'."\n";
    $ottxt .= '</tr>'."\n";
    $ottxt .= '</tbody></table>'."\n";
    $ottxt .= '</form>'."\n";

    if ( $intext =~ /[a-z0-9]/ && $empty eq "FALSE" ) {
	$ottxt .= '<p style="margin: 0.25em 0px 0em 5px;"><i>tokenization:</i></p>'."\n";
	$ottxt .= '<p style="margin: 0em 0px 0.5em 20px;"><span class="code">';
	$ottxt .= $tokenized . '</span></p>'."\n";
	$ottxt .= '<p style="margin: 0.5em 0px 0em 5px;"><i>subwords:</i></p>'."\n";
	$ottxt .= '<p style="margin: 0em 0px 0.25em 20px;"><span class="code">'."\n";
	$ottxt .= $subsplit . '</span></p>'."\n";
    }
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end box div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_ottrans {

    ##  output translation and language direction
    my $ottrans = $_[0];
    my $org_lgparm = $_[1];
    my $new_lgparm = ( $org_lgparm eq "scen" ) ? "ensc" : "scen";
    
    ##  last update
    my $last_update = $_[2];

    ##  initialize output
    my $ottxt ;
        
    ##  output translation
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-7">'."\n";
    $ottxt .= '<div class="ottrans">'."\n";
    
    $ottxt .= '<p style="margin-top: 0.5em; margin-bottom: 0.5em;">' . $ottrans . '</p>'."\n";
    
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_otmenu {

    ##  output scores
    my @scores = @{ $_[0] };
    
    ##  output translations
    my @ottrans = @{ $_[1] };

    ##  language direction
    my $org_lgparm = $_[2];
    my $new_lgparm = ( $org_lgparm eq "scen" ) ? "ensc" : "scen";

    ##  last update
    my $last_update = $_[3];
    
    ##  and the number to return
    my $nbest = $_[4];

    ##  initialize output
    my $ottxt ;
    
    ##  output translation menu
    $ottxt .= '<!-- begin ottrans div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-7 darreri">'."\n";
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/darreri.pl" method="post">'."\n";
    $ottxt .= '<input type="hidden" name="langs" value="'. $new_lgparm .'">'."\n";
    $ottxt .= '<table class="darreri">'."\n";

    ##  create each row
    for my $i (0..$nbest-1) {
	my $score  = $scores[$i];
	my $ottran = $ottrans[$i];
	
	##  prepare quotes for form value
	( my $ottran_form = $ottran ) =~ s/"/\&quot;/g;

	$ottxt .= '  <tr>'."\n";
	$ottxt .= '  <td class="darreri">'."\n";
	$ottxt .= '  <label class="container">'."\n";
	$ottxt .= '    <input type="radio" name="intext" value="'. $ottran_form .'">'."\n";
	$ottxt .= '    <span class="checkmark"></span>'."\n";
	$ottxt .= '  </label>'."\n";
	$ottxt .= '  </td>'."\n";
	$ottxt .= '  <td class="score">'. $score .'</td>'."\n";
	$ottxt .= '  <td class="darreri">'."\n";
	$ottxt .= '    ' . $ottran ."\n";
	$ottxt .= '  </td>'."\n";
	$ottxt .= '  </tr>'."\n";
    }
    
    ##  close it up
    $ottxt .= '</table>'."\n";
    $ottxt .= '<input type="submit" value="Traduci">'."\n";    
    $ottxt .= '</form>' . "\n" ;
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end ottrans div -->' ."\n";
    $ottxt .= '<p class="lastupdate">'. $last_update .'</p>'."\n";
    $ottxt .= '</div>' . "\n" ;
    $ottxt .= '<!-- end row div -->' ."\n";

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
