extensions [table]
breed [ fiscais fiscal ]
breed [ agricultores agricultor ]
breed [ empresarios empresario ]
breed [ vereadores vereador]
breed [ ongs ong ]
breed [ prefeitos prefeito ]
breed [ endpatches endpatch ]
breed [areasPol areaPol]
breed [areasLimp areaLimp]
breed [pontes ponte]
breed [casas casa]
breed [cercas cerca]
breed [empresas empresa]
breed [prefeituras prefeitura]
globals [ setores mercadorias qEmp prComp agenteA agenteE polGeral polui area poluido cor]
turtles-own [ saldo taxa latifundio imposto poluicao fixo?]
casas-own [donos]
agricultores-own [ organico? propriedades multas hectares comprasAgr comprasFer comprasMaq comprasSem]
ongs-own [ salario ]
vereadores-own [ salario ]
fiscais-own [ salario ]
empresarios-own [ setor produtos ]
patches-own [invisible-pcolor dono]
to setup
  clear-all
  criarArea
  criarAgricultores
  criarFiscais
  criarEmpresarios
  criarVereadores
  criarOngs
  criarPrefeitos
  reset-ticks
end
to go
  moverAgentes
  fiscalizar
  comprar
  impostoSalario
  ajustValores
  plantar
  ;  ask areasPol
  ;    [ ask neighbors4 with [pcolor = green]
  ;      [ espPol ]
  ;      set breed areasLimp ]
  ;  ask patches with [pxcor = random-pxcor]
  ;    [ espPol ]
  ;  if polGeral >= 120 [
  ;    ask patches with [pcolor = green ]
  ;    [
  ;      set pcolor red - 3.5
  ;    ]
  ;    stop
  ;  ]
  ;  display
  tick
end
to criarArea
  ask patches [ set pcolor green - 0.25 - random-float 0.25 ]
  ask patches with [(pycor > 0 and pycor < 16 and pxcor < 24)] [
    set pcolor blue;
  ]
  ask patches with [(pxcor > 10 and pxcor < 24)] [
    set pcolor blue;
  ]
  set-default-shape cercas "square 2"
  create-cercas 1 [
    set size 18
    setxy -30 27
  ]
  set-default-shape cercas "square 2"
  create-cercas 1 [
    set size 18
    setxy -31 -27
  ]
  set-default-shape cercas "square 2"
  create-cercas 1 [
    set size 18
    setxy -2 -31
  ]
  set-default-shape pontes "tile stones"
  create-pontes 1 [
    set color grey
    set size 5
    setxy -15 2
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy -15 6
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy -15 10
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy -15 14
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy 12 30
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy 17 30
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy 22 30
  ]
  create-pontes 1 [
    set color grey
    set size 5
    setxy -15 14
  ]
  ask pontes [
    ask patch-here [
      ask neighbors [
        set pcolor red - 3
        ask neighbors [
          set pcolor red - 3
        ]
      ]
      set pcolor red - 3
    ]
  ]
  create-casas 1 [
    set shape "casadupla"
    set color one-of [yellow orange red magenta pink gray]
    set size 14
    setxy -30 -17
  ]
  create-casas 1 [
    set shape "casasimples"
    set color one-of [yellow blue red magenta pink gray]
    set size 14
    setxy -1 -21
  ]
  create-casas 1 [
    set shape "casa"
    set color one-of [yellow blue red magenta pink gray]
    set size 12
    setxy -30 37
  ]
  set-default-shape empresas "factory"
  create-empresas 1 [
    set color one-of [white brown]
    set size 18
    setxy 34 25
  ]
  create-empresas 1 [
    set color one-of [white brown]
    set size 18
    setxy 39 35
  ]
  create-prefeituras 1 [
    set shape "prefeitura"
    set color one-of [white gray]
    set size 18
    setxy -4 33
  ]
  ;  set-default-shape areasPol "square"
  ;  set-default-shape areasLimp "square"
  ;  set area count patches with [pcolor = green]
  ;  set poluido 0
  ask patches with [(pxcor > -39 and pxcor < -23) and (pycor > -35 and pycor < -20)] [
    set dono "(agricultor 17)"
  ]
  ask patches with [(pxcor > -10 and pxcor < 6) and (pycor > -39 and pycor < -24)] [
    set dono "(agricultor 18)"
  ]
  ask patches with [(pxcor > -38 and pxcor < -22) and (pycor > 19 and pycor < 34)] [
    set dono "(agricultor 19)"
  ]
