# Programação Perl


##Introdução
A linguagem Perl foi desenvolvida por Larry Wall em 1987, essa linguagem é multiplataforma usada principalmente em aplicações de CGI para o web.
Perl é uma linguagem que possui muitos recursos para cadeias de caracteres, por isso é uma linguagem que se destaca quando o assunto é tratar de textos.
O Principal proposito da linguagem é a flexibilidade e versatilidade de fazer códigos funcionais.


##Origens e Influências
As origens de Perl se dão principalmente pela utilização de outras duas linguagens, C e Snobol. E é uma linguagem que deu origem principalmente a linguagem Ruby on Rais que está sendo muito utilizada hoje em dia.

## Classificação
Perl é uma linguagem que possui muitas características, como Orientação a Objetos, é uma linguagem interpretada, porém seu principal uso é Aplicações Web e foi nesse ramo que ela fez melhorias.
Essa linguagem tem grandes características de Whriteability com sua sintaxe simplificada porém em Readability já não é tão boa assim. 

## Código Significativo
Como Perl é muito usado em sistemas web, aqui está um exemplo de codigo para ler o nome e sobrenome de uma pessoa e imprimir na página do site:
local ($buffer, @pairs, $pair, $name, $value, %FORM);
// Read in text
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "GET")
{
   $buffer = $ENV{'QUERY_STRING'};
}
// Split information into name/value pairs
@pairs = split(/&/, $buffer);
foreach $pair (@pairs)
{
   ($name, $value) = split(/=/, $pair);
   $value =~ tr/+/ /;
   $value =~ s/%(..)/pack("C", hex($1))/eg;
   $FORM{$name} = $value;
}
$first_name = $FORM{first_name};
$last_name  = $FORM{last_name};

print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>Hello - Second CGI Program</title>";
print "</head>";
print "<body>";
print "<h2>Hello $first_name $last_name - Second CGI Program</h2>";
print "</body>";
print "</html>";

1;

No HTML do Site:
<FORM action="/cgi-bin/hello_post.cgi" method="POST">
First Name: <input type="text" name="first_name">  <br>

Last Name: <input type="text" name="last_name">

<input type="submit" value="Submit">
</FORM>

## Avaliação Comparativa
Comparando Perl com C podemos perceber uma significativa diferença em relação ao desempenho, Perl possui scripts muito mais lentos, a legibilidade de seus códigos é muito complicada também.
Porém Perl é uma linguagem excelente para a manipulação de textos e arquivos, tornando isso muito mais facil do que C.

Por Exempo: 
Para percorrer um veto em C é preciso saber o tamanho do vetor ou usar o comando strlen(), mas se o vetor estiver dinamicamente alocado deverá ser usado ponteiro para poder percorrer o vetor.
Já em Perl é muito mis simples pois o comando foreach permite fazer um for para cada elemento presente no vetor, sem precisar saber quantos elementos existem.

Imprimindo os elementos de um vetor em Pearl:
  @list = (2, 20, 30, 40, 50);
  // foreach loop execution
  foreach $a (@list){
    print "value of a: $a\n";
    }

Imprimindo os elementos de um vetor em C:
  struct reg {
      int         conteudo; 
      struct reg *prox;
   };
  typedef struct reg celula;
  void imprime (celula *le) {
   if (le != NULL) {
      printf ("value of a: %d\n", le->conteudo);
      imprime (le->prox);
   }
}

## Conclusão
Perl é uma linguagem muito versátil, multiplataforma e com muitas facilidades para manipulação de dados, porém em relação a outros aspectos, como desempenho, perde para outras linguagens.
Cada programador deve ver o principal uso de suas aplicações antes de fazer a escolha de que linguagem usar, se suas aplicações manipulam muitos dados, Perl será perfeita para seu uso.

## Bibliografia

* Site da linguagem: https://www.perl.org/
* Wikipedia: https://pt.wikipedia.org/wiki/Perl
* Outro Site: http://search.cpan.org/~garu/POD2-PT_BR-0.06/lib/POD2/PT_BR/perlintro.pod
