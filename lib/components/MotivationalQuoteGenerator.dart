import 'dart:math';

class MotivationalQuoteGenerator {
  static List<String> quotes = [
    "«Le SIDA est une maladie qui ne discrimine pas, mais nous pouvons combattre la discrimination.» - Elizabeth Taylor",
    "«Le SIDA n'est pas une fin en soi, mais une invitation à vivre intensément.» - Pierre Bergé",
    "«Le SIDA ne définit pas une personne, sa force et son courage le font.» - Magic Johnson",
    "«Dans la lutte contre le SIDA, l'information est notre meilleur allié.» - Michel Kazatchkine",
    "«Le SIDA nous rappelle que nous sommes tous vulnérables, mais aussi que nous sommes tous capables de compassion.» - Desmond Tutu",
    "«La solidarité est notre plus grande arme contre le SIDA.» - Sidaction",
    "«Le SIDA ne peut pas briser l'espoir qui brûle en nous.» - Amfar",
    "«Chaque personne touchée par le SIDA est un héros dans sa lutte quotidienne.» - UNAIDS",
    "«Le SIDA n'est pas un arrêt, mais un nouveau départ.» - Françoise Barré-Sinoussi",
    "«La prévention du SIDA commence par l'éducation et la communication.» - Luc Montagnier",
    "«La force de l'amour est plus puissante que le SIDA.» - Act Up",
    "«La lutte contre le SIDA exige un engagement collectif et individuel.» - Michel Sidibé",
    "«Le SIDA ne doit pas être une source de honte, mais une cause de solidarité.» - Elizabeth Glaser",
    "«La recherche médicale est notre meilleur espoir pour mettre fin au SIDA.» - Françoise Barré-Sinoussi",
    "«Le SIDA ne peut pas éteindre la flamme de la vie qui brille en nous.» - Act Up",
    "«Le SIDA ne discrimine pas, mais il révèle notre capacité à aimer sans préjugés.» - Amfar",
    "«Dans la lutte contre le SIDA, nous devons unir nos forces et nos cœurs.» - Sidaction",
    "«Le SIDA nous rappelle l'importance de vivre chaque jour comme un cadeau.» - Magic Johnson",
    "«La solidarité face au SIDA est un puissant levier de changement.» - Kofi Annan",
    "«Le SIDA ne peut pas vaincre notre détermination à trouver un remède.» - UNAIDS",
    "«Le SIDA ne peut pas détruire notre espoir d'un avenir meilleur.» - Elizabeth Taylor",
    "«La stigmatisation ne doit pas être notre réponse au SIDA, mais l'empathie et l'amour.» - Desmond Tutu",
    "«Le SIDA nous rappelle que la santé est un droit fondamental pour tous.» - Sidaction",
    "«La lutte contre le SIDA exige un effort collectif et des actions concrètes.» - Françoise Barré-Sinoussi"
  ];

  static String getRandomQuote() {
    final random = Random();
    final index = random.nextInt(quotes.length);

    return quotes[index];
  }
}