end
to criarAgricultores
  set-default-shape agricultores "agricultor"
  create-agricultores num-agricultores [
    set color 137
    set size 5
    set fixo? false
    set hectares 100
    set agenteA self
    set comprasAgr table:make
    move-to one-of patches with [dono = (word "" agenteA)]
    table:put comprasAgr (list "agComum" "agPremium" "agSPremium") (list 0 0 0 )
    set comprasFer table:make
    table:put comprasFer (list "FComum" "FPremium" "FSPremium" ) (list 0 0 0)
    set comprasSem table:make
    table:put comprasSem (list "arroz" "hort" "soja" ) (list 0 0 0)
    set comprasMaq table:make
    table:put comprasMaq (list "drone" "semeadeira" "pulverizador" "colheitadeira") (list 0 0 0 0)
    set organico? one-of [ true false ]
    ifelse organico? = true [
      set saldo 150000
      set latifundio 600000
      set imposto 15
    ] [
      set saldo 300000
      set latifundio 3000000
      set imposto 20
    ]
  ]
end
to criarPrefeitos
  set-default-shape prefeitos "prefeito"
  create-prefeitos num-prefeitos [
    set color brown + 1
    set size 5
    set fixo? true
    set saldo 1000000
    setxy one-of [-1 -2 -5] one-of [ 23 22 21 ]
  ]
end
to criarFiscais
  set-default-shape fiscais "fiscal"
  create-fiscais num-fiscais [
    set color brown
    set size 5
    set fixo? false
    set saldo 100000
    set salario 60000
    set imposto 8
  ]
end
to criarVereadores
  set-default-shape vereadores "vereador"
  create-vereadores num-vereadores [
    set color pink + 3.2
    set size 5
    setxy one-of [-5 -7 -3 -9] one-of [23 22 21]
    set saldo 100000
    set salario 180000
    set imposto 8
    set fixo? true
  ]
end
to criarOngs
  set-default-shape ongs "ong"
  create-ongs num-ongs [
    set color brown + 3
    set size 5
    set fixo? false

    set saldo 50000
    set imposto 8
    set salario 14000
  ]
end

to criarEmpresarios
  set-default-shape empresarios "empresario"
  set setores (list "maquinas" "agrotoxicos" "fertilizantes" "sementes")
  let i 0
  while [ i < (num-empresarios - 4)] [
    set setores lput item random 4 setores setores
    set i i + 1
  ]
  create-empresarios num-empresarios [
    set color yellow + 4
    set size 5
    set fixo? false
    set saldo 700000
    set latifundio 6500000
    set produtos table:make
    set setor one-of setores
    setxy xaleatorio random-pycor
    if setor = "agrotoxicos" [
      set imposto 45
      ; produtos nome (quantidade na empresa, preço para compra, quantidade de poluicao)
      table:put produtos "agComum" (list 1 one-of [5 10 15] 1)
      table:put produtos "agPremium" (list 1 one-of [15 20 25] 2)
      table:put produtos "agSPremium" (list 1 one-of [25 30 35] 3)
      set setores remove-item position "agrotoxicos" setores setores
    ]
    if setor = "maquinas" [
      set imposto 30
      table:put produtos "semeadeira" (list 1 one-of [25 30 35] 3)
      table:put produtos "pulverizador" (list 0 one-of [395 400 405] 40)
      table:put produtos "colheitadeira" (list 1 one-of [55 60 65] 6)
      table:put produtos "drone" (list 0 one-of [85 90 95] 9)
      set setores remove-item position "maquinas" setores setores
    ]
    if setor = "fertilizantes"[
      set imposto 45
      table:put produtos "FComum" (list 0 one-of [25 30 35] 3)
      table:put produtos "FPremium" (list 1 one-of [55 60 65] 6)
      table:put produtos "FSPremium" (list 0 one-of [85 90 95] 9)
      set setores remove-item position "fertilizantes" setores setores
    ]
    if setor = "sementes" [
      set imposto 45
      table:put produtos "hort" (list 1 one-of [5 10 15] 1)
      table:put produtos "arroz" (list 0 one-of [15 20 25] 2)
      table:put produtos "soja" (list 1 one-of [25 30 35] 3)
      set setores remove-item position "sementes" setores setores
    ]
  ]
