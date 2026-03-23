package Napizia::HtmlDarreri;

##  Copyright 2019-2026 Eryk Wdowiak
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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ("mk_form","mk_ottrans","mk_otmenu");

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  make form
sub mk_form {

    ##  embedding and search
    my $lgparm     = $_[0]; 
    my $intext     = $_[1];
    (my $tokenized = $_[2]) =~ s/\\"/"/g;
    (my $subsplit  = $_[3]) =~ s/\\"/"/g;

    my $empty      = $_[4] ;
    $empty = ( ! defined $empty || $empty ne "EMPTY" ) ? "FALSE" : "EMPTY";
    
    my $ottxt ;
    ##  this "LONG ROW DIV" closes in either: &mk_ottrans() or &mk_otmenu()
    $ottxt .= '<!-- begin LONG ROW div -->' . "\n";
    $ottxt .= '<div class="row">' ."\n";

    $ottxt .= '<!-- begin box div -->' . "\n";
    $ottxt .= '<div class="col-m-12 col-5 intrans">' ."\n";
    
    $ottxt .= '<form enctype="multipart/form-data" action="/cgi-bin/darreri.pl" method="post">'."\n";
    $ottxt .= '<table style="width: 100%; padding: 0px 3px 0px 0px;"><tbody>'."\n";

    $ottxt .= '<tr>' ;
    $ottxt .= '<td colspan="2">'."\n";
    $ottxt .= '<div class="txtacont">'."\n";
    
    $ottxt .= '<textarea name="intext" rows="6" maxlength="500" class="intrans" id="intxtbox" autofocus>';
    $ottxt .= $intext ;
    $ottxt .= '</textarea>'."\n";

    $ottxt .= '<input class="clrbtn" type="button" value="x" onclick="javascript:eraseText();">'."\n";
    ##  ##  do NOT hide on small screen
    ##  $ottxt .= '<div class="buttonsud">'."\n";
    $ottxt .= '<input class="accent" type="button" value="à" onclick="javascript:accent_a();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="è" onclick="javascript:accent_e();">'."\n";
    $ottxt .= '<input class="accext" type="button" value="ì" onclick="javascript:accent_i();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ò" onclick="javascript:accent_o();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ù" onclick="javascript:accent_u();">'."\n";
    $ottxt .= "\n";
    $ottxt .= '&nbsp;&nbsp;'."\n";
    $ottxt .= "\n";
    $ottxt .= '<input class="accent" type="button" value="â" onclick="javascript:circum_a();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ê" onclick="javascript:circum_e();">'."\n";
    $ottxt .= '<input class="accext" type="button" value="î" onclick="javascript:circum_i();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="ô" onclick="javascript:circum_o();">'."\n";
    $ottxt .= '<input class="accent" type="button" value="û" onclick="javascript:circum_u();">'."\n";
    ##  $ottxt .= '</div>'."\n";
    $ottxt .= '</div>'."\n";

    $ottxt .= '</td></tr>'."\n";    
    $ottxt .= '<tr>'."\n"; 
    $ottxt .= '<td>'."\n"; 

    $ottxt .= '<select name="langs">'."\n";

    if ( $lgparm ne "ensc" && $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  the default case where lgparm is "scen"
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";

    } elsif ( $lgparm ne "iten" && $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to sicilian
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";

    } elsif ( $lgparm ne "enit" && $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  italian to english
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";

    } elsif ( $lgparm ne "itsc" && $lgparm ne "scit" ) {

	##  english to italian
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";

    } elsif ( $lgparm ne "itsc" ) {

	##  sicilian to italian
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";	

    } else {
	##  italian to sicilian
	$ottxt .= '<option value="itsc">Talianu-Sicilianu</option>'."\n";
	$ottxt .= '<option value="iten">Talianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="scit">Sicilianu-Talianu</option>'."\n";
	$ottxt .= '<option value="scen">Sicilianu-Nglisi</option>'."\n";
	$ottxt .= '<option value="enit">Nglisi-Talianu</option>'."\n";
	$ottxt .= '<option value="ensc">Nglisi-Sicilianu</option>'."\n";
    }    
    $ottxt .= '</select>'."\n";

    $ottxt .= '</td>'."\n";
    $ottxt .= '<td align="right">'.'<input type="submit" value="Traduci">'."\n";
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
    my $ottrans     = $_[0];
    my $orgl        = $_[1];
    my $last_update = $_[2];

    ##  new and original language parameters
    # my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" ) ) ? "scen" : $orgl;
    # my %newhash = ( "scen" => "ensc", "ensc" => "scen", "iten" => "enit", "enit" => "iten");
    # my $new_lgparm = $newhash{$org_lgparm};
    
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
    $ottxt .= '<!-- end LONG ROW div -->' ."\n";
    ##  this "LONG ROW DIV" began in  &mk_form()
    
    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

sub mk_otmenu {

    ##  output scores
    my @scores = @{ $_[0] };
    
    ##  output translations
    my @ottrans = @{ $_[1] };

    ##  original language direction
    my $orgl = $_[2];

    ##  new and original language parameters
    my $org_lgparm = ( ! defined $orgl || ( $orgl ne "ensc" && $orgl ne "iten" && $orgl ne "enit" &&
					    $orgl ne "itsc" && $orgl ne "scit" ) ) ? "scen" : $orgl;
    my %newhash = ( "scen" => "ensc", "ensc" => "scen",
		    "iten" => "enit", "enit" => "iten",
		    "itsc" => "scit", "scit" => "itsc");
    my $new_lgparm = $newhash{$org_lgparm};

    ##  last update
    my $last_update = $_[3];
    
    ##  and the number to return
    my $nbest   = $_[4];
    $nbest = ( ! defined $nbest || $nbest !~ /^\d$/ ) ? "5" : $nbest ;
    
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
    $ottxt .= '<!-- end LONG ROW div -->' ."\n";
    ##  this "LONG ROW DIV" began in  &mk_form()

    return $ottxt ;
}

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

1;
