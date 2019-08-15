globals[
  x
  y
  aux
]

breed [fabricas fabrica]
breed [circulos circulo]
breed [carros carro]
breed [vacas vaca]
breed [arvores arvore]
breed [drones drone]
breed [poluicao polui]
breed [peixes peixe]
patches-own[ponto]
poluicao-own[pol]

to setup
  clear-all
  ask patches [ set pcolor green + (random-float 0.5) - 0.2] ;;grama
  ask patches with [(pycor > 75 and pycor < 175)] ;;posição da água, y no intervalo (75, 175)
    [ set pcolor blue ] ;;água

  ;;sem ação:
  set-default-shape fabricas "house"
  set-default-shape circulos "wheel"
  set-default-shape carros "truck"
  set-default-shape arvores "tree"
  set-default-shape vacas "cow"

  ;;com ação
  set-default-shape drones "target"
  set-default-shape peixes "fish"
  set-default-shape poluicao "circle"

  create-fabricas 1 [
  set color red
  set size 25
  setxy 40 200
  ]
  create-fabricas 1 [
  set color red
  set size 25
  setxy 200 40
  ]
  create-circulos 1 [
    set color brown
    set size 12
    setxy 50 210  ]
 create-carros 1 [
    set color red
    set size 14
    setxy 60 205  ]
  create-arvores 20 [
    set color lime
    set size 12
    random-arvores 0]
  create-arvores 20 [
    set color lime
    set size 12
    random-arvores 1]
  create-vacas 4 [
    set color white + (random-float 0.5) - 0.2 ;pretas ou brancas de forma aleatória
    set size 12
    set x random-pxcor
    setxy x tenta-y 0
  ]

  create-drones 1 [
    set color yellow
    set size 12
    setxy 40 200
  ]
  create-drones 1 [
    set color yellow
    set size 12
    setxy 200 40
  ]

  ;;drones em cima dos peixes?
  create-peixes Quantidade_peixes [
    set color yellow
    set heading random 360
    set size 6
    set x random-pxcor
    setxy x tenta-y 1
  ]

  let pontos Pontos_poluição
  create-poluicao Pontos_poluição [
  set color black
  set size 2
  set aux random 2
  ifelse aux = 0 [
      setxy random max-pxcor 76
      set pol pontos
   ][
      setxy random max-pxcor 174
      set pol pontos
   ]
    set pontos pontos - 1
  ]

  reset-ticks
end

to random-arvores [ posicao ]
   ifelse posicao = 0 [
     setxy 160 + random 50 - random 10
           200 + random 30 - random 10
   ][
     setxy 20 + random 50 - random 10
           60 - random 30 - random 10
   ]
end

to-report tenta-y [ terra-agua ]
  ifelse terra-agua = 0 [
    loop[
      set y random-pycor
      if ( ( y < 75 ) or ( y > 175 ) ) [ report y ]
    ]
  ][
    loop[
      set y random-pycor
      if ( ( y > 80 ) and ( y < 170 ) ) [ report y ]
    ]
  ]
end

to go
  if not any? poluicao
  [if not any? patches with [ pcolor = black ]
  [ stop ]]  ;;sem poluição o jogo para

;;Movimento dos drones:
  ask drones[
    fd 1]

;;Controle dos drones sobre a poluição
 ask poluicao
  [
    let distancia self
    ask drones with [distance distancia < 75]
    [
      face distancia
    ]
  ]
  ask patches with [pcolor = black]
  [
    let distancia self
    ask drones with [distance distancia < 75]
    [
      face distancia
    ]
  ]

;;Movimento peixes:
  ask peixes [
    caminho-peixe
    fd 0.5
    if [ pcolor ] of patch-at 0 0 = black [ die ]
  ]

;;Reprodução dos peixes
  ask peixes
  [
    if count patches with [pcolor = black] < 25000 * Max_poluição_para_reprodução / 100  [ reproduz ]
  ]

;;Reproduzindo poluição:
  ask poluicao [
    let pontoA pol
    let vizinhos neighbors with [pcolor = blue]
    if vizinhos != no-patches [
      ask one-of vizinhos
      [ if random 100.0 < Taxa_poluição [ ;;controle para proliferação de poluição
        set pcolor black
        set ponto pontoA
  ]]]]
  ask patches with [pcolor = black]
  [ let pontoA ponto
    let vizinhos neighbors with [pcolor = blue]
    if vizinhos != no-patches [ask one-of vizinhos
      [ if random 100.0 < Taxa_poluição [
        set pcolor black
  set ponto pontoA
  ]]]]

;;Drones acabando com poluição
 ask drones [
    if  pcolor = black or poluicao != 0 [ morre ]
 ]

  tick
end

to caminho-peixe
      if not ([ pcolor ] of patch-ahead 1 = blue ) and not ([ pcolor ] of patch-ahead 1 = black ) [
        set heading heading + 45
      ]
end

to reproduz
  if random-float 1500.0 < Taxa_reprodução_peixes [
    hatch 1 [
      caminho-peixe
      set heading random 360
      set x random-pxcor
      setxy x tenta-y 1
      if [ pcolor ] of patch-at 0 0 = black [ die ]
    ]
  ]
