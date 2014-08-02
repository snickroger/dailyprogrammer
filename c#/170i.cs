/*
+-------------------------+                                                                                                   
|  RUMMY CHECKER          |                                                                                                   
|  #170-I                 |                                                                                                   
|  http://redd.it/2a9u0a  |                                                                                                   
+-------------------------+  
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Rummy
{
    class Program
    {
        static void Main()
        {
            Console.Write("Please enter 7 cards: ");
            string initialCards = Console.ReadLine();

            Console.Write("Please enter another card: ");
            string newCard = Console.ReadLine();
            
            Hand hand = new Hand();
            hand.AddCards(initialCards);
            hand.AddCards(newCard);

            foreach (Card c in hand.Cards)
            {
                hand.CheckRun(c);
                hand.CheckSet(c);
            }

            if (hand.UncoveredCards > 1)
                Console.WriteLine("No possible winning hand.");
            else if (hand.UncoveredCards == 1)
            {
                if (!hand.Cards.Last().Covered)
                    Console.WriteLine("You've already won!");
                else
                    Console.WriteLine("Swap the new card for the {0} to win!", hand.Cards.First(a => !a.Covered));
            }
            else
                Console.WriteLine("You've already won!");
            Console.Write("Press any key to continue. ");
            Console.ReadKey(true);
        }
    }

    public class Hand
    {
        public readonly List<Card> Cards = new List<Card>();
        public int UncoveredCards { get { return Cards.Count(a => !a.Covered); } }
        
        public void AddCards(string cards)
        {
            string[] cardsSplit = cards.Split(',');
            foreach (string c in cardsSplit)
            {
                Cards.Add(new Card(c));
            }
        }

        public void CheckRun(Card startingCard)
        {
            Card card1 = FindCard(startingCard);
            Card card2 = FindCard(startingCard.NextCard());
            Card card3 = card2 != null ? FindCard(startingCard.NextCard().NextCard()) : null;

            if (card1 == null || card2 == null || card3 == null)
                return;

            card1.Covered = true;
            card2.Covered = true;
            card3.Covered = true;

            // keep going if we can

            Card cardNext = FindCard(card3.NextCard());
            while (cardNext != null)
            {
                cardNext.Covered = true;
                cardNext = FindCard(cardNext.NextCard());
            }
        }

        public void CheckSet(Card startingCard)
        {
            var cards = Cards.Where(a => a.Rank == startingCard.Rank && !a.Covered).ToList();
            if (cards.Count() < 3)
                return;

            foreach (Card c in cards)
            {
                c.Covered = true;
            }
        }
        
        private Card FindCard(Card c)
        {
            if (c == null)
                return null;
            return Cards.FirstOrDefault(a => a.Rank == c.Rank && a.Suit == c.Suit && !c.Covered);
        }
    }

    public class Card
    {
        public Suit Suit { get; set; }
        public Rank Rank { get; set; }
        public bool Covered { get; set; }

        private Card(Suit suit, Rank rank)
        {
            Suit = suit;
            Rank = rank;
        }

        public Card(string p)
        {
            Match m = Regex.Match(p, "(.*) of (.*)");
            string rank = m.Groups[1].Value;
            string suit = m.Groups[2].Value;

            Rank = (Rank)Enum.Parse(Rank.GetType(), rank);
            Suit = (Suit)Enum.Parse(Suit.GetType(), suit);

            Covered = false;
        }

        public Card NextCard()
        {
            if (Rank == Rank.King)
                return null;

            int r = (int) Rank + 1;
            return new Card(Suit, (Rank)r);
        }

        public override string ToString()
        {
            return String.Format("{0} of {1}", Rank, Suit);
        }
    }

    public enum Suit { Hearts, Diamonds, Clubs, Spades }
    public enum Rank { Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King }

}
