As turtles e os patches são controlados usando respectivamente os seguintes comandos:
ask turtles [ comandos ]
ask patches [ comandos ].

crt n (o qual é a abreviação de create-turtles n). Este comando cria n turtles todas localizadas na origem.
ask turtles [ hatch n [ comandos ] ]. Cada turtle gera n novas turtles idênticas à progenitora e na mesma posição desta (xcor,ycor) e cada cria executa os comandos.
ask patches [ sprout n [ comandos ] ]. De cada patch "brotam" n turtles localizadas nas coordenadas (inteiras) do patch (pxcor,pyxor) e cada turtle executa os comandos.

Em NetLogo além da posição (xcor,ycor) as tartarugas têm também uma orientação (heading) medida em graus a partir do eixo dos y (cf. figura da direita). A atribuição dos valores a cada uma destas variáveis é feita com os seguintes comandos:
set heading θ, onde θ é um número real entre 0 e 360.
setxy x y, onde (x,y) é um ponto dentro da janela gráfica.
set xcor x, onde x é um número real dentro da janela gráfica.
set ycor y, onde y é um número real dentro da janela gráfica.
Para alterar estas variáveis podemos usar os seguintes comandos:
fd l ou forward l. A turtle avança l na direcção em que está orientada.
lt θ ou left θ. A turtle roda θ graus para a esquerda.
rt θ ou right θ. A turtle roda θ graus para a direita.

patches-own [ altitude popularidade ]. Variáveis intrínsecas a cada patch.
turtles-own [ sexo posicao-anterior ]. Variáveis intrínsecas a cada turtle.
globals [ geracao ]. Variáveis globais.
locals [ auxiliar1 auxiliar2 ]. Variáveis temporárias definidas dentro de rotinas ou funções. (Explicá-las-emos mais tarde).

count turtles. Conta o número de tartarugas.
random n. Fornece um número aleatório inteiro entre 0 e n - 1.
random-float x. Fornece um número aleatório real entre 0 e menor que x.
random-xcor, random-ycor. Fornecem números reais aleatórios para as coordenadas x e y, respectivamente, dentro do mundo (janela gráfica).

turtles with [ sexo = 1 ]. Tartarugas de sexo = 1.
turtles with [ xcor > 0 ]. Tartarugas no lado direito do mundo.
patches with [ pycor > 0 ]. Patches do "hemisfério" norte.
turtles-here. Todas as tartarugas num certo patch que estão a ser "chamadas" por uma tartaruga ou patch dentro de um comando ask conjunto-de-agentes [ comandos ]. 
Por exemplo a regra: 
as tartarugas infectadas (cor vermelha) infectam as outras que estejam no mesmo patch
seria traduzida pelo comando:
ask turtles with [ color = red ][ ask turtles-here [set color red] ].
other-turtles-here. Similar a turtles-here, mas neste caso o conjunto-de-agentes tem de ser um subconjunto das tartarugas e other-turtles-here não contém a tartaruga que as "chamou".

if condicao [ comandos ]. Se a condicao for verdadeira executa os comandos.
Exemplo: if (sexo = 1) [ set color sky ].
ifelse condicao [ comandos1 ][ comandos2 ]. Se a condicao for verdadeira executa comandos1, caso contrário executa comandos2. 
Exemplo: ifelse (sexo = 0) [ set color pink ][ set color sky ].
while [ condicao ][ comandos ]. Enquanto a condicao for verdadeira executa comandos.
Exemplo: ask turtles [ while [ ycor < 0 ][ set ycor (ycor + 1) ] ] (as tartarugas imigram para o hemisfério norte).
O NetLogo permite ainda o uso de operações lógicas para construir estruturas de controlo mais sofisticadas. As três operações mais comuns são o and (e), o or (ou) e o not (não) para combinar várias condições. Exemplos do que condicao pode ser:
condicao1 and condicao2 and condicao3,
condicao1 or condicao2 or condicao3,
not condicao.

Uma vez criadas, todas as novas espécies têm comandos equivalentes aos das turtles, os quais são criados automaticamente pelo NetLogo. Para usá-los basta substituir a palavra turtles, nos comandos onde esta aparece, pelo nome da especie. Exemplos:
create-turtles n
ask turtles [ comandos ]
ask turtles [ hatch n [ comandos ] ]
count turtles
ask turtles with [ condicao ][ comandos ]
turtles-here
other-turtles-here
create-tartarugas n
ask tartarugas [ comandos ]
ask tartarugas [ hatch n [ comandos ] ]
count tartarugas
ask tartarugas with [ condicao ][ comandos ]
tartarugas-here
other-tartarugas-here
Em NetLogo os indivíduos de uma espécie podem mudar de espécie. Por exemplo um peão não tem de permanecer um peão o resto da vida, pode ser promovido a rainha:
ask random-one-of peoes [ set breed rainhas ].


