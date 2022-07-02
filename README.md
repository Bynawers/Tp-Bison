# Yacc-Bison
![Project](https://img.shields.io/badge/Correction-Project-2F77DF?labelColor=679EEE&style=for-the-badge)
![Bison](https://img.shields.io/badge/Bison-4b6c4b?style=for-the-badge)
![Lex](https://img.shields.io/badge/Lex-dbca00?style=for-the-badge)
![C](https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=c&logoColor=ffffff)

**Exercice 7.1 Premier programme en bison**

Vous devez récupérer le fichier BISON.zip sur moodle. Une fois dezippé, vous avez un dossier BISON qui contient
les trois fichiers :
1. Makefile
2. exo01.l un fichier flex. Notez qu’à partir de maintenant les extensions des fichiers flex seront .l et non plus
.lex
3. exo01.y un fichier bison. L’extension .y est historique du temps de yacc.
Première approche :
1. Vérifiez que tout fonctionne bien sur votre ordinateur en tapant make dans un shell. vous devriez avoir :
bash$ make
bison -d -v exo01.y
flex -o exo01.yy.c exo01.l
gcc -o exo01 exo01.tab.c exo01.yy.c "-L/usr/local/opt/flex/lib" -ly -lfl
echo "10-6-2" | ./exo01
=2
bash$
2. Avec votre éditeur regarder le contenu du fichier exo01.l . Notez le #include "exo01.tab.h" au début.
3. Quels fichiers sont créés avec la commande flex ? Utiliser make clean et lancer la commande flex «à la
main».
4. Avec votre éditeur regarder le contenu du fichier exo01.y . Quelle est la grammaire de ce langage.
5. Quels fichiers sont créés avec la commande bison ? Utiliser make clean et lancer la commande bison «à la
main».
6. Que contient le fichier exo01.tab.h ?

**Exercice 7.2 Associativité**

Faites les modifications suivantes :
1. Taper make, quel parenthèsage a été choisi pour évaluer l’expression 10-6-2 ? Expliquer pourquoi.
2. Dans le fichier exo01.y remplacer expression ’-’ NOMBRE par NOMBRE ’-’ expression.
3. Taper make, quel parenthèsage a été choisi pour évaluer l’expression 10-5-2 ? Expliquer pourquoi.
Exercice 7.3 Conflit shift/reduce (décalage/réduction)
Faites les modifications suivantes :
1. Dans le fichier exo01.y remplacer NOMBRE ’-’ expression par expression ’-’ expression.
2. Taper make, quel nouvel affichage y a-t-il dans le terminal ? Expliquer la raison de cet affichage.
3. Quel parenthèsage a été choisi pour évaluer l’expression 10-6-2 ?
4. Editer le fichier exo01.output , chercher le conflit et noter quelle résolution en a fait bison.

**Exercice 7.4 Calcul des items**

Soit la grammaire d’axiome I et de règles de production :
I → E
E → E − E | n
Les non terminaux sont I et E et les terminaux sont − et n.
1. Donner la grammaire augmentée.
16
2. Donner la liste de tous les items de la grammaire augmentée.
3. Donner l’automate d’analyse ascendante.
4. Comparer votre automate avec celui du fichier exo01.output .
5. Construire la table d’analyse ascendante LR(0).
6. Utiliser la table pour construire les deux arbres possibles de l’expression 10 − 6 − 2.

**Exercice 7.5 Résolution de conflit shift/reduce grâce à la souplesse du bison**

1. Taper makeet recopier le fichier exo01.output dans base.output
Faites les modifications suivantes :
1. Dans le fichier exo01.y en dessous de %token NOMBRE, rajouter %left ’-’.
2. Taper make, que constatez vous ? Recopier les fichiers exo01.output dans left.output .
3. Dans le fichier exo01.y , remplacer %left ’-’ par remplacer %right ’-’ .
4. Taper make, que constatez vous ? Recopier les fichiers exo01.output dans right.output .
5. Comparer les fichiers base.output , left.output et right.output

**Exercice 7.6 Nouvelles règles**

Ajouter dans le fichier des règles pour :
1. Pouvoir faire l’addition et ajouter %left ’-’ ’+’.
2. Pouvoir faire la multiplication et mettre %left ’-’ ’+’ ’*’.
3. Compiler, quels conflits y a-t-il ?
4. Tester avec 2+3*4 et 3*4+2 en ajoutant des lignes de la forme echo "2+3*4" | ./exo01 dans le Makefile .
5. Modifier l’instruction %left ’-’ ’+’ ’*’ par les deux instructions %left ’*’ et %left ’-’ ’+’ sur deux
lignes successives. Y a-t-il toujours un conflit ? Retester avec 2+3*4 et 3*4+2.
6. Déplacer %left ’*’ au dessus de %left ’-’ ’+’ et retester, que constatez-vous sur les priorités des opérateurs

**Exercice 7.7 Division**

Ajouter dans le fichier des règles pour :
1. Pouvoir faire la division et ajouter %left ’*’ ’/’.
2. Que se passe-t-il en cas de division par zéro ?
3. Ajouter un test et si le dénominateur vaut 0, appeler la fonction : yyerror("Division par 0");

**Exercice 7.8 Les parenthèses**

1. Ajouter dans le fichier des règles pour pouvoir parenthèser les expressions.
2. Ajouter dans le fichier des règles pour pouvoir faire l’opération de valeur absolue.
3. Proposer deux expressions à tester permettant de se convaincre que ça à l’air juste.

**Exercice 8.1 Pré, inf, post**

Soit la grammaire E → E + E | E ∗ E | (E) | id, des expressions arithmétiques en notation infixe.
Dans toutes les questions, on suppose que les opérateurs sont associatifs de gauche à droite et que ∗ est plus prioritaire
que +
1. Écrire le programme flex et le programme bison pour évaluer les expressions de cette grammaire. Évaluer
l’expression (2 + 3) ∗ 4.
2. Écrire un autre programme bison pour réécrire les expressions en notation postfixée.
3. Écrire un autre programme bison pour évaluer les expressions en notation postfixée.
4. Écrire un autre programme bison pour réécrire les expressions postfixe en préfixe.
5. Écrire un autre programme bison pour réécrire les expressions préfixe en infixe.

**Exercice 8.2 Projet d’IN510 – Évaluation d’expressions booléennes**

Rappel du sujet.
Les expressions booléennes sont définies de la façon suivante :
- il n’y a pas de variables ;
- les constantes sont uniquement 0 (pour faux) et 1 (pour vrai) ;
- les opérateurs binaires sont + (pour le OU), . (pour le ET), => (pour l’implication), <=> (pour
l’équivalence) ;
- l’opérateur unaire est NON ;
- les opérateurs binaires sont tous associatifs de gauche à droite, c’est à dire en cas de parenthèses non mises,
l’expression sera toujours interprétée comme si elle était parenthésée de gauche à droite. Par exemple 0+1.0
doit être interprété comme (0+1).0 ;
- les parenthèses ( et ) permettent de forcer la priorité.
1. Donner les programmes flex et bison permettant d’évaluer une expression booléenne.
Tester avec (1.( (0 +1)=>NON1))<=>(1=> 0) .
2. Modifier vos programmes pour avoir les opérateurs associatifs de gauche à droite et avec les priorités suivantes
(du plus prioritaire au moins prioritaire) : NON , . , + , => et <=> .
3. Modifier vos programmes pour générer l’arbre de l’expression booléenne, l’afficher et l’évaluer

Le but de cet ensemble d’exercices est de construire un compilateur complet en partant du langage source, en
passant par un langage intermédiaire à trois adresses et finalement de produire du C.

**Exercice 9.1 Le langage**

Les caractéristiques du langage sont
- le langage traite uniquement des entiers ;
- on peut écrire les expressions arithmétiques classiques en notation infixe ;
- les opérateurs sont les opérateurs classiques sur les entiers ;
- on peut définir des constantes entières mais uniquement en base 10 ;
- on a l’affectation avec := ;
- on peut définir des variables, elles ne sont pas déclarées mais la première fois qu’une variable apparait, ça doit
être à gauche de l’affectation ;
- à gauche de l’affectation on ne peut avoir qu’une variable ;
- à droite de l’affectation on peut avoir n’importe quelle expression arithmétique contenant des constantes et des
variables ;
- le code se fait sur plusieurs lignes, il peut y avoir des lignes vides, la fin d’une ligne indique la fin d’une
instruction ;
- les instructions sont soit une affectation soit un affichage d’une seule variable, la syntaxe est libre, par exemple
print toto . La variable doit avoir été affectée avant.
Reprenez les fichiers des TD précédents comme base de travail puis,
1. Donner la grammaire de ce langage. Le symbole de départ sera programme .
2. Quels sont les différents types qui peuvent "remonter" de flex vers bison ?
3. Donner le fichier lex et le fichier bison avec toutes les définitions de token, ne pas oublier de définir le %union ,
les %type , les %token , les %left .
4. Après chaque règle de la grammaire ajouter { printf("R xx\n"); } où xx est un numéro que vous donnez
à chaque règle.
5. Donner l’arbre de dérivation pour le fichier prog01.qst :
a := 8+4
print a
6. Vérifier que l’affichage que produit la compilation de prog01.qst est cohérente avec l’arbre de dérivation
que vous avez calculé à la question précédente.

**Exercice 9.2 Table des symboles**

Afin de pouvoir stocker toutes les variables et toutes les constantes, on va créer et gérer une table des symboles.
La table des symboles sera un tableau statique (fixer 1024, comme taille), chaque case devant contenir une
struct avec 3 champs :
- un champ vc qui contiendra l’information du type de la case : constante, variable ou variable temporaire ;
- un champ val qui contiendra la valeur si c’est une constante ;
- un champ nom qui contiendra le nom de la variable si c’est une variable non temporaire.
Avec cette structure, chaque variable ou constante est directement identifiée par son indice dans le tableau.
Au sein de vos programmes flex et bison :

1. Faites les déclarations pour déclarer la variable TDS comme étant le tableau stockant la table des symboles.
2. Déclarer une variable NBVALCONST (initialisée à zéro) et qui contient le nombre de constantes et variables
stockées dans la table des symboles.
3. Créer la fonction int chercher_constante(int val) qui renvoie l’indice de la case contenant la constante
val et -1 si elle n’est pas dans le tableau.
4. Créer la fonction int ajouter_constante(int val) qui ajoute la constante dans la table des symboles et
renvoie l’indice où elle est stockée.
5. Dans la même idée, faites les fonctions chercher_variable et ajouter_variable .
6. Faites une fonction qui affiche la table des symboles d’une manière compréhensible.
7. Au sein du code bison appeler ces fonctions à chaque fois que vous rencontrer une variable ou une constante.
Il pourra être pertinent de faire les trois fonctions suivantes :
- traiter_constante ;
- traiter_variableagauche quand une variable est à gauche de l’affectation ;
- traiter_variableadroite quand une variable est à droite de l’affectation.
Ce seront ces fonctions qui seront appelées dans les règles.
8. Faites en sorte que l’exécution du code flex+bison affiche la table des symboles à la fin.

**Exercice 9.3 Le code à trois adresses**

On rappelle l’idée du code à trois adresses sur un exemple. Supposons que l’on ait l’instruction toto := 3+(2*3) ,
il y aura 3 entrée dans la table des symboles : la constante 2 , la constante 3 et la variable toto :
TDS :

0 1 2

const const var

3 2 toto

Le code à trois adresse va ajouter des variables temporaires pour donner le code suivant :

@3 = @1 * @0

@4 = @0 + @3

@2 = @4

@3 signifie le symbole stocké dans la case 3 de la table des symboles et la table des symboles sera :
TDS :

0 1 2 3 4
const const var var temp var temp
3 2 toto – –

À partir de ce code à trois adresses, on pourra générer du code en C de la forme :

int V[4];

V[0] = 3;
 
V[1] = 2;
 
V[3] = V[1] * V[0];

V[4] = V[0] + V[3];

V[2] = V[4];

Expliquer le lien entre le tableau V et la table des symboles TDS
On va donc définir les structures struct instruction et struct boutdecode qui contiendra plusieurs
instructions.
struct instruction doit contenir :

- le texte du code en langage C ;
- un pointeur vers l’instruction suivante.
struct boutdecode doit contenir :

- un pointeur vers la première instruction de ce bout de code ;
- un pointeur vers la dernière instruction de ce bout de code ;
- l’indice de la dernière variable affectée dans ce bout de code.
Le travail à faire est

1. définir les types struct instruction et struct boutdecode dans le fichier bison.
2. Modifier la fonction traiter_constante pour qu’elle renvoie le bout de code contenant qu’une seule instruction, celle consistant à mettre la constante dans la bonne case de la table des symboles
3. Écrire la fonction concatener qui concatène deux bouts de code et renvoie le bout de code résultat.
4. Écrire une fonction qui écrit la suite des instructions d’un bout de code.
5. Tester votre code sur un exemple d’expression arithmétique 2+ (3*4) .
6. Modifier la fonction traiter_variableadroite et tester.
7. Modifier la fonction traiter_variableagauche et tester.