end
to-report xaleatorio
  loop [
    let x random-pxcor
    if ( x > 24 ) [ report x ]
  ]
end
to moverAgentes
  ask turtles with [fixo? = false] [
    right random 30
    left random 30
    let turn one-of [ -10 10 ]
    set heading heading + turn
    ifelse patch-ahead 0.5 != nobody [
      ifelse shade-of? blue [pcolor] of patch-ahead 0.4 [
        rt 10
        fd 0.2
      ][fd 0.3]
      if shade-of? blue [pcolor] of patch-here [
        ask patch-here [
          if shade-of? green [pcolor] of one-of neighbors [
            let vizinhoverde one-of neighbors with [pcolor != blue]
            ask turtles-here [
              move-to vizinhoverde
            ]
          ]
        ]
      ]
    ]
    [
      set heading heading + random 10
      fd random-float 1.0
    ]
  ]
end
to plantar
  ask agricultores [
    if random-float 50 > 40 [
      let instrumentos (list one-of ["hort" "arroz" "soja"] one-of [ "agComum" "agPremium" "agSPremium" false false false ] one-of [ "FComum" "FPremium" "FSPremium" false false false ]  one-of [ "semeadeira" "pulverizador" "colheitadeira" "drone" false false false false ])
      let tempo ticks
;      if table:has-key? produtos instrumentos = true [
;
;      ]
    ]
  ]
end
to fiscalizar
  ask turtles [
    if poluicao > 99 [
      ask one-of agricultores [
        let distancia self
        ask fiscais with [distance distancia < 5] [
          face distancia
        ]
      ]
      ask fiscais [
        ask agricultores-here [
          set multas multas + 1
        ]
      ]
    ]
  ]
end
to impostoSalario
  ask turtles [
    if (ticks mod 360 = 0) and (ticks != 0) [
      if is-ong? self = true or is-fiscal? self = true or is-vereador? self = true [
        set saldo saldo + salario
      ]
      set saldo saldo - (imposto * saldo) / 100
    ]
  ]
end
to comprar
  if random-float 100 > 99 [
    ask empresarios [
      set agenteE self
      ask agricultores with [distance agenteE < 5] [
        set agenteA self
        face agenteE
      ]
      let produto one-of table:keys produtos
      set qEmp item 0(table:get produtos produto)
      set prComp item 1(table:get produtos produto)
      set polui item 2(table:get produtos produto)
      ifelse qEmp <= 0 [
        produzirEmp produto
      ] [
        ask agenteA [
          let posicao position produto (item 0(item 0 table:to-list comprasAgr))
          if produto = "agComum" or produto = "agPremium" or produto = "agSPremium" [
            comprarA produto comprasAgr prComp
          ]
          if produto = "FComum" or produto = "FPremium" or produto = "FSPremium" [
            comprarA produto comprasFer prComp
          ]
          if produto = "soja" or produto = "arroz" or produto = "hort" [
            comprarA produto comprasSem prComp
          ]
          if produto = "semeadeira" or produto = "drone" or produto = "pulverizador" or produto = "colheitadeira" [
            comprarA produto comprasMaq prComp
          ]
        ]
      ]
    ]
  ]
