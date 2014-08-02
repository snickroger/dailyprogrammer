/*
+-------------------------+                                                                                                   
|  ALIEN SPELL CHECK      |                                                                                                   
|  #169-I                 |                                                                                                   
|  http://redd.it/29od55  |                                                                                                   
+-------------------------+  
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Alien
{
    class Program
    {
        static void Main(string[] args)
        {
            List<OffsetWord> offsetWords = new List<OffsetWord>();
            FileInfo wordFile = new FileInfo(@".\enable1.txt");
            using (StreamReader sr = new StreamReader(wordFile.OpenRead()))
            {
                while (!sr.EndOfStream)
                {
                    offsetWords.Add(new OffsetWord(sr.ReadLine()));
                }
            }

            Console.Write("Input string: ");
            string output = "", input = Console.ReadLine();
            string[] inputWords = input.Split(' ');

            foreach (string word in inputWords)
            {
                if (String.IsNullOrWhiteSpace(word))
                    continue;

                string w = word.Where(c => Char.IsLetter(c)).Aggregate("", (curr, c) => curr + c);
                bool capital = Char.IsUpper(w[0]);
                if (offsetWords.FirstOrDefault(a => a.Normal == w.ToLower()) != null)
                {
                    output += (!capital ? w : Char.ToUpper(w[0]) + w.Substring(1, w.Length-1)) + ' ';
                }
                else
                {
                    List<string> possibleWords = new List<string>();
                    possibleWords.AddRange(offsetWords.Where(a => a.LeftTwo == w.ToLower()).Select(a=>a.Normal));
                    possibleWords.AddRange(offsetWords.Where(a => a.LeftOne == w.ToLower()).Select(a => a.Normal));
                    possibleWords.AddRange(offsetWords.Where(a => a.RightOne == w.ToLower()).Select(a => a.Normal));
                    possibleWords.AddRange(offsetWords.Where(a => a.RightTwo == w.ToLower()).Select(a => a.Normal));

                    if (possibleWords.Any())
                    {
                        string pw = "{ ";
                        foreach (string s in possibleWords)
                        {
                            if (pw != "{ ")
                                pw += ", ";
                            pw += !capital ? s : Char.ToUpper(s[0]) + s.Substring(1, s.Length - 1) + ' ';
                        }
                        pw = pw.Trim() + " } ";
                        output += pw;
                    }
                    else
                    {
                        output += "{ ??? } ";
                    }
                }
            }
            Console.WriteLine(output.Trim());
            Console.ReadKey(true);
        }
    }

    public class OffsetWord
    {
        public string LeftTwo { get; private set; }
        public string LeftOne { get; private set; }
        public string Normal { get; private set; }
        public string RightOne { get; private set; }
        public string RightTwo { get; private set; }

        public OffsetWord(string word)
        {
            const string leftTwo = "kczaqsdfyghjbvuiowletxpmrn";
            const string leftOne = "lvxswdfguhjknbiopearycqztm";
            const string normal = "abcdefghijklmnopqrstuvwxyz";
            const string rightOne = "snvfrghjoklazmpqwtdyibecuz";
            const string rightTwo = "dmbgthjkplasxzqweyfuonrvix";

            Normal = word;
            foreach (char c in word)
            {
                LeftTwo += leftTwo[normal.IndexOf(c)];
                LeftOne += leftOne[normal.IndexOf(c)];
                RightOne += rightOne[normal.IndexOf(c)];
                RightTwo += rightTwo[normal.IndexOf(c)];
            }
        }
    }
}
