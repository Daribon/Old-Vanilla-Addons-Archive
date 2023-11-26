ENG:
GougeHelper will assist you with your Gouge.
Using Gouge+Backstab or Gouge+Bandage, it will help you.
When you Gouge a mob, a channelling window will show how long the mob is "Gouged".
* In case of a backstab, it allows you to wait long enough for max energy before launching you backstab.
* In case of Bandage, a fonction "IsGouged()" will tell you if your Gouge was successfully applyed to the mob. Nothing is more frustrating when using Bandage and the mob break it because Gouged missed...
IsGouged returns 2 values :
- nil when GougeHelper is not activated or the mob isn't gouged
- 1   when GougeHelper is activated AND mob is suffering from a Gouge)

How to use :
/gh        : wil show you some syntaxic help.
/gh on/off : to toggle the GougeHelper-bar.
/gh unlock : will show the GougeHelper-bar, and allows you to move it through Drag'n Drop.
/gh lock   : will lock the GougeHelper-bar where it is.
/gh clear  : will reset the state/position of gougeHelper.

Installation :
Simply decompress in World of Warcraft's directory.


TODO:
* Tested on UK & FR version, need Ger and maybe Kor localisation
* maybe some others timed-stunning-skills ?


History:
---------
v0.9 : Initial Release
* Gouge's ProgressBar
* Movable ProgressBar
* AutoDetection for Talent Points invested in ImpGouge
* Variables saved
* localisation : FR & UK

v0.91 : little bugs
* Correction of initial color for ProgressBar (red instead of yellow)
- Yellow at start;
- Orange at -1sec
- Red at -0.5sec
* Correction of a "OMG-That's-a-stupid-bug", I let in release the US 1.2.1 CombatLog Chan detection I used for test, so UK localisation was broken.

v0.92 : Duel bug
* GougeHelper wasn't launching against human player (duel)

v0.93 : German localisation
* partial German localisation (tx to w1cked on CurseGaming)
------------------------------------------------------------------------------------------------

FR:
GougeHelper est un AddOn qui permet de juger graphiquement de la dur�e (et de la r�ussite, bien sur) de votre comp�tence "Suriner".

Lorsque vous lancer le skill Suriner (Gouge en anglais, d'o� le nom), une barre de progression apparait et vous permet de pr�voir au mieux le moment quand l'adversaire va se reveiller. L'interet �tant bien s�r de retarder au maximum une Attaque Sournoise, le temps de r�cuperer un maximum d'�nergie.

Dans l'optique d'un Gouge suivi d'un bandage, une fonction est � disposition pour savoir si le Gouge a r�ussi (c'est en effet idiot de gaspiller un bandage car le monstre va aussit�t l'interrompre en vous tapant -sans parler de l'attente d'une minute jusqu'au prochain bandage-)
On peut donc utiliser dans une macro la fonction IsGouged() qui renvoit 2 valeurs :
* nil si pas de Gouge appliqu�, ou si GougeHelper est inactif
* 1 si un Gouge a �t� appliqu� avec succ�s.

Utilisation :
/gh        : Affiche une aide sur les options.
/gh on/off : Active/desactive GougeHelper et ses fonctionnalites.
/gh unlock : Affiche la fenetre de Suriner afin de la positionner � l'�cran (cliquer-glisser).
/gh lock   : Bloque la fen�tre l� ou elle se trouve.
/gh clear  : Reinitialise l'etat/position de GougeHelper. 


Installation :
D�compresser l'archive dans le r�pertoire World of Warcraft.


TODO:
* test� sur une version UK et FR, il manque la localisation GER (et corr�enne, mais ...)
* extension � d'autres skill de "stun" ?


History:
---------
v0.9 : Release initiale
* Barre de progression du Gouge
* Barre d�placable
* Sauvegarde des variables
* localisation FR et US

v0.91 : correction d'un bugounet sur la couleur initiale de la barre (rouge au lieu de jaune)
* Correction d'un bug sur le changement de couleur de la barre.
- Jaune au d�part.
- Orange � -1sec
- Rouge � -0.5sec
* Correction d'un second "BugALaCon", j'avais gard� le texte US v1.2.1, et oubli� de remettre le texte UK de la version actuelle...

v0.92 : Bug en Duel
* GougeHelper ne se lancait pas conte un joueur humain (duel)

v0.93 : d�but de localisation allemande
* Localisation allemande partielle (textes fournis par w1cked sur CurseGaming)