end
to comprarA [ produto comprasTipo prCompra ]
  let posicao position produto (item 0(item 0 table:to-list comprasTipo))
  let quant item posicao(item 0(table:values comprasTipo))
  if quant <= 0 or random-float 1000 > 999 and (propriedades >= 1) and (saldo >= prCompra + 10) [
    let lista (item 0(table:values comprasTipo))
    let c 0
    let nLista []
    while [c < length lista][
      ifelse c = posicao [
        set nLista lput(item c(lista) + 1) nLista
      ][ set nLista lput (item c(lista)) nLista ]
      set c c + 1
    ]
    set saldo saldo - prCompra
    table:put comprasTipo (item 0(table:keys comprasTipo)) nLista
    ask agenteE [
      set qEmp (qEmp - 1)
      set saldo saldo + prCompra
      table:put produtos produto (list qEmp prCompra polui)
    ]
  ]
end
to produzirEmp [ prod ]
  if random-float 1000 > 800 [
    if prod = "agComum" or prod = "agPremium" or prod = "agSPremium" [
      ask one-of empresarios with [setor = "agrotoxicos"] [
        let pol item 2(table:get produtos prod)
        table:put produtos prod (list (qEmp + 1) prComp pol)
        set poluicao poluicao + pol
      ]
    ]
    if prod = "arroz" or prod = "hort" or prod = "soja"[
      ask one-of empresarios with [setor = "sementes"] [
        let pol item 2(table:get produtos prod)
        table:put produtos prod (list (qEmp + 1) prComp pol)
        set poluicao poluicao + pol
      ]
    ]
    if prod = "FComum" or prod = "FPremium" or prod = "FSPremium" [
      ask one-of empresarios with [setor = "fertilizantes"] [
        let pol item 2(table:get produtos prod)
        table:put produtos prod (list (qEmp + 1) prComp pol)
        set poluicao poluicao + pol
      ]
    ]
    if prod = "semeadeira" or prod = "pulverizador" or prod = "drone" or prod = "colheitadeira" [
      ask one-of empresarios with [setor = "maquinas"] [
        let pol item 2(table:get produtos prod)
        table:put produtos prod (list (qEmp + 1) prComp pol)
        set poluicao poluicao + pol
      ]
    ]
  ]
end
to ajustValores
  ask turtles [
    set saldo precision saldo 2
    if polGeral != polGeral + poluicao [
      set polGeral polGeral + poluicao
      poluirRio
    ]
  ]
end

to poluirRio
  ask patches with [shade-of? blue pcolor] [
    if pcolor - 0.01 >= 100 [
      set pcolor pcolor - 0.01
    ]
  ]
end
;to espPol
;  if precision ((poluido / (area + 1)) * 100) 0 != polGeral and polGeral != 0 [
;    sprout-areasPol 1
;    [ set color red - 3 ]
;    set pcolor brown - 3
;    set poluido poluido + 1
;  ]
;  escurecerArea
;end
;
;to escurecerArea
;  ask areasLimp
;    [ set color color - 0.3
;      if color < red - 3.5
;        [ set pcolor color
;          die ] ]
;end
@#$#@#$#@
GRAPHICS-WINDOW
224
32
880
689
-1
-1
8.0
1
10
1
1
1
0
0
0
1
-40
40
-40
40
1
1
1
Dias
30.0

SLIDER
42
117
212
150
num-fiscais
num-fiscais
1
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
43
79
215
112
num-agricultores
num-agricultores
1
10
1.0
1
1
NIL
HORIZONTAL

BUTTON
141
32
209
71
Ir
go
T
1
T
OBSERVER
NIL
I
NIL
NIL
0

SLIDER
41
153
211
186
num-empresarios
num-empresarios
4
8
4.0
1
1
NIL
HORIZONTAL

SLIDER
39
189
211
222
num-ongs
num-ongs
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
39
226
211
259
num-vereadores
num-vereadores
1
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
38
263
210
296
num-prefeitos
num-prefeitos
1
2
2.0
1
1
NIL
HORIZONTAL

MONITOR
151
305
209
350
Poluição
polGeral
10
1
11

BUTTON
45
32
119
72
Config.
setup
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

