extends Polygon2D

var tipsList = ["Appuyez sur la touche 'L' pour: décoller de la station, atterrir sur la station, atterrir sur une planète et utiliser l'Excavatrice ainsi que la ranger.", "Appuyer sur la touche 'Espace' pour tirer des projectile qui permettent de détruire des asteroïdes et de faire des dégats.","Appuyez sur la touche 'X' pour déployer votre capteur de vibration, il vous permettra de vous diriger plus facilement vers une planète.","Plus de 500 pays sont fortement engagés dans la course à l'Energium, cette ressource est considérée comme l'avenir de l'humanité!","L'Energium peut être obtenu à partir de n'importe quel matériaux fossile (dont la terre et la roche) plus ce matériaux est compact plus il donnera d'Energium (la roche donnera donc plus d'Energium que de la terre).", "Votre vaisseau ne peut pas lui même récupérer des matériaux, en revanche, il transporte une Excavatrice capable de miner des matériaux et de les transporter jusqu'à votre vaisseau.", "Votre vaisseau n'est pas lui même capable de raffiner de l'Energium, il faut d'abord que vous rapportiez les matériaux à votre Station qui comporte un module entier pour le raffinement.","Sortir d'un champ gravitationnel d'une planète n'est pas chose aisée, en effet votre vaisseau à lui seul n'est pas assez puissant, il vous faut donc immiter les trajectoires de vrais fusées en frôlant l'atmosphère pour gagner de la vélocité."]
var i = 0;

func _ready():
	var rdm = RandomNumberGenerator.new();
	rdm.randomize();
	var idx = (rdm.randf_range(0, 7));
	i = i + 1;
	if i == 1:
		get_node("Tips").set_text(tipsList[idx]);