end
to morre
  ask poluicao [ if Taxa_poluição = 0 [ die ] ]

  let ponto_morre ponto

  let vizinhos neighbors with [pcolor = black and ponto = ponto_morre]
   if vizinhos != no-patches [
    ask one-of vizinhos
      [set pcolor blue]
    ask poluicao [if ponto_morre = ponto [die]]]

  ask patches with [pcolor = black][
   set vizinhos neighbors with [pcolor = black and ponto = ponto_morre]
   if vizinhos != no-patches [
    ask one-of vizinhos
      [set pcolor blue]]]

end
@#$#@#$#@
GRAPHICS-WINDOW
200
10
710
521
-1
-1
2.0
1
10
1
1
1
0
1
1
1
0
250
0
250
1
1
1
ticks
30.0

SLIDER
5
55
190
88
Taxa_poluição
Taxa_poluição
0.0
10
1.0
1.0
1
NIL
HORIZONTAL

BUTTON
112
274
181
310
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
18
274
88
310
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
5
10
190
43
Pontos_poluição
Pontos_poluição
0
3
3.0
1
1
NIL
HORIZONTAL

PLOT
751
10
1147
213
Poluição
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Poluição" 1.0 0 -16777216 true "" "plot count patches with [ pcolor = black ]"

PLOT
750
235
942
385
Quantidade de peixes
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -14454117 true "" "plot count peixes"

SLIDER
5
103
190
136
Quantidade_peixes
Quantidade_peixes
0
30
30.0
1
1
NIL
HORIZONTAL

PLOT
948
235
1148
385
Pontos_poluição
NIL
NIL
0.0
4.0
0.0
4.0
true
false
"" ""
PENS
"default" 1.0 0 -5298144 true "" "plot count poluicao"

SLIDER
4
153
190
186
Taxa_reprodução_peixes
Taxa_reprodução_peixes
0
5
5.0
1
1
NIL
HORIZONTAL

SLIDER
1
206
197
239
Max_poluição_para_reprodução
Max_poluição_para_reprodução
1
4
4.0
1
1
%
HORIZONTAL

@#$#@#$#@
## O que é?

Neste trabalho, apresentamos uma simulação em NetLogo nomeada como Poluição X Drone. Primeiramente, pensou-se em analisar a interação entre uma poluição que se propaga na água a partir de uma fonte poluidora, com a trajetória de drones que acabariam com essa poluição.  Ao longo do desenvolvimento do programa, foram acrescentados peixes que podem morrer ou reproduzir, dependendo da quantidade de poluição na água.

## Como funciona?

Neste trabalho, os agentes que interagem entre si ou com o ambiente são: pontos de poluição, poluentes, peixes e drones. Se não há pontos de poluição ou poluentes na água, a simulação não começa. Caso contrário, as seguintes interações ocorrem até a poluição acabar, fazendo com que a simulação pare:
- A poluição se propaga na água;
- Dois drones perseguem os pontos de poluição e os poluentes na água até eliminá-los;
- Se um poluente atinge um peixe então esse peixe morre;
- Se a poluição está abaixo de um limite definido então o peixe reproduz.

## Como se usa?

No canto direito estão alguns valores que devem ser definidos antes da simulação começar. Em ordem temos:
•	A quantidade de pontos de poluição inicial, que varia de 0 a 3;
•	A taxa de poluição no ambiente, que induz o crescimento da poluição, podendo variar de 0 a 10;
•	A quantidade de peixes inicial do modelo, que pode ser um número de 0 a 30;
•	A taxa de reprodução dos peixes que influencia no aumento da população de peixes, podendo variar de 0 a 5;
•	O máximo de poluição aceitável para que o peixe possa se reproduzir, onde seu valor é dado referente a uma porcentagem do total de água no ambiente, variando de 1 a 4%.
Logo abaixo, estão os botões de setup e go. Toda vez que o botão setup é selecionado, o ambiente reinicia com os valores definidos acima. O botão de go gera a simulação do modelo. Para cada tick o go reinicia a partir do código e para quando a poluição acaba.

## Referências

* Da Fonseca, C. N.; Dos Santos, R. UM MODELO DE SIMULAÇÃO A PARTIR DO AMBIENTE NETLOGO. XX EREMATSUL, 2014.

* Novak, M. and Wilensky, U. (2006). NetLogo Wolf Sheep Stride Inheritance model. http://ccl.northwestern.edu/netlogo/models/WolfSheepStrideInheritance. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

* Wilensky, U. (1997). Modelo NetLogo Fire. http://ccl.northwestern.edu/netlogo/models/Fire. Centro de Aprendizagem Conectada e Modelagem Baseada em Computador, Northwestern University, Evanston, IL.


## Observação

Autoras: Bruna da Silva Leitzke e Letiane Borges Pereira.

Orientação: Diana Francisca Adamatti.

Este trabalho foi desenvolvido na disciplina Simulação Social: Teoria e Aplicações, pelo Programa de Pós-Graduação em Modelagem Computacional da Universidade Federal de Rio Grande, finalizado em junho de 2019.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
set density 60.0
setup
repeat 180 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count patches with [pcolor = black]</metric>
    <metric>count peixes</metric>
    <metric>ticks</metric>
    <enumeratedValueSet variable="Quantidade_peixes">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Taxa_poluição">
      <value value="1"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Taxa_reprodução_peixes">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Max_poluição_para_reprodução">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Pontos_poluição">
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