@#$#@#$#@
## O QUE É ISSO?
   Os sistemas multiagentes (SMA) baseiam-se em softwares desenvolvidos com agentes interagindo em um mesmo ambiente, de forma que cada um tem comportamento autônomo, isto é, existem de maneira interdependente, assumindo papéis fundamentais na resolução de um problema, visto suas diferentes maneiras de abordar uma situação de forma cooperativa. Sendo assim, o SMA é uma abordagem eficiente em tomadas de decisão em situações reais, devido à sua alta precisão de dados. Usufruindo desse aspecto do SMA, o presente trabalho utiliza a linguagem de programação NetLogo, atuante em um sistema integrado multiagente, para simular uma situação social modelada que envolve a gestão participativa de recursos hídricos. 
## COMO ISSO FUNCIONA?

A simulação consiste em fazer com que agentes que atuam como agricultores e empresários, prefeitos, vereadores, membros de ONGs e fiscais ambientais, façam a gestão de suas interações interpessoais e econômicas em prol de um uso e distribuição mais eficientes da água, um bem tão importante nesse cenário.
Os agentes atuantes como agricultores e empresários têm o papel de explorar a área de atuação visando sucesso financeiro, de modo que suas relações entre si e com o meio ambiente envolvem a produção e uso de artefatos auxiliares a plantações como agrotóxicos e maquinários, trazendo, assim, uma maior quantidade de movimentação financeira e de poluição ao ambiente. Para a fiscalização e punição pelo uso exacerbado de insumos danosos e poluentes provenientes das ações destes agentes, precisa-se da constante vigília de membros de ONGs e fiscais, importantes para aplicar multas e denúncias pela poluição elevada. Atuam, então, os agentes que utilizam essas denúncias para promulgar políticas e leis que reduzem a poluição, os prefeitos e vereadores. Estes estão encarregados de estabelecer quais são os níveis recomendados de poluição, mediando essa taxa sem comprometer as relações de produção, importantes para a renda do cenário o qual gerem.

## COMO USAR?

## COISAS PARA PERCEBER
 Simular estas relações sociais interpessoais em um cenário modelado por meio de sistemas multiagente tem se mostrado de uma eficácia elevada para o entendimento de diversos problemas socio-ambientais como o apresentado, buscando um maior aperfeiçoamento no entendimento e previsão de aspectos da sociedade por meio destes sistemas computacionais.

## ENTENDENDO A SIMULAÇÃO

## CREDITS AND REFERENCES
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

agricultor
false
0
Rectangle -7500403 true true 135 75 165 94
Polygon -7500403 true true 120 90 120 180 105 270 105 270 135 270 150 210 165 270 195 270 195 270 180 180 180 90
Polygon -1 true false 75 165 90 180 120 120 120 195 180 195 180 120 210 180 225 165 195 90 165 90 150 105 150 105 135 90 105 90
Circle -7500403 true true 108 3 84
Polygon -13345367 true false 120 90 120 150 120 165 105 255 105 270 135 270 150 210 165 270 195 270 195 270 180 165 180 90 180 90 165 120 135 120 120 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 30 188 36 224 23 222 14 180 15 180 0

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

casa
false
0
Rectangle -7500403 true true 15 165 285 255
Rectangle -1 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -13791810 true false 30 180 105 240
Rectangle -13791810 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -16777216 true false 0 165 150 90 150 120 150 90 210 120 300 165

casadupla
false
0
Polygon -6459832 true false 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 75 135 270 255
Rectangle -6459832 true false 124 195 187 256
Rectangle -11221820 true false 210 195 255 240
Rectangle -11221820 true false 90 150 135 180
Rectangle -11221820 true false 150 150 195 180
Rectangle -7500403 true true 15 180 75 255
Polygon -6459832 true false 60 135 285 135 240 90 105 90
Line -6459832 false 75 135 75 180
Rectangle -11221820 true false 30 195 93 240
Line -6459832 false 60 135 285 135
Line -6459832 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255
Rectangle -11221820 true false 210 150 255 180

casasimples
false
0
Rectangle -6459832 true false 255 120 270 255
Rectangle -7500403 true true 15 180 270 255
Polygon -955883 true false 0 180 300 180 240 135 60 135 0 180
Rectangle -1 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -11221820 true false 45 195 105 240
Rectangle -11221820 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -955883 false 0 180 300 180

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

