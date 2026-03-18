package Tradutturi;
use Mojo::Base 'Mojolicious', -signatures;

##  This method will run once at server start
sub startup ($self) {

  ##  Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  ##  Configure the application
  $self->secrets($config->{secrets});
  $self->config(
      hypnotoad => {
  	  listen => [ 'http://127.0.0.1:8081/' ],
  	  proxy  => 1,
      },
      );
  
  ##  Router
  my $r = $self->routes;

  ##  Lingva-compatible GET routes to the API controller
  $r->get('/api/v1/languages')->to('api#getlangs');
  $r->get('/api/v1/audio')->to('api#getaudio');
  $r->get('/api/v1/:src/:tgt/#txt')->to('api#hello');
  
  ##  Normal GET routes to controllers
  $r->get('/')->to('translate#welcome');
  $r->get('/cgi-bin/index.pl')->to('translate#welcome');
  $r->get('/cgi-bin/darreri.pl')->to('darreri#welcome');
  $r->get('/cgi-bin/as-translate.pl')->to('arbasicula#welcome');
  $r->get('/cgi-bin/api.pl')->to('api#welcome');

  ##  Normal POST routes to controllers
  $r->post('/')->to('translate#welcome');
  $r->post('/cgi-bin/index.pl')->to('translate#welcome');
  $r->post('/cgi-bin/darreri.pl')->to('darreri#welcome');
  $r->post('/cgi-bin/as-translate.pl')->to('arbasicula#welcome');
  $r->post('/cgi-bin/api.pl')->to('api#welcome');
}

1;