container
false
0
Line -16777216 false 0 210 300 210
Line -16777216 false 0 90 300 90
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210

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

empresario
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -16777216 true false 120 90 105 90 75 180 90 195 120 135 120 180 105 285 120 285 135 285 150 225 165 285 195 285 195 285 180 180 180 135 210 195 225 180 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 135 75 165 91
Polygon -13345367 true false 195 210 195 285 270 255 270 180
Rectangle -13791810 true false 180 210 195 285
Polygon -14835848 true false 180 211 195 211 270 181 255 181
Polygon -13345367 true false 209 187 209 201 244 187 243 173

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

factory
false
15
Rectangle -7500403 true false 75 150 285 270
Rectangle -7500403 true false 30 120 59 231
Rectangle -11221820 true false 90 210 270 240
Line -7500403 false 90 195 90 255
Line -7500403 false 90 225 270 225
Circle -1 true true 22 103 32
Circle -1 true true 25 68 54
Circle -1 true true 51 51 42
Circle -1 true true 75 70 32
Circle -1 true true 69 34 42
Rectangle -7500403 true false 14 228 78 270
Rectangle -11221820 true false 90 165 270 195
Line -7500403 false 90 180 270 180
Line -7500403 false 120 150 120 255
Line -7500403 false 150 150 150 240
Line -7500403 false 180 150 180 255
Line -7500403 false 210 150 210 240
Line -7500403 false 240 165 240 240

fiscal
false
0
Polygon -1 true false 124 91 135 195 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 105 285 105 285 135 285 150 225 165 285 195 285 195 285
Polygon -13345367 true false 120 90 120 90 75 165 90 180 120 135 120 195 180 195 180 135 210 180 225 165 180 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 138 75 165 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -16777216 false 150 105 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24

fiscalplace
false
0
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -1 true false 60 195 105 240
Rectangle -1 true false 60 150 105 180
Rectangle -1 true false 210 150 255 180
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 45 135 300 135
Line -7500403 true 154 195 154 255
Rectangle -1 true false 210 195 255 240
Rectangle -1 true false 135 150 180 180
Line -1 false 90 135 105 135
Rectangle -13345367 true false 45 135 270 150
Line -1 false 90 135 90 150
Line -1 false 90 135 105 135
Line -1 false 225 150 225 135
Line -1 false 210 135 225 135
Line -1 false 90 150 105 150
Line -1 false 210 150 225 150

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

ong
false
0
Polygon -7500403 true true 120 90 120 90 75 165 90 180 120 120 120 195 180 195 180 120 210 180 225 165 180 90 180 90 180 105 150 105 135 105 120 90
Rectangle -7500403 true true 120 75 180 120
Polygon -1 true false 120 105 149 141 180 105
Circle -7500403 true true 110 5 80
Polygon -2674135 true false 120 120 120 120 120 150 120 180 150 180 150 120 120 90
Polygon -13345367 true false 120 180 105 270 135 270 150 210 165 270 195 270 180 180 120 180
Polygon -1184463 true false 105 105 135 105
Polygon -1184463 true false 105 150
Polygon -1184463 true false 105 60 165 15
Polygon -1184463 true false 120 75
Polygon -1184463 true false 135 90
Polygon -1184463 true false 120 90 120 75 105 45 120 30 120 90 120 90
Polygon -1184463 true false 165 15 195 45 195 75 195 45 180 75 195 75 195 75 195 75 180 75 195 30 165 15 195 45
Polygon -1184463 true false 165 0 195 30 180 30 165 15 165 0
Polygon -1184463 true false 180 30 195 75 180 75
Polygon -1184463 true false 180 30 195 45 195 60 180 30 195 60 195 30 180 30 180 60
Polygon -1184463 true false 180 30 180 75 195 45 180 30
Polygon -2674135 true false 180 120 180 120 180 150 180 180 150 180 150 120 180 90
Polygon -1184463 true false 150 0 105 45 120 90 120 135 105 135 105 45 120 0 165 0 195 45 195 120 180 120 180 75 195 45 180 15 135 15 105 45
Polygon -1184463 true false 195 45 195 45 165 90 195 90 195 30 195 30
Polygon -1184463 true false 105 45 105 45 135 90 105 90 105 30 105 30
Rectangle -16777216 true false 116 171 182 183

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

prefeito
false
0
Circle -7500403 true true 110 5 80
Rectangle -1 true false 120 90 180 150
Rectangle -7500403 true true 127 79 172 94
Line -16777216 false 150 195 165 195
Line -16777216 false 150 150 165 150
Polygon -2674135 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -13791810 true false 120 90 75 165 90 180 120 135 120 195 150 225 165 195 180 195 180 135 210 180 225 165 180 90 165 90 150 150 135 90
Polygon -16777216 false false 165 225
Polygon -16777216 true false 90 285
Polygon -13791810 true false 105 285 135 285 150 225 165 285 210 285 150 225 90 285
Polygon -13791810 true false 105 270 120 195 150 225 105 285
Polygon -13791810 true false 195 285 180 180 135 210 195 270

prefeitura
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Polygon -7500403 true true 0 60 150 15 300 60
Circle -1 true false 135 26 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -6459832 true false 15 30 30 285
Rectangle -6459832 true false 270 30 285 285
Rectangle -6459832 true false 30 270 270 285
Rectangle -6459832 true false 15 30 45 45
Rectangle -6459832 true false 255 30 285 45

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

tile log
false
0
Rectangle -7500403 true true 0 0 300 300
Line -16777216 false 0 30 45 15
Line -16777216 false 45 15 120 30
Line -16777216 false 120 30 180 45
Line -16777216 false 180 45 225 45
Line -16777216 false 225 45 165 60
Line -16777216 false 165 60 120 75
Line -16777216 false 120 75 30 60
Line -16777216 false 30 60 0 60
Line -16777216 false 300 30 270 45
Line -16777216 false 270 45 255 60
Line -16777216 false 255 60 300 60
Polygon -16777216 false false 15 120 90 90 136 95 210 75 270 90 300 120 270 150 195 165 150 150 60 150 30 135
Polygon -16777216 false false 63 134 166 135 230 142 270 120 210 105 116 120 88 122
Polygon -16777216 false false 22 45 84 53 144 49 50 31
Line -16777216 false 0 180 15 180
Line -16777216 false 15 180 105 195
Line -16777216 false 105 195 180 195
Line -16777216 false 225 210 165 225
Line -16777216 false 165 225 60 225
Line -16777216 false 60 225 0 210
Line -16777216 false 300 180 264 191
Line -16777216 false 255 225 300 210
Line -16777216 false 16 196 116 211
Line -16777216 false 180 300 105 285
Line -16777216 false 135 255 240 240
Line -16777216 false 240 240 300 255
Line -16777216 false 135 255 105 285
Line -16777216 false 180 0 240 15
Line -16777216 false 240 15 300 0
Line -16777216 false 0 300 45 285
Line -16777216 false 45 285 45 270
Line -16777216 false 45 270 0 255
Polygon -16777216 false false 150 270 225 300 300 285 228 264
Line -16777216 false 223 209 255 225
Line -16777216 false 179 196 227 183
Line -16777216 false 228 183 266 192

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

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

vereador
false
0
Rectangle -1 true false 120 150 180 210
Rectangle -7500403 true true 135 75 165 95
Polygon -1 true false 120 90 75 180 90 195 120 150 180 150 210 195 225 180 180 90
Polygon -16777216 true false 180 180 120 180 105 270 105 285 135 285 150 210 165 285 195 285 195 270
Circle -7500403 true true 110 5 80
Circle -16777216 true false 150 105 0
Circle -16777216 true false 150 105 0
Circle -16777216 true false 150 105 0
Circle -16777216 false false 150 135 0
Line -7500403 true 150 90 150 180
Polygon -13345367 true false 135 90 165 90 150 105 135 90 150 105 150 105
Polygon -13345367 true false 150 105 135 120 150 165 165 120 150 105

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